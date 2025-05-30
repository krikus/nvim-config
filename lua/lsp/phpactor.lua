return function(lspconfig, on_attach, capabilities)
  lspconfig.phpactor.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end
