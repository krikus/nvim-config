return {
  "rcarriga/nvim-notify",
  config = function()
    vim.notify = require("notify")
    vim.notify.setup({
      background_colour = "#333333",
    })
  end,
}
