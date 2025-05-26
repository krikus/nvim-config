return {
  "rcarriga/nvim-notify",
  config = function()
    vim.notify = require("notify")
    vim.notify.setup({
      background_color = "#000000"
    })
  end,
}
