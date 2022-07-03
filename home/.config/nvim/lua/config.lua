----------------------- All language servers
local servers = { "pyright", "tsserver", "rust_analyzer", "clangd", "sumneko_lua" }

require("nvim-tree").setup({})
require("Comment").setup({})

----------------------- cmp-nvim configuration
local cmp = require("cmp")

cmp.setup({
	experimental = {
		ghost_text = true,
	},
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
			-- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
			-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
			-- require'snippy'.expand_snippet(args.body) -- For `snippy` users.
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "vsnip" }, -- For vsnip users.
		{ name = "nvim_lsp_signature_help" },
		-- { name = 'luasnip' }, -- For luasnip users.
		-- { name = 'ultisnips' }, -- For ultisnips users.
		-- { name = 'snippy' }, -- For snippy users.
	}, {
		{ name = "buffer" },
	}),
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})

-- Setup lspconfig.
local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.

for _, lsp in ipairs(servers) do
	require("lspconfig")[lsp].setup({
		capabilities = capabilities,
	})
end


local nvim_lsp = require("lspconfig")

-- UI Customization
vim.cmd [[autocmd! ColorScheme * highlight NormalFloat guibg=#1f2335]]
vim.cmd [[autocmd! ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]]
local border = {
      {"+", "FloatBorder"},
      {"▔", "FloatBorder"},
      {"+", "FloatBorder"},
      {"▕", "FloatBorder"},
      {"+", "FloatBorder"},
      {"▁", "FloatBorder"},
      {"+", "FloatBorder"},
      {"▏", "FloatBorder"},
}

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
local handlers =  {
  ["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, {border = border}),
  ["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, {border = border }),
  ["textDocument/definition"] = goto_definition('split'),
}
local kinds = vim.lsp.protocol.CompletionItemKind
for i, kind in ipairs(kinds) do
kinds[i] = icons[kind] or kind
end


-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	require("aerial").on_attach(client, bufnr) -- specially for aerial

	-- default lsp configs

	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set("n", "<space>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
	vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
	vim.keymap.set("n", "<space>f", vim.lsp.buf.formatting, bufopts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
--
local servers = { "pyright", "tsserver", "clangd", "sumneko_lua" }
for _, lsp in ipairs(servers) do
	nvim_lsp[lsp].setup({
		on_attach = on_attach,
		handlers = handlers,
		flags = {
			debounce_text_changes = 150,
		},
	})
end

local extension_path = "C:/Users/ysl/.vscode/extensions/vadimcn.vscode-lldb-1.6.10/adapter/"
local codelldb_path = extension_path .. "codelldb.exe"
local liblldb_path = extension_path .. "liblldb.dll"
local rust_tools_opts = {
	-- ... other configs
	dap = {
		adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
	},
	server = {
		on_attach = on_attach,
		flags = {
			debounce_text_changes = 150,
		},
	},
}

require("rust-tools").setup(rust_tools_opts)
require("rust-tools.hover_actions").hover_actions()

-- require('rust-tools')

vim.ui.select = require("popui.ui-overrider")
