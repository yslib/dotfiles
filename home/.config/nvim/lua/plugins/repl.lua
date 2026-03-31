local M = {}

local Terminal = require("toggleterm.terminal").Terminal

M.config = {
    languages = {},
    keymap = "<C-e>",
    default_direction = "vertical",
}

local terminals = {}
local augroup = vim.api.nvim_create_augroup("ReplManager", { clear = true })

local function merge_opts(defaults, opts)
    return vim.tbl_deep_extend("force", defaults or {}, opts or {})
end

local function notify(message, level)
    vim.notify(("repl_manager: %s"):format(message), level or vim.log.levels.INFO)
end

local function normalize_filetypes(lang)
    if type(lang.filetypes) == "table" then
        return lang.filetypes
    end

    if type(lang.filetype) == "string" and lang.filetype ~= "" then
        return { lang.filetype }
    end

    return {}
end

local function get_lang_by_filetype(ft)
    for name, lang in pairs(M.config.languages) do
        for _, candidate in ipairs(normalize_filetypes(lang)) do
            if candidate == ft then
                return name, lang
            end
        end
    end

    return nil, nil
end

local function is_terminal_alive(term)
    if not term or type(term.job_id) ~= "number" or term.job_id <= 0 then
        return false
    end

    local ok, result = pcall(vim.fn.jobwait, { term.job_id }, 0)
    return ok and type(result) == "table" and result[1] == -1
end

local function create_terminal(name, lang)
    local term = Terminal:new({
        cmd = lang.cmd,
        direction = lang.direction or M.config.default_direction or "vertical",
        hidden = true,
        close_on_exit = false,
        count = lang.count,
        dir = lang.dir,
        env = lang.env,
        display_name = lang.display_name or name,
        on_open = function()
            if lang.startinsert ~= false then
                vim.cmd("startinsert!")
            end

            if type(lang.on_open) == "function" then
                lang.on_open()
            end
        end,
        on_close = function()
            if type(lang.on_close) == "function" then
                lang.on_close()
            end
        end,
    })

    terminals[name] = term
    return term
end

function M.get_terminal(name)
    local lang = M.config.languages[name]
    if not lang then
        notify(("unknown language '%s'"):format(name), vim.log.levels.ERROR)
        return nil, nil
    end

    if type(lang.cmd) ~= "string" or lang.cmd == "" then
        notify(("language '%s' is missing a repl command"):format(name), vim.log.levels.ERROR)
        return nil, nil
    end

    local term = terminals[name]
    if not is_terminal_alive(term) then
        term = create_terminal(name, lang)
    end

    return term, lang
end

local function ensure_terminal_open(term)
    local was_open = term:is_open()
    if not was_open then
        term:open()
    end

    return was_open
end

function M.open(name)
    local term = select(1, M.get_terminal(name))
    if not term then
        return
    end

    ensure_terminal_open(term)
end

function M.toggle(name)
    local term = select(1, M.get_terminal(name))
    if not term then
        return
    end

    term:toggle()
end

local function get_buffer_lines(bufnr)
    return vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
end

local function get_visual_lines()
    return vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), {
        type = vim.fn.mode(),
    })
end

local function is_empty_lines(lines)
    return #lines == 0 or (#lines == 1 and lines[1] == "")
end

local function default_build_payload(lines)
    return table.concat(lines, "\n")
end

local function exit_visual_mode()
    local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
    vim.api.nvim_feedkeys(esc, "nx", false)
end

local function get_lines(source, bufnr)
    if source == "visual" then
        return get_visual_lines()
    end

    return get_buffer_lines(bufnr)
end

local function build_payload(lang, lines, ctx)
    if type(lang.build_payload) == "function" then
        return lang.build_payload(lines, ctx)
    end

    return default_build_payload(lines)
end

local function send_payload(lang, term, payload, ctx)
    if type(lang.send) == "function" then
        lang.send(term, payload, ctx)
        return
    end

    term:send(payload)
end

function M.send(name, opts)
    local term, lang = M.get_terminal(name)
    if not term then
        return
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local source = (opts and opts.source) or "buffer"
    local lines = get_lines(source, bufnr)
    if is_empty_lines(lines) then
        notify("nothing to send", vim.log.levels.WARN)
        return
    end

    if source == "visual" then
        exit_visual_mode()
    end

    local ctx = {
        bufnr = bufnr,
        filetype = vim.bo[bufnr].filetype,
        language = name,
        source = source,
        lines = lines,
    }

    local ok, payload_or_err = pcall(build_payload, lang, lines, ctx)
    if not ok then
        notify(
            ("failed to build payload for '%s': %s"):format(name, payload_or_err),
            vim.log.levels.ERROR
        )
        return
    end

    local payload = payload_or_err
    if payload == nil or payload == "" or (type(payload) == "table" and vim.tbl_isempty(payload)) then
        notify("nothing to send", vim.log.levels.WARN)
        return
    end

    local was_open = ensure_terminal_open(term)
    local perform_send = function()
        local send_ok, send_err = pcall(send_payload, lang, term, payload, ctx)
        if not send_ok then
            notify(
                ("failed to send payload for '%s': %s"):format(name, send_err),
                vim.log.levels.ERROR
            )
        end
    end

    if was_open then
        perform_send()
        return
    end

    vim.schedule(perform_send)
end

function M.send_for_current_buffer(opts)
    local ft = vim.bo.filetype
    local name = select(1, get_lang_by_filetype(ft))
    if not name then
        notify(("no repl configured for filetype '%s'"):format(ft), vim.log.levels.WARN)
        return
    end

    M.send(name, opts)
end

function M.open_for_current_buffer()
    local ft = vim.bo.filetype
    local name = select(1, get_lang_by_filetype(ft))
    if not name then
        return
    end

    M.open(name)
end

local function set_buffer_keymaps(bufnr, lang_name)
    vim.keymap.set("n", M.config.keymap, function()
        M.send(lang_name, { source = "buffer" })
    end, {
        buffer = bufnr,
        noremap = true,
        silent = true,
        desc = ("Send buffer to %s REPL"):format(lang_name),
    })

    vim.keymap.set("x", M.config.keymap, function()
        M.send(lang_name, { source = "visual" })
    end, {
        buffer = bufnr,
        noremap = true,
        silent = true,
        desc = ("Send selection to %s REPL"):format(lang_name),
    })
end

local function collect_patterns()
    local seen = {}
    local patterns = {}

    for _, lang in pairs(M.config.languages) do
        for _, ft in ipairs(normalize_filetypes(lang)) do
            if not seen[ft] then
                seen[ft] = true
                table.insert(patterns, ft)
            end
        end
    end

    return patterns
end

local function setup_autocmd()
    vim.api.nvim_clear_autocmds({ group = augroup })

    local patterns = collect_patterns()
    if vim.tbl_isempty(patterns) then
        return
    end

    vim.api.nvim_create_autocmd("FileType", {
        group = augroup,
        pattern = patterns,
        callback = function(args)
            local ft = vim.bo[args.buf].filetype
            local name = select(1, get_lang_by_filetype(ft))
            if not name then
                return
            end

            set_buffer_keymaps(args.buf, name)
        end,
    })
end

function M.setup(opts)
    M.config = merge_opts(M.config, opts)

    if type(M.config.languages) ~= "table" then
        notify("config.languages must be a table", vim.log.levels.ERROR)
        return
    end

    setup_autocmd()
end

return M
