return {
  "VonHeikemen/lsp-zero.nvim",
  branch = "v3.x",
  dependencies = {
    "neovim/nvim-lspconfig",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-nvim-lua",
    "saadparwaiz1/cmp_luasnip",
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
    "lukas-reineke/cmp-under-comparator",
  },
  config = function()
    local lsp_zero = require("lsp-zero")
    local lspconfig = require("lspconfig")
    local cmp = require("cmp")
    local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
    capabilities.textDocument.inlayHint = { dynamicRegistration = true }

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

    local function on_attach(client, bufnr)
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

    require("mason").setup()
    require("mason-tool-installer").setup({
      ensure_installed = {
        "basedpyright",
        "docker_compose_language_service",
        "dockerfile-language-server",
        "eslint",
        "goimports-reviser",
        "gopls",
        "harper-ls",
        "intelephense",
        "lua_ls",
        "phpactor",
        "rust_analyzer",
        "ts_ls",
        -- Configured but can be ported to null-ls
        "fixjson",
        "yaml-language-server",
        -- Not configured yet
        "phpcs",
        "hadolint",
      }
    })

    -- Autoinit all lsp in lsp/ dir
    local lsp_dir = vim.fn.globpath(vim.fn.expand("<sfile>:p:h"), "lua/lsp/*.lua")
    local local_lsp = {}

    if lsp_dir == "" then
      vim.notify("No LSP files found in lsp/ directory.", vim.log.levels.WARN)
      return -- Exit if no files found
    end

    -- Split the comma-separated list of files into a table
    local lsp_files = vim.split(lsp_dir, "\n")

    for _, lsp in ipairs(lsp_files) do
      lsp = vim.trim(lsp) -- Remove leading/trailing whitespace
      local lsp_name = vim.fn.fnamemodify(lsp, ":t:r")
      local status, result = pcall(require, "../lsp." .. lsp_name)
      if status then
        table.insert(local_lsp, result)
      else
        vim.notify("Error loading LSP: " .. lsp_name .. " - " .. result, vim.log.levels.ERROR)
      end
    end

    if #local_lsp == 0 then
      vim.notify("No LSP servers loaded.", vim.log.levels.WARN)
    end

    for _, lspServer in ipairs(local_lsp) do
      lspServer(lspconfig, on_attach, capabilities)
    end
    -- Autoinit STOP

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
