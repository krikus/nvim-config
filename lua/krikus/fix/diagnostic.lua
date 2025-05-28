vim.diagnostic.config({
  virtual_text = {
    -- source = "always",  -- Or "if_many"
    prefix = '●', -- Could be '■', '▎', 'x'
  },
  severity_sort = true,
  float = {
    source = "always",  -- Or "if_many"
  },
})


local set = vim.keymap.set
local opts = { remap = true, buffer = -1 }
set("n", "<leader>vd", vim.diagnostic.open_float, opts)
set("n", "[d", vim.diagnostic.goto_next, opts)
set("n", "]d", vim.diagnostic.goto_prev, opts)
set("n", "[e", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end, opts)
set("n", "]e", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end, opts)
