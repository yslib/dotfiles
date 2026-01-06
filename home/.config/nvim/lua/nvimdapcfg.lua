require("dapui").setup()
require("nvim-dap-virtual-text").setup {
    enabled = true,                     -- enable this plugin (the default)
    enabled_commands = true,            -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
    highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
    highlight_new_as_changed = false,   -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
    show_stop_reason = true,            -- show stop reason when stopped for exceptions
    commented = false,                  -- prefix virtual text with comment string
    only_first_definition = true,       -- only show virtual text at first definition (if there are multiple)
    all_references = false,             -- show virtual text on all all references of the variable (not only definitions)
    --- A callback that determines how a variable is displayed or whether it should be omitted
    --- @param variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
    --- @param _buf number
    --- @param _stackframe dap.StackFrame https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
    --- @param _node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
    --- @return string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
    display_callback = function(variable, _buf, _stackframe, _node)
        return variable.name .. ' = ' .. variable.value
    end,

    -- experimental features:
    virt_text_pos = 'eol',  -- position of virtual text, see `:h nvim_buf_set_extmark()`
    all_frames = false,     -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
    virt_lines = false,     -- show virtual lines instead of virtual text (will flicker!)
    virt_text_win_col = nil -- position the virtual text at a fixed window column (starting from the first text column) ,
    -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
}

local dap = require("dap");

local dapui = require("dapui")

-- let add dap-ui to listeners of dap
dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open({ reset = true })
end

dap.listeners.after.event_terminated["dapui_config"] = function()
    dapui.close()
end

dap.listeners.after.event_exited["dapui_config"] = function()
    dapui.close()
end


function copy_to_clipboard(text)
    vim.fn.setreg('+', text)
    if os.getenv("TMUX") ~= nil then
        -- running inside tmux, use tmux to set clipboard
        local cmd = string.format("echo -n %s | tmux load-buffer -", text)
        vim.fn.system(cmd)
    end
end

-- dap keybinds
vim.keymap.set('n', '<F6>', function() require('dap').continue() end)
vim.keymap.set('n', '<Leader>dx', function() require('dap').close() end)
vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
vim.keymap.set('n', '<F9>', function()
    require('dap').toggle_breakpoint()
    copy_to_clipboard(
        string.format("%s:%d", vim.fn.expand('%:p'), vim.fn.line('.')))
end)
vim.keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint(); end)
vim.keymap.set('n', '<Leader>lp',
    function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
vim.keymap.set('n', '<Leader>dc', function() require('dap').run_to_cursor() end)
vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function() require('dap.ui.widgets').hover() end)
vim.keymap.set({ 'n', 'v' }, '<Leader>dp', function() require('dap.ui.widgets').preview() end)
vim.keymap.set('n', '<Leader>df',
    function()
        local widgets = require('dap.ui.widgets')
        widgets.centered_float(widgets.frames)
    end)
vim.keymap.set('n', '<Leader>ds', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.scopes)
end)

-- dapui keymapping
vim.keymap.set('n', '<Leader>dw', function() require('dapui').elements.watches.add() end)
vim.keymap.set('n', '<Leader>de', function() require('dapui').eval(nil, { enter = true }) end)

return M
