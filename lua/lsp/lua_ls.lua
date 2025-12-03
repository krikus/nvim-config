return function(_, _)
  vim.lsp.config('lua_ls', {
    root_markers = { '.git' }
  })
  vim.lsp.enable('lua_ls');
end
