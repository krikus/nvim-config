return {
  "VonHeikemen/lsp-zero.nvim",
  branch = "v3.x",
  dependencies = {
    -- LSP Support
    "neovim/nvim-lspconfig",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",

    -- Autocompletion
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-nvim-lua",
    "saadparwaiz1/cmp_luasnip",

    -- Snippets
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",

    -- Optional: Under comparator for cmp sorting
    "lukas-reineke/cmp-under-comparator",

    -- Optional: Notification manager if you want it
    "rcarriga/nvim-notify",

    -- Mason tool installer for auto installing servers

    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    local lsp_zero = require("lsp-zero")
    local lspconfig = require("lspconfig")
    local cmp = require("cmp")

    -- Use notify if available
    if pcall(require, "notify") then
      vim.notify = require("notify")
    end

    -- Custom comparator for cmp sorting (prioritize entries ending with '=')
    local function ends_with_equals_comparator(entry1, entry2)
      local function ends_with_equals(entry)
        local label = entry.completion_item.label or ""
        return label:sub(-1) == "="
      end
      local e1 = ends_with_equals(entry1)
      local e2 = ends_with_equals(entry2)
      if e1 and not e2 then return true end
      if not e1 and e2 then return false end
    end

    -- Setup cmp with sources and sorting
    cmp.setup({
      sources = {
        { name = "path",     score = 5 },
        { name = "nvim_lsp", score = 20 },
        { name = "nvim_lua", score = 15 },
        { name = "luasnip",  score = 15, keyword_length = 2 },
        { name = "buffer",   score = 10, keyword_length = 3 },
      },
      sorting = {
        priority_weight = 1,
        comparators = {
          ends_with_equals_comparator,
          require("cmp-under-comparator").under,
          cmp.config.compare.recently_used,
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.locality,
          cmp.config.compare.order,
        },
      },
      formatting = lsp_zero.cmp_format({ details = false }),
      mapping = cmp.mapping.preset.insert({
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
      }),
    })

    local on_attach = function(client, bufnr)
      local opts = { buffer = bufnr, remap = false }
      local set = vim.keymap.set

      set("n", "gd", vim.lsp.buf.definition, opts)
      set("n", "gr", vim.lsp.buf.references, opts)
      set("n", "K", vim.lsp.buf.hover, opts)
      set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
      set("n", "<leader>rn", vim.lsp.buf.rename, opts)
      set("i", "<C-h>", vim.lsp.buf.signature_help, opts)

      if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end
    end

    lsp_zero.on_attach = on_attach

    local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
    capabilities.textDocument.inlayHint = { dynamicRegistration = true }

    vim.schedule(function()
      -- Setup mason-tool-installer to ensure servers installed
      require("mason-tool-installer").setup({
        ensure_installed = {
          "basedpyright",
          "ts_ls",
          { "eslint", version = "4.8.0" },
          "fixjson",
          "rust_analyzer",
          "intelephense",
          "dockerfile-language-server",
          "hadolint",
          "docker_compose_language_service",
          "lua_ls",
          "harper-ls",
          "phpcs",
          "phpactor",
          "gopls",
          "goimports-reviser",
          "yaml-language-server",
        }
      })
    end)
    --
    -- Custom functions for Python path detection
    local function set_pyenv_env()
      local handle = io.popen("pyenv version-name")
      if not handle then return end
      local pyenv_version = handle:read("*a"):gsub("%s+", "")
      handle:close()
      os.execute("export PYENV_VERSION=" .. pyenv_version)
    end

    local function get_python_path(workspace)
      local venv_path = workspace .. "/.venv/bin/python"
      local f = io.open(venv_path, "r")
      if f then
        f:close()
        return venv_path
      end
      return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
    end

    -- Mason and Mason-lspconfig setup with handlers for servers
    require("mason").setup()
    require("mason-lspconfig").setup({
      handlers = {
        lsp_zero.default_setup,
        lua_ls = function()
          local opts = lsp_zero.nvim_lua_ls()
          lspconfig.lua_ls.setup(opts)
        end,
        basedpyright = function()
          lspconfig.basedpyright.setup({
            on_attach = function(client, bufnr)
              set_pyenv_env()
              on_attach(client, bufnr)
              vim.notify("Python path: " .. get_python_path(vim.fn.getcwd()), "info", { title = "BasedPyright" })
            end,
            capabilities = capabilities,
            settings = {
              python = {
                pythonPath = get_python_path(vim.fn.getcwd()),
                venvPath = vim.fn.getcwd(),
                venv = ".venv",
                analysis = {
                  typeCheckingMode = "basic",
                  autoImportCompletions = true,
                  extraPaths = { vim.fn.getcwd() .. "/.venv/lib/python3.10/site-packages" },
                },
              },
            },
            root_dir = require("lspconfig/util").root_pattern(".venv", "poetry.lock", "pyproject.toml"),
          })
        end,
        ts_ls = function()
          lspconfig.ts_ls.setup({
            on_attach = on_attach,
            capabilities = capabilities,
            root_dir = require("lspconfig/util").root_pattern(
              "node_modules",
              "package.json",
              "tsconfig.json",
              "jsconfig.json",
              ".git"
            ),
          })
        end,
        eslint = function()
          lspconfig.eslint.setup({
            settings = { workingDirectory = { mode = "location" } },
            root_dir = require("lspconfig/util").root_pattern(
              "package.json",
              "tsconfig.json",
              "jsconfig.json",
              ".git",
              "eslintrc.js",
              "eslint.js",
              ".eslintrc",
              "node_modules"
            ),
          })
        end,
        harper_ls = function()
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
        end,
      },
    })

    lspconfig.intelephense.setup({
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        client.server_capabilities.documentFormattingProvider = true
        client.server_capabilities.documentRangeFormattingProvider = true
      end,
      capabilities = capabilities,
      environment = { phpVersion = "8.2" },
    })

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

    local config_path = vim.fn.stdpath("config")

    vim.api.nvim_create_autocmd("User", {
      pattern = "MasonToolsUpdateCompleted",
      callback = function(e)
        vim.schedule(function()
          if e.data then
            for _, v in pairs(e.data) do
              print("installed: " .. v)
            end
          end
        end)
      end,
    })

    require("luasnip.loaders.from_vscode").lazy_load()

    vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help)
  end,
}
