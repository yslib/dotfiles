vim.o.winborder = "rounded"

local keymap = vim.keymap.set


-- telescope keybinds
keymap('n', '<leader>ff', function() require('telescope.builtin').find_files() end, { desc = 'Find files' })
keymap('n', '<leader>fg', function() require('telescope.builtin').live_grep() end, { desc = 'Live grep' })
keymap('n', '<leader>fc', function() require('telescope.builtin').grep_string() end, { desc = 'Grep string' })
keymap('n', '<leader>fh', function() require('telescope.builtin').help_tags() end, { desc = 'Help tags' })
keymap('n', '<leader>fb', function() require('telescope.builtin').buffers() end, { desc = 'Buffers' })
keymap('n', '<leader>fs', function() require('telescope.builtin').lsp_document_symbols() end,
    { desc = 'LSP Document Symbols' })

keymap('n', '<leader>r', function() require('telescope.builtin').reloader() end, { desc = 'Reload' })
keymap('n', '<leader>dh', function() require('dap.ui.variables').hover() end, { desc = 'DAP Hover Variables' })
keymap('n', '<leader>dr', function() require('nvimdapcfg').reload_dap_config() end, { desc = 'Reload DAP Config' })


-- bufferline.nvim

keymap('n', '<leader>1', '<Cmd>BufferLineGoToBuffer 1<CR>', { silent = true })
keymap('n', '<leader>2', '<Cmd>BufferLineGoToBuffer 2<CR>', { silent = true })
keymap('n', '<leader>3', '<Cmd>BufferLineGoToBuffer 3<CR>', { silent = true })
keymap('n', '<leader>4', '<Cmd>BufferLineGoToBuffer 4<CR>', { silent = true })
keymap('n', '<leader>5', '<Cmd>BufferLineGoToBuffer 5<CR>', { silent = true })
keymap('n', '<leader>6', '<Cmd>BufferLineGoToBuffer 6<CR>', { silent = true })
keymap('n', '<leader>7', '<Cmd>BufferLineGoToBuffer 7<CR>', { silent = true })
keymap('n', '<leader>8', '<Cmd>BufferLineGoToBuffer 8<CR>', { silent = true })
keymap('n', '<leader>9', '<Cmd>BufferLineGoToBuffer 9<CR>', { silent = true })

-- reload .nvim
vim.keymap.set('n', '<Leader>dd', function()
    local config_paths = { "./.nvim/nvim.lua", "./.nvim.lua" }
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

    vim.notify("[nvim] Found nvim configuration at." .. project_config, vim.log.levels.INFO, nil)
    require('dap').adapters = (function() return {} end)()
    require('dap').configurations = (function() return {} end)()
    vim.cmd(":luafile " .. project_config)
end)
