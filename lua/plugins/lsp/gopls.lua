return function(lspconfig, on_attach, capabilities)
  lspconfig.gopls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { "gopls" }, -- Optional: explicitly set the command if needed
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_dir = require("lspconfig/util").root_pattern("go.work", "go.mod", ".git"),
    settings = {
      gopls = {
        gofumpt = true, -- Use gofumpt formatting
        analyses = {
          unusedparams = true,
          shadow = true,
          nilness = true,
          unusedwrite = true,
        },
        staticcheck = true, -- Enable static analysis
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
      },
    },
  })
end
