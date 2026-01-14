-- https://github.com/harrisoncramer/gitlab.nvim/blob/main/doc/gitlab.nvim.txt
return {
  "harrisoncramer/gitlab.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "stevearc/dressing.nvim", -- Recommended but not required. Better UI for pickers.
    "nvim-tree/nvim-web-devicons", -- Recommended but not required. Icons in discussion tree.
  },
  build = function () require("gitlab.server").build(true) end, -- Builds the Go binary
  config = function()
    local gl = require("gitlab")
    gl.setup()
    -- set <leader>gr as trigger for choose_merge_request function
    vim.keymap.set("n", "<leader>glrb", gl.choose_merge_request)
    vim.keymap.set("n", "<leader>glrn", gl.review)
  end,
}
