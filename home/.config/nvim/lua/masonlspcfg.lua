local mason_lspconfig = require "mason-lspconfig"
local lspconfigcfg = require "lspconfigcfg"
mason_lspconfig.setup({
	ensure_installed = lspconfigcfg.lsp_servers
})


mason_lspconfig.setup_handlers({
	function(server_name)
		lspconfigcfg.setup_handler(server_name)
	end,
	["rust_analyzer"] = function()
		--when setup rust-analyzer,  override with rust-tools

		local prefix = require('mason-registry').get_package('codelldb'):get_install_path() ..
		    "/extension/adapter/"

		-- on windows
		local codelldb = prefix .. "codelldb.exe"
		local codelldblib = prefix .. "codelldb.dll"
		local rt = require("rust-tools")
		local rust_tools_opts = {
			server = {
				on_attach = function(client, bufnr)
					print("attach on rust-tools")
					lspconfigcfg.lsp_on_attach(client, bufnr)
					-- Hover actions
					vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions,
						{ buffer = bufnr })
					-- Code action groups
					vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group,
						{ buffer = bufnr })
				end,
				flags = {
					debounce_text_changes = 150,
				},
			},
			hover_actions = {
				-- the border that is used for the hover window
				-- see vim.api.nvim_open_win()
				border = {
					{ "╭", "FloatBorder" },
					{ "─", "FloatBorder" },
					{ "╮", "FloatBorder" },
					{ "│", "FloatBorder" },
					{ "╯", "FloatBorder" },
					{ "─", "FloatBorder" },
					{ "╰", "FloatBorder" },
					{ "│", "FloatBorder" },
				},

				-- Maximal width of the hover window. Nil means no max.
				max_width = nil,

				-- Maximal height of the hover window. Nil means no max.
				max_height = nil,

				-- whether the hover action window gets automatically focused
				-- default: false
				auto_focus = false,
			},
		}
		rt.setup(rust_tools_opts)
	end
})
