local M = {}

M.change_theme = function(theme)
  vim.cmd.colorscheme(theme)

  -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
--   "savq/melange-nvim",
  "mellow-theme/mellow.nvim",
  config = function()
    -- vim.g.mellow_transparent = true
    M.change_theme("mellow")
  end
}
