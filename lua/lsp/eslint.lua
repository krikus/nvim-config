return function(lspconfig, on_attach, capabilities)
  lspconfig.ts_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    root_dir = require("lspconfig/util").root_pattern("node_modules", "package.json", "tsconfig.json", "jsconfig.json",
      ".git"),
  })
end
