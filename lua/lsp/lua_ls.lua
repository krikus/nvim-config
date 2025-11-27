return function(on_attach, capabilities)
  vim.lsp.config('lua_ls', {
    on_attach = on_attach,
    capabilities = capabilities,
    root_dir = require("lspconfig/util").root_pattern(".git"),
  })

  vim.lsp.enable('lua_ls');
end
