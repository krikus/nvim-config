return {
  "zaldih/themery.nvim",
  dependencies = {
    'catppuccin/nvim',
    'sainnhe/everforest',
    'embark-theme/vim',
  },
  lazy = false,
  config = function()
    local themes = { 'catppuccin', 'everforest', 'embark' }
    local cache_file = vim.fn.stdpath("data") .. "/themery_seen_themes.txt"

    local function load_seen_themes()
      local f = io.open(cache_file, "r")
      if not f then return nil end
      local content = f:read("*a")
      f:close()
      return content
    end

    local function save_seen_themes()
      local f = io.open(cache_file, "w")
      if not f then return end
      f:write(vim.inspect(themes))
      f:close()
    end

    require("themery").setup({
      themes = themes,
      livePreview = true,
    })

    vim.schedule(function()
      local seen = load_seen_themes()
      local current = vim.inspect(themes)
      if seen ~= current then
        vim.cmd("Themery")
        save_seen_themes()
      end
    end)
  end,
}
