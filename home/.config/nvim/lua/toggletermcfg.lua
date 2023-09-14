local tt = require('toggleterm')
tt.setup {
	size = function(t)
		if t.direction == 'horizontal' then
			return 15
		elseif t.direction == 'vertical' then
			return vim.o.columns * 0.35
		end
	end,
	open_mapping = [[<c-\>]],
	shade_terminals = false,
	float_opts = {
		-- The border key is *almost* the same as 'nvim_open_win'
		-- see :h nvim_open_win for details on borders however
		-- the 'curved' border is a custom border type
		-- not natively supported but implemented in this plugin.
		border = 'curved',
		winblend = 3,
	},
	direction = 'horizontal',
}

function _G.set_terminal_keymaps()
	local opts = { noremap = true }
	vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
	-- vim.api.nvim_buf_set_keymap(0, 't', 'jk', [[<C-\><C-n>]], opts)
	-- vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
	-- vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
	-- vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
	-- vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
end

local u = require "utils"
u.map_key('n', "<F7>", ":ToggleTerm direction=float<CR>", { silent = true })
u.map_key('n', "<Leader>tv", ":ToggleTerm direction=vertical<CR>", { silent = true })
u.map_key('n', "<Leader>th", ":ToggleTerm direction=horizontal<CR>", { silent = true })

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')


-- Lazygit integrated with ToggleTerm
--
-- local Terminal = require('toggleterm.terminal').Terminal
-- local lazygit  = Terminal:new({ cmd = "lazygit", hidden = true, direction = 'float' })

-- function _lazygit_toggle()
-- 	lazygit:toggle()
-- end
--
-- vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })
