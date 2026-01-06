-- Setup lspconfig.
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.

-- UI Customization
-- vim.cmd [[autocmd! ColorScheme * highlight NormalFloat guibg=#1f2335]]
-- vim.cmd [[autocmd! ColorScheme * highlight FloatBorder guifg=white guibg=#00000000]]

-- sharp borderchars['─', '│', '─', '│', '┌', '┐', '┘', '└'],
-- rounded borderchars `['─', '│', '─', '│', '╭', '╮', '╯', '╰'],`

local function goto_definition(split_cmd)
    local util = vim.lsp.util
    local log = require("vim.lsp.log")
    local api = vim.api

    -- note, this handler style is for neovim 0.5.1/0.6, if on 0.5, call with function(_, method, result)
    local handler = function(_, result, ctx)
        if result == nil or vim.tbl_isempty(result) then
            local _ = log.info() and log.info(ctx.method, "No location found")
            return nil
        end

        if split_cmd then
            vim.cmd(split_cmd)
        end

        if vim.tbl_islist(result) then
            util.jump_to_location(result[1])

            if #result > 1 then
                util.set_qflist(util.locations_to_items(result))
                api.nvim_command("copen")
                api.nvim_command("wincmd p")
            end
        else
            util.jump_to_location(result)
        end
    end

    return handler
end

local icons = {
    Class = " ",
    Color = " ",
    Constant = " ",
    Constructor = " ",
    Enum = "了 ",
    EnumMember = " ",
    Field = " ",
    File = " ",
    Folder = " ",
    Function = " ",
    Interface = "ﰮ ",
    Keyword = " ",
    Method = "ƒ ",
    Module = " ",
    Property = " ",
    Snippet = "﬌ ",
    Struct = " ",
    Text = " ",
    Unit = " ",
    Value = " ",
    Variable = " ",
}


-- LSP settings (for overriding per client)
local handlers = {
    ["textDocument/definition"] = goto_definition('split'),
}
local kinds = vim.lsp.protocol.CompletionItemKind
for i, kind in ipairs(kinds) do
    kinds[i] = icons[kind] or kind
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local lsp_keymapping = function(client, bufnr)
    -- require("aerial").on_attach(client, bufnr) -- specially for aerial

    -- default lsp configs

    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }

    local function opt(desc, others)
        return vim.tbl_extend("force", bufopts, { desc = desc }, others or {})
    end

    local keymap = vim.keymap.set
    keymap("n", "gD", vim.lsp.buf.declaration, opt("Go to declaration"))
    keymap("n", "gd", vim.lsp.buf.definition, opt("Go to definition"))
    keymap("n", "K", vim.lsp.buf.hover, opt("Hover documentation"))
    keymap("n", "gi", vim.lsp.buf.implementation, opt("Go to implementation"))
    keymap("n", "<C-k>", vim.lsp.buf.signature_help, opt("Signature help"))
    keymap("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opt("Add workspace folder"))
    keymap("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opt("Remove workspace folder"))
    keymap("n", "<space>wl", function()
        vim.lsp.buf.list_workspace_folders()
    end, opt("List workspace folders"))
    keymap("n", "<space>D", vim.lsp.buf.type_definition, opt("Go to type definition"))
    keymap("n", "<space>rn", vim.lsp.buf.rename, opt("Rename symbol"))
    keymap("n", "<space>ca", vim.lsp.buf.code_action, opt("Code action"))
    keymap("n", "gr", vim.lsp.buf.references, opt("Go to references"))
    keymap("n", "<space>f", function() vim.lsp.buf.format({ async = true }) end, opt("Format buffer"))

    -- Diagnostics
    vim.diagnostic.config({ virtual_text = true })
end

vim.ui.select = require("popui.ui-overrider")

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        local bufnr = ev.buf
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if not client then
            return
        end
        lsp_keymapping(client, bufnr)
    end
})

local init_lsp = function(lsp_name, config)
    local ok, mod = pcall(require, 'lsp.' .. lsp_name)
    if ok then
        vim.lsp.enable(lsp_name)
        vim.lsp.config(lsp_name, mod)
    else
        vim.notify("LSP " .. lsp_name .. " not found")
    end
end

local servers = { "clangd", "lua_ls", "cmake", "pyright", "mlir_lsp_server", "tblgen_lsp_server" }
for _, server in pairs(servers) do
    init_lsp(server)
end
