-- lua/plugins/memo/init.lua
local M = {}

local defaults = {
  notes_path = vim.fn.stdpath("config") .. "/lua/plugins/memo/note.lua",
  width_ratio = 0.72,
  height_ratio = 0.60,
}

M.config = {}

local function load_notes()
  local ok, notes = pcall(dofile, M.config.notes_path)

  if not ok then
    vim.notify("nvim-memo: failed to load " .. M.config.notes_path, vim.log.levels.WARN)
    return {}
  end

  if type(notes) ~= "table" then
    vim.notify("nvim-memo: notes file must return a table", vim.log.levels.ERROR)
    return {}
  end

  return notes
end

local function append_multiline(lines, text)
  if not text or text == "" then
    return
  end

  local parts = vim.split(text, "\n", {
    plain = true,
    trimempty = false,
  })

  for _, line in ipairs(parts) do
    table.insert(lines, line)
  end
end

local function normalize_lines(lines)
  local result = {}

  for _, item in ipairs(lines) do
    item = tostring(item or "")

    local parts = vim.split(item, "\n", {
      plain = true,
      trimempty = false,
    })

    for _, line in ipairs(parts) do
      table.insert(result, line)
    end
  end

  return result
end

local function note_to_lines(note)
  local lines = {}

  table.insert(lines, "# " .. (note.title or "Untitled"))
  table.insert(lines, "")
  table.insert(lines, "```vim")
  table.insert(lines, note.cmd or "")
  table.insert(lines, "```")

  if note.desc and note.desc ~= "" then
    table.insert(lines, "")
    append_multiline(lines, note.desc)
  end

  if note.tags and #note.tags > 0 then
    table.insert(lines, "")
    table.insert(lines, "tags: " .. table.concat(note.tags, ", "))
  end

  return lines
end

local function all_notes_to_lines(notes)
  local lines = {}

  for i, note in ipairs(notes) do
    table.insert(lines, string.format("## %d. %s", i, note.title or "Untitled"))
    table.insert(lines, "")
    table.insert(lines, "```vim")
    table.insert(lines, note.cmd or "")
    table.insert(lines, "```")

    if note.desc and note.desc ~= "" then
      table.insert(lines, "")
      table.insert(lines, note.desc)
    end

    if note.tags and #note.tags > 0 then
      table.insert(lines, "")
      table.insert(lines, "tags: " .. table.concat(note.tags, ", "))
    end

    table.insert(lines, "")
    table.insert(lines, "---")
    table.insert(lines, "")
  end

  return lines
end

function M.show_float(lines)
  lines = normalize_lines(lines)
  local buf = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].filetype = "markdown"
  vim.bo[buf].modifiable = false

  local width = math.floor(vim.o.columns * M.config.width_ratio)
  local height = math.floor(vim.o.lines * M.config.height_ratio)

  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " Neovim Memo ",
    title_pos = "center",
  })

  vim.keymap.set("n", "q", function()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end, {
    buffer = buf,
    silent = true,
    nowait = true,
    desc = "Close nvim-memo window",
  })
end

function M.show_all()
  local notes = load_notes()
  M.show_float(all_notes_to_lines(notes))
end

function M.show_note(note)
  M.show_float(note_to_lines(note))
end

function M.edit()
  vim.cmd.edit(M.config.notes_path)
end

function M.pick(opts)
  opts = opts or {}

  local ok, telescope = pcall(require, "telescope")
  if not ok then
    vim.notify("nvim-memo: telescope.nvim is not installed", vim.log.levels.ERROR)
    return
  end

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  local notes = load_notes()

  pickers.new(opts, {
    prompt_title = "Neovim Memo",

    finder = finders.new_table({
      results = notes,

      entry_maker = function(note)
        local tags = note.tags and table.concat(note.tags, " ") or ""

        return {
          value = note,
          display = string.format("%s  [%s]", note.title or "Untitled", tags),
          ordinal = table.concat({
            note.title or "",
            note.cmd or "",
            note.desc or "",
            tags,
          }, " "),
        }
      end,
    }),

    sorter = conf.generic_sorter(opts),

    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        M.show_note(entry.value)
      end)

      local copy_cmd = function()
        local entry = action_state.get_selected_entry()
        if entry and entry.value and entry.value.cmd then
          vim.fn.setreg("+", entry.value.cmd)
          vim.notify("Copied: " .. entry.value.cmd)
        end
      end

      map("i", "<C-y>", copy_cmd)
      map("n", "<C-y>", copy_cmd)

      return true
    end,
  }):find()
end

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", defaults, opts or {})

  vim.api.nvim_create_user_command("NvimMemo", function()
    M.show_all()
  end, {
    desc = "Show all Neovim command memos",
  })

  vim.api.nvim_create_user_command("NvimMemoPick", function()
    M.pick()
  end, {
    desc = "Search Neovim command memos with Telescope",
  })

  vim.api.nvim_create_user_command("NvimMemoEdit", function()
    M.edit()
  end, {
    desc = "Edit Neovim command memos",
  })

  vim.keymap.set("n", "<leader>?", ":NvimMemoPick<CR>", { desc = "Show Neovim memos" })
end

return M
