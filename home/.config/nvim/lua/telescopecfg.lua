require('telescope').setup({
    defaults = {
        layout_strategy = 'vertical',
    },
    extensions = {
        fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
        },
        ["ui-select"] = {
            require("telescope.themes").get_dropdown {
                -- even more opts
            }
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
require('telescope').load_extension('ui-select')
local keymap = vim.keymap.set


keymap('n', '<leader>ff', function() require('telescope.builtin').find_files() end, { desc = 'Find files' })
keymap('n', '<leader>fg', function() require('telescope.builtin').live_grep() end, { desc = 'Live grep' })
keymap("n", "<leader>fag", function()
    require('telescope').extensions.live_grep_args.live_grep_args()
end, { desc = 'Live grep with args' })
keymap('n', '<leader>fc', function() require('telescope.builtin').grep_string() end, { desc = 'Telescope Cursor Grep' })
keymap('n', '<leader>fh', function() require('telescope.builtin').help_tags() end, { desc = 'Telescope Help tags' })
keymap('n', '<leader>fb', function() require('telescope.builtin').buffers() end, { desc = 'Telescope Buffers' })
keymap('n', '<leader>fd', function() require('telescope').extensions.aerial.aerial() end,
    { desc = 'LSP Document Symbols' })

keymap('n', '<leader>fs', function() require('telescope.builtin').lsp_dynamic_workspace_symbols() end,
    { desc = 'LSP Workspace Symbols' })

keymap('n', '<leader>fk', function() require('telescope.builtin').keymaps() end,
    { desc = 'Telescope Keymaps' })

keymap('n', '<leader>ci', function() require('telescope.builtin').lsp_incoming_calls() end,
    { desc = 'LSP Incomming call' })

keymap('n', '<leader>co', function() require('telescope.builtin').lsp_outgoing_calls() end,
    { desc = 'LSP Outgoing calls' })


keymap('n', '<leader>r', function() require('telescope.builtin').reloader() end, { desc = 'Reload' })
