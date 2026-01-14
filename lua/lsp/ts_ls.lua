return function(on_attach, capabilities)
  vim.lsp.config('ts_ls',{
    on_attach = on_attach,
    capabilities = capabilities,
    root_markers = { '.git', 'package.json', 'tsconfig.json', 'jsconfig.json', 'node_modules' },
  })

  vim.lsp.enable('ts_ls')
end
