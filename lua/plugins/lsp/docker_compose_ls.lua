return function(lspconfig, on_attach, capabilities)
  lspconfig.docker_compose_language_service.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end
