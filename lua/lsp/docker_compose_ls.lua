return function(on_attach, capabilities)
  vim.lsp.config('docker_compose_language_service', {
    on_attach = on_attach,
    capabilities = capabilities,
  })

  vim.lsp.enable('docker_compose_language_service');
end
