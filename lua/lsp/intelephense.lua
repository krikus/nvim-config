return function(lspconfig, on_attach, capabilities)
  lspconfig.intelephense.setup({
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      client.server_capabilities.documentFormattingProvider = true
      client.server_capabilities.documentRangeFormattingProvider = true
    end,
    capabilities = capabilities,
    environment = { phpVersion = "8.2" },
  })
end
