local plugins = {}
local excluded_files = { "init.lua" }
local config_path = vim.env.NVIM_CONFIG_PATH or "$HOME/.config/nvim"
local plugins_dir = vim.fn.glob(vim.fn.expand(config_path .. "/lua/plugins/*.lua"))
if plugins_dir == "" then
  plugins_dir = vim.fn.glob(vim.fn.expand("$HOME/.config/nvim/lua/plugins/*.lua"))
end

for plugin_file in string.gmatch(plugins_dir, "[^,]+") do
  if string.sub(plugin_file, -4) == ".lua" then
    local file_name = vim.fn.fnamemodify(plugin_file, ":t:r")
    if not vim.tbl_contains(excluded_files, file_name) then
      local status_ok, plugin = pcall(require, "plugins." .. file_name)
      if not status_ok then
        vim.api.nvim_err_writeln("Failed to load plugin: " .. "plugins." .. file_name)
      else
        table.insert(plugins, plugin)
      end
    end
  end
end

return plugins

