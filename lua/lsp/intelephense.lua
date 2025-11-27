return function(on_attach, capabilities)
  vim.lsp.config('intelephense', {
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      client.server_capabilities.documentFormattingProvider = true
      client.server_capabilities.documentRangeFormattingProvider = true
    end,
    capabilities = capabilities,
    environment = { phpVersion = "8.2" },
  })

  vim.lsp.enable('intelephense');
end
