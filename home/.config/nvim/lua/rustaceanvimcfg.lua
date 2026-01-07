vim.g.rustaceanvim = {
    server = {
        on_attach = function(client, bufnr)
            local bufopts = { noremap = true, silent = true, buffer = bufnr }
            local function opt(desc, others)
                return vim.tbl_extend("force", bufopts, { desc = desc }, others or {})
            end

            -- override default lsp keymaps for rust files
            vim.keymap.set('n', '<leader>ca', function() vim.cmd.RustLsp('codeAction') end, opt("Rust Code Actions"))
            vim.keymap.set('n', 'K', function() vim.cmd.RustLsp({ 'hover', 'actions' }) end, opt("Rust Hover Actions"))

            vim.keymap.set('n', '<space>d', function() vim.cmd.RustLsp({ 'renderDiagnostic' }) end,
                opt("Rust Render Diagnostic"))

            vim.keymap.set('n', '<space>e', function() vim.cmd.RustLsp({ 'expandMacro' }) end,
                opt("Rust Expand Macro"))

            vim.keymap.set('n', '<F5>', function() vim.cmd.RustLsp({ 'runnables' }) end,
                opt("Rust Runnables"))

            vim.keymap.set('n', '<F4>', function() vim.cmd.RustLsp({ 'testables' }) end,
                opt("Rust Testables"))
        end,
    }
}
