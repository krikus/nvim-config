local lsp_zero = require('lsp-zero')
local lspconfig = require('lspconfig')
-- if notify package exists, use it
if require('notify') then
  vim.notify = require("notify")
end
local cmp = require('cmp')
local cmp_select = {
  behavior = cmp.SelectBehavior.Select
}

local function ends_with_equals_comparator(entry1, entry2)
  -- Function to check if the label of the entry ends with '='
  local function ends_with_equals(entry)
    local label = entry.completion_item.label or ""
    return label:sub(-1) == "="
  end

  local entry1_ends_with_equals = ends_with_equals(entry1)
  local entry2_ends_with_equals = ends_with_equals(entry2)

  -- If entry1 ends with '=' and entry2 does not, entry1 should come first
  if entry1_ends_with_equals and not entry2_ends_with_equals then
    return true
  elseif not entry1_ends_with_equals and entry2_ends_with_equals then
    return false
  end
end


cmp.setup({
  sources = {
    { name = 'path',     score = 5 },
    { name = 'nvim_lsp', score = 20 },
    { name = 'nvim_lua', score = 15 },
    { name = 'luasnip',  score = 15, keyword_length = 2 },
    { name = 'buffer',   score = 10, keyword_length = 3 },
  },
  sorting = {
    priority_weight = 1,
    comparators = {
      ends_with_equals_comparator,
      require('cmp-under-comparator').under,
      cmp.config.compare.recently_used,
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.locality,
      -- cmp.config.compare.length,
      cmp.config.compare.order
    }
  },
  formatting = lsp_zero.cmp_format({ details = false }),
  mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
  }),
})
require("lsp-inlayhints").setup()
---@diagnostic disable-next-line: unused-local
local on_attach = function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }
  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "[e", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end, opts)
  vim.keymap.set("n", "]e", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end, opts)
  vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
  require("lsp-inlayhints").on_attach(client, bufnr)
end

lsp_zero.on_attach = on_attach

-- https://github.com/MannyFay/nvim/blob/main/nvim/lua/user/plugin_options/lspconfig.lua#L48
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.inlayHint = {
  dynamicRegistration = true,
}

require('mason-tool-installer').setup({
  ensure_installed = {
    'basedpyright',
    'ts_ls', -- JS and TS
    { 'eslint', version = '4.8.0' },
    'fixjson',
    'rust_analyzer', -- Rust
    'intelephense',  -- PHP language server.
    'dockerfile-language-server',
    'hadolint',
    'docker_compose_language_service', -- Docker Compose Language Server.
    'lua_ls',
    'harper-ls',
    --'python-lsp-server',
    'phpcs',
    'phpactor',
    'gopls',
    'goimports-reviser',
    'yaml-language-server'
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
  environment = { phpVersion = '7.4.33' },
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

-- Helper function to set pyenv environment
local function set_pyenv_env()
  -- Capture the output of `pyenv version-name`
  local handle = io.popen("pyenv version-name")
  if handle == nil then
    return nil
  end
  local pyenv_version = handle:read("*a"):gsub("%s+", "") -- Remove trailing whitespace
  handle:close()
end

local function get_python_path(workspace)
  -- Use the `.venv/bin/python` path if it exists
  local venv_path = workspace .. '/.venv/bin/python'
  local file = io.open(venv_path, "r")
  if file then
    file:close()
    return venv_path
  else
    -- Fall back to system Python if `.venv` not found
    return vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python'
  end
end

--- lets try putting this as last
require('mason').setup({})
require('mason-lspconfig').setup({
  handlers = {
    lsp_zero.default_setup,
    lua_ls = function()
      local lua_opts = lsp_zero.nvim_lua_ls()
      lspconfig.lua_ls.setup(lua_opts)
    end,
    basedpyright = function()
      lspconfig.basedpyright.setup {
        on_attach = function(c, b)
          set_pyenv_env()
          on_attach(c, b)
          vim.notify("Python path being used: " .. get_python_path(vim.fn.getcwd()), "info", { title = "BasedPyright" })
        end,
        capabilities = capabilities,
        settings = {
          python = {
            pythonPath = get_python_path(vim.fn.getcwd()),
            venvPath = vim.fn.getcwd(),
            venv = '.venv',
            analysis = {
              typeCheckingMode = "basic",   -- or "strict"
              autoImportCompletions = true, -- Optional, enables auto-import suggestions
            }
          },
        },
        root_dir = require('lspconfig/util')
            .root_pattern(
              '.venv',
              'poetry.lock',
              'pyproject.toml'
            )
      }
    end,
    ts_ls = function()
      lspconfig.ts_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        root_dir = require('lspconfig/util')
            .root_pattern(
              'node_modules',
              'package.json',
              'tsconfig.json',
              'jsconfig.json',
              '.git'
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



-- This is the function that loads the extra snippets to luasnip
-- from rafamadriz/friendly-snippets
require('luasnip.loaders.from_vscode').lazy_load()

-- vim.lsp.handlers['textDocument/signatureHelp']  = vim.lsp.with(vim.lsp.handlers['signature_help'], {
--     border = 'single',
--     close_events = { "CursorMoved", "BufHidden" },
-- })
vim.keymap.set('i', '<c-k>', vim.lsp.buf.signature_help)
