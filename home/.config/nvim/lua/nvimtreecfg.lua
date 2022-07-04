require("nvim-tree").setup({
  sort_by = "case_sensitive",
  git = {
    enable = false     -- performace issuse
  },
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
  },
  renderer = {
    group_empty = false,
  },
  filters = {
    dotfiles = false,
  },
})
