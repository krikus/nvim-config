return function(lspconfig, on_attach, capabilities)
  lspconfig.yamlls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      yaml = {
        schemas = {
          -- Example: JSON Schema Store integration
          ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
          ["https://json.schemastore.org/kubernetes.json"] = "/*.k8s.yaml",
          ["https://json.schemastore.org/gitlab-ci.json"] = "/.gitlab-ci.yaml",
        },
        validate = true,
        hover = true,
        completion = true,
        format = {
          enable = true,
        },
      },
    },
  })
end
