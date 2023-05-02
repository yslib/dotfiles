require("dapui").setup()
require("nvim-dap-virtual-text").setup {
	enabled = true,              -- enable this plugin (the default)
	enabled_commands = true,     -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
	highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
	highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
	show_stop_reason = true,     -- show stop reason when stopped for exceptions
	commented = false,           -- prefix virtual text with comment string
	only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
	all_references = false,      -- show virtual text on all all references of the variable (not only definitions)
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
	virt_text_pos = 'eol', -- position of virtual text, see `:h nvim_buf_set_extmark()`
	all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
	virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
	virt_text_win_col = nil -- position the virtual text at a fixed window column (starting from the first text column) ,
	-- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
}

local dap, dapui = require("dap"), require("dapui")

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


-- config lldb
-- install lldbcode:
--
-- Install codelldb:
-- Download the VS Code extension.
-- Unpack it. .vsix is a zip file and you can use unzip to extract the contents.
--
dap.adapters.codelldb = {
	type = 'server',
	port = "13000",
	executable = {
		-- CHANGE THIS to your path!
		command = 'codelldb',
		args = { "--port", "13000" },
		-- On windows you may have to uncomment this:
		-- detached = false,
	}
}

dap.configurations.cpp = {
	{
		name = "Launch file",
		type = "codelldb",
		request = "launch",
		program = function()
			return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/')
		end,
		cwd = '${workspaceFolder}',
		stopOnEntry = false,
	},
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp




M = {}

-- search per-project nvim-dap config
M.reload_dap_config = function()
	local config_paths = { "./.nvim-dap/nvim-dap.lua", "./.nvim-dap.lua", "./.nvim/nvim-dap.lua" }
	if not pcall(require, "dap") then
		vim.notify("[nvim-dap] Could not find nvim-dap, make sure you have installed it.",
			vim.log.levels.ERROR, nil)
		return
	end

	local project_config = ""
	for _, p in ipairs(config_paths) do
		local f = io.open(p)
		if f ~= nil then
			f:close()
			project_config = p
			break
		end
	end
	if project_config == "" then
		return
	end

	vim.notify("[nvim-dap] Found nvim-dap configuration at." .. project_config, vim.log.levels.INFO, nil)
	require('dap').adapters = (function() return {} end)()
	require('dap').configurations = (function() return {} end)()
	vim.cmd(":luafile " .. project_config)
end

-- refresh local dap config
vim.keymap.set('n', '<Leader>dd', function()
	M.reload_dap_config()
end)

-- dap keybinds
vim.keymap.set('n', '<F5>', function() require('dap').continue() end)
vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
vim.keymap.set('n', '<F9>', function() require('dap').toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint() end)
vim.keymap.set('n', '<Leader>lp',
	function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
vim.keymap.set('n', '<Leader>dc', function() require('dap').run_to_cursor() end)
vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function()
	require('dap.ui.widgets').hover()
end)
vim.keymap.set({ 'n', 'v' }, '<Leader>dp', function()
	require('dap.ui.widgets').preview()
end)
vim.keymap.set('n', '<Leader>df', function()
	local widgets = require('dap.ui.widgets')
	widgets.centered_float(widgets.frames)
end)
vim.keymap.set('n', '<Leader>ds', function()
	local widgets = require('dap.ui.widgets')
	widgets.centered_float(widgets.scopes)
end)


return M
