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
		local rust_tools_opts = {
			server = {
				on_attach = lspconfigcfg.lsp_on_attach,
				flags = {
					debounce_text_changes = 150,
				},
			},
		}
		require("rust-tools").setup(rust_tools_opts)
		require("rust-tools.hover_actions").hover_actions()
	end
})
