return {
  "mbbill/undotree",
  cmd = { "UndotreeToggle", "UndotreeShow" },
  keys = {
    { "<leader>u", vim.cmd.UndotreeToggle, desc = "Toggle Undotree" },
  },
}
