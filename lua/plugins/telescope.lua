return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.6",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-live-grep-args.nvim",
  },
  config = function()
    local telescope = require("telescope")

    -- Check ripgrep
    if vim.fn.executable("rg") == 0 then
      print("! > Install ripgrep first")
    end

    telescope.load_extension("live_grep_args")

    local builtin = require("telescope.builtin")

    vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
    vim.keymap.set("n", "<C-p>", builtin.git_files, {})
    vim.keymap.set("n", "<leader>fg", function()
      telescope.extensions.live_grep_args.live_grep_args()
    end, {})
    vim.keymap.set("n", "<leader>fb", builtin.buffers, {})

    vim.keymap.set("n", "<leader>vf", function()
      builtin.lsp_document_symbols({ symbols = { "function", "method" } })
    end, {})
    vim.keymap.set("n", "<leader>vs", function()
      builtin.lsp_document_symbols({ ignore_symbols = { "property", "variable", "namespace" } })
    end, {})

    vim.keymap.set("n", "<leader>fs", function()
      builtin.grep_string({ search = vim.fn.input("Grep Files > ") })
    end, {})
  end,
}
