local M = {
  when = {"BufReadPost", "BufEnter", "BufWinEnter"},
  init = function()
    -- set local autoindent and smartindent
    vim.bo.autoindent = true
    vim.bo.smartindent = true
    vim.bo.indentexpr = 'SmartIndent()'
  end
}

-- execute autocmd
vim.api.nvim_create_autocmd(M.when, {
  pattern = "*.php",
  callback = function()
    vim.defer_fn(function()
      M.init()
    end, 200)
  end
})

