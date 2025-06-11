return function(lspconfig, on_attach, capabilities)
  lspconfig.lua_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    root_dir = require("lspconfig/util").root_pattern(".git"),
  })
end
