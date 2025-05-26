return {
  "aznhe21/actions-preview.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    vim.keymap.set({ "n", "v" }, "<leader>ca", require("actions-preview").code_actions)
  end,
}
