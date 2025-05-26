return {
  "savq/melange-nvim",
  config = function()
    local function ColorMyTerm(color)
      color = color or "melange"
      vim.cmd.colorscheme(color)

      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    end

    ColorMyTerm()
  end,
}
