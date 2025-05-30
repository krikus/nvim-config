local function skipWhile(lines, predicate)
  local skipping = true
  local result = {}
  for _, line in ipairs(lines) do
    if skipping and predicate(line) then
      goto continue
    end
    skipping = false
    table.insert(result, line)
    ::continue::
  end
  return result
end

local function run_goimports_reviser()
  local filepath = vim.fn.expand("%:p")

  -- Prepare the command
  local cmd = {
    "goimports-reviser",
    "-rm-unused",
    "-set-alias",
    "-format",
    "-output", "stdout",
    filepath,
  }

  local result = vim.fn.systemlist(cmd)

  if vim.v.shell_error ~= 0 then
    vim.notify("goimports-reviser failed:\n" .. table.concat(result, "\n"), vim.log.levels.ERROR)
    return
  end

  if not result or vim.tbl_isempty(result) then
    vim.notify("goimports-reviser returned empty output.", vim.log.levels.WARN)
    return
  end

  local view = vim.fn.winsaveview()

  result = skipWhile(result, function(line) return line:match("^[0-9]+") ~= nil end)
  vim.api.nvim_buf_set_lines(0, 0, -1, false, result)
  vim.fn.winrestview(view)
  vim.cmd("noautocmd write")
end

return function(_, _, _)
  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*.go",
    callback = run_goimports_reviser,
  })
end
