
local function set_filetype(pattern, filetype)
    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = pattern,
        command = "set filetype=" .. filetype,
    })
end

local compose_patterns = {
  "docker-compose.yml",
  "compose.yml",
  "docker-compose.yaml",
  "compose.yaml",
}

set_filetype(compose_patterns, "yaml.docker-compose")
