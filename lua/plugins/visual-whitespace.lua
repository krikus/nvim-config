return {
  "mcauley-penney/visual-whitespace.nvim",
  config = true,
  event = "ModeChanged *:[vV\22]", -- optionally, lazy load on entering visual mode
  opts = {
    highlight = { link = "Visual" },
    space_char = ".",
    tab_char = "→",
    nl_char = "↵",
  },
}
