return function(on_attach, capabilities)
  vim.lsp.config('dockerls', {
    on_attach = on_attach,
    capabilities = capabilities,
  })

  vim.lsp.enable('dockerls');
end
