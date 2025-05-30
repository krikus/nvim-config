return function(lspconfig, on_attach, capabilities)
  lspconfig.rust_analyzer.setup({
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
end
