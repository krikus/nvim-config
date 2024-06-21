local lsp_zero = require('lsp-zero')
local lspconfig = require('lspconfig')

---@diagnostic disable-next-line: unused-local
local on_attach = function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}
  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end

lsp_zero.on_attach = on_attach

-- https://github.com/MannyFay/nvim/blob/main/nvim/lua/user/plugin_options/lspconfig.lua#L48
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())


require('mason-tool-installer').setup({
  ensure_installed = {
    'tsserver', -- JS and TS
    'eslint',
    'fixjson',
    'rust_analyzer', -- Rust
    'intelephense', -- PHP language server.
    'dockerfile-language-server',
    'hadolint',
    'docker_compose_language_service', -- Docker Compose Language Server.
    'lua_ls',
    'harper-ls',
    'phpcs',
    'phpactor'
  }
})
-- to learn how to use mason.nvim with lsp-zero
-- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md



lspconfig.intelephense.setup({
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    client.server_capabilities.documentFormattingProvider      = true
    client.server_capabilities.documentRangeFormattingProvider = true
  end,
  capabilities = capabilities,
  environment = {phpVersion = '7.4.33'},
})

lspconfig.rust_analyzer.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true
      },
      check = {
        command = "clippy",
      },
      diagnostics = {
        enable = true,
        enableExperimental = true,
      },
      imports = {
        granularity = {
          group = "module",
        },
        prefix = "self",
      },
      procMacro = {
        enable = true
      },
    }
  }
})

local config_path = vim.fn.stdpath('config')


vim.api.nvim_create_autocmd('User', {
  pattern = 'MasonToolsUpdateCompleted',
  callback = function(e)
    vim.schedule(function()
      lspconfig.harper_ls.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          ["harper-ls"] = {
            userDictPath = config_path .. '/harper-dicts/user.txt',
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
              matcher = true
            }
          }
        }
      }
      if e.data then
        for _, v in pairs(e.data) do
          print('installed: ' .. v)
        end
      end
    end)
  end,
})


--- lets try putting this as last
require('mason').setup({})
require('mason-lspconfig').setup({
  handlers = {
    lsp_zero.default_setup,
    lua_ls = function()
      local lua_opts = lsp_zero.nvim_lua_ls()
      lspconfig.lua_ls.setup(lua_opts)
    end,
    tsserver = function()
      lspconfig.tsserver.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        root_dir = require('lspconfig/util')
        .root_pattern(
        'package.json',
        'tsconfig.json',
        'jsconfig.json',
        '.git',
        'node_modules'
        ),
      })
    end,
    eslint = function()
      lspconfig.eslint.setup({
        settings = {
          workingDirectory = { mode = 'location' },
        },
        root_dir = require('lspconfig/util')
        .root_pattern(
        'package.json',
        'tsconfig.json',
        'jsconfig.json',
        '.git',
        'eslintrc.js',
        'eslint.js',
        '.eslintrc',
        'node_modules'
        ),
      })
    end,
  }
})

local cmp = require('cmp')
local cmp_select = {
  behavior = cmp.SelectBehavior.Select
}


-- This is the function that loads the extra snippets to luasnip
-- from rafamadriz/friendly-snippets
require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup({
  sources = {
    {name = 'path'},
    {name = 'nvim_lsp'},
    {name = 'nvim_lua'},
    {name = 'luasnip', keyword_length = 2},
    {name = 'buffer', keyword_length = 3},
  },
  formatting = lsp_zero.cmp_format({details = false}),
  mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
  }),
})

-- vim.lsp.handlers['textDocument/signatureHelp']  = vim.lsp.with(vim.lsp.handlers['signature_help'], {
--     border = 'single',
--     close_events = { "CursorMoved", "BufHidden" },
-- })
vim.keymap.set('i', '<c-k>', vim.lsp.buf.signature_help)

