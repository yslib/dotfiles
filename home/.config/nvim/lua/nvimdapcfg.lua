require("dapui").setup()

local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end

dap.listeners.after.event_terminated["dapui_config"] = function()
	dapui.close()
end

dap.listeners.after.event_exited["dapui_config"] = function()
	dapui.close()
end


-- search per-project nvim-dap config
local config_paths = {"./.nvim-dap/nvim-dap.lua", "./.nvim-dap.lua", "./.nvim/nvim-dap.lua"}
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


-- config lldb
dap.adapters.codelldb = {
	type = 'server',
	port = "13000",
	executable = {
		-- CHANGE THIS to your path!
		command = '/home/ysl/codelldb/extension/adapter/codelldb',
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
			return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'runtime')
		end,
		cwd = '${workspaceFolder}',
		stopOnEntry = false,
	},
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp
