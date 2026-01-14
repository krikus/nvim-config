return function(on_attach, capabilities)
  vim.lsp.config('phpactor', {
    on_attach = on_attach,
    capabilities = capabilities,
  })

  vim.lsp.enable('phpactor');
end
