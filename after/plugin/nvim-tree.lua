require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 40,
  },
  renderer = {
    group_empty = true,
    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
    },
  },
  filters = {
    dotfiles = false,
    custom = {
      "^.git$",
      "^.DS_Store$",
    },
  },
})

vim.keymap.set('n', "<leader>gt", function() vim.cmd.NvimTreeFindFile() end)

