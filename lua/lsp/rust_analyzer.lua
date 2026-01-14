return function(on_attach, capabilities)
  vim.lsp.config('rust_analyzer', {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      ["rust-analyzer"] = {
        cargo = { allFeatures = true },
        check = { command = "clippy" },
        diagnostics = { enable = true, enableExperimental = true },
        imports = { granularity = { group = "module" }, prefix = "self" },
        procMacro = { enable = true },
      },
    },
  })

  vim.lsp.enable('rust_analyzer');
end
