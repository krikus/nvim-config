local config_path = vim.fn.stdpath("config")

return function(lspconfig, on_attach, capabilities)
  lspconfig.harper_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      ["harper-ls"] = {
        userDictPath = config_path .. "/harper-dicts/user.txt",
        linters = {
          spell_check = true,
          spelled_numbers = false,
          an_a = true,
          sentence_capitalization = false,
          unclosed_quotes = true,
          wrong_quotes = false,
          long_sentences = true,
          repeated_words = true,
          spaces = true,
          matcher = true,
        },
      },
    },
  })
end
