return {
  "zaldih/themery.nvim",
  dependencies = { 'catppuccin/nvim', 'sainnhe/everforest' },
  lazy = false,
  config = function()
    require("themery").setup({
      themes = { 'catppuccin', 'everforest' },
      livePreview = true, -- Apply theme while picking. Default to true.
    })
  end
}
