return function(on_attach, capabilities)
  vim.lsp.config('ts_ls',{
    on_attach = on_attach,
    capabilities = capabilities,
    root_dir = require("lspconfig/util").root_pattern("node_modules", "package.json", "tsconfig.json", "jsconfig.json",
      ".git"),
  })

  vim.lsp.enable('ts_ls');
end
