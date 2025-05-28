return {
  "sontungexpt/sttusline",
  branch = "table_version",
  event = { "BufEnter" },
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("sttusline").setup({
      on_attach = function(_) end,
      statusline_color = "StatusLine",
      disabled = {
        filetypes = { "NvimTree" },
        buftypes = { "terminal" },
      },
      components = {
        "mode", "os-uname", "filename", "git-branch", "git-diff", "%=",
        "diagnostics", "lsps-formatters", "indent", "encoding",
        "pos-cursor", "pos-cursor-progress",
      },
    })
  end,
}
