require('telescope').setup({
	extensions = {
		aerial = {
			-- Display symbols as <root>.<parent>.<symbol>
			show_nesting = true
		},
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			-- the default case_mode is "smart_case"
		}
	},
	pickers = {
		find_files = {
			hidden = true
		}
	}
})

-- require('telescope').load_extension('aerial')
require("telescope").load_extension("notify")
require('telescope').load_extension('fzf')
require('telescope').load_extension('live_grep_args')
vim.keymap.set("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
