local ll = { "bash", "c", "cpp", "css", "html", "javascript", "json", "lua", "python", "rust", "toml", "typescript",
    "yaml", "vim", "tablegen", "mlir" };

-- main branch of treesitter need tree-sitter cli to build parser, the recommand way to install it is using cargo or npm
require 'nvim-treesitter'.setup {
    -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
    install_dir = vim.fn.stdpath('data') .. '/site',
}
require 'nvim-treesitter'.install(ll)

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'bash', 'c', 'cpp', 'css', 'html', 'javascript', 'json', 'lua', 'python', 'rust', 'toml',
      'typescript', 'yaml', 'vim', 'tablegen', 'mlir' },
  callback = function() vim.treesitter.start() end,
})
