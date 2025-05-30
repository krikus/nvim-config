local function set_pyenv_env()
  local handle = io.popen("pyenv version-name")
  if not handle then return end
  local pyenv_version = handle:read("*a"):gsub("%s+", "")
  handle:close()
  os.execute("export PYENV_VERSION=" .. pyenv_version)
end

local function get_python_path(workspace)
  local venv_path = workspace .. "/.venv/bin/python"
  local f = io.open(venv_path, "r")
  if f then
    f:close()
    return venv_path
  end
  return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
end

return function(lspconfig, capabilities, on_attach)
  lspconfig.basedpyright.setup({
    on_attach = function(client, bufnr)
      set_pyenv_env()
      on_attach(client, bufnr)
      vim.notify("Python path: " .. get_python_path(vim.fn.getcwd()), 2, { title = "BasedPyright" })
    end,
    capabilities = capabilities,
    settings = {
      python = {
        pythonPath = get_python_path(vim.fn.getcwd()),
        venvPath = vim.fn.getcwd(),
        venv = ".venv",
        analysis = {
          typeCheckingMode = "basic",
          autoImportCompletions = true,
          extraPaths = { vim.fn.getcwd() .. "/.venv/lib/python3.10/site-packages" },
        },
      },
    },
    root_dir = require("lspconfig/util").root_pattern(".venv", "poetry.lock", "pyproject.toml"),
  })
end
