local function run_fixjson()
  local filepath = vim.fn.expand("%:p")
    local bufnr = vim.api.nvim_get_current_buf()

  vim.notify(filepath)
  -- Prepare the command
  local cmd = {
    "fixjson",
    "-i", "2",
    filepath,
  }

  local result = vim.fn.systemlist(cmd)

  if vim.v.shell_error ~= 0 then
    vim.notify("fixjson failed:\n" .. table.concat(result, "\n"), vim.log.levels.ERROR)
    return
  end

  if not result or vim.tbl_isempty(result) then
    vim.notify("fixjson returned empty output.", vim.log.levels.WARN)
    return
  end

  -- Replace buffer content safely
  local view = vim.fn.winsaveview()

  vim.api.nvim_buf_set_lines(0, 0, -1, false, result)
  vim.fn.winrestview(view)
  vim.cmd("noautocmd write")
end

return function(_, _, _)
  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*.json",
    callback = run_fixjson,
  })
end
