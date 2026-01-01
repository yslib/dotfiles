local ll = { "bash", "c", "cpp", "css", "html", "javascript", "json", "lua", "python", "rust", "toml", "typescript",
    "yaml", "vim" };
require 'nvim-treesitter'.setup {
    -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
    install_dir = vim.fn.stdpath('data') .. '/site'
}
require 'nvim-treesitter'.install(ll)
