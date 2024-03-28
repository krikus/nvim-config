require('gitblame').setup({
  enabled = true,
  -- schedule_event = 'CursorHold',
  -- clear_event = 'CusrosHoldI',
  message_when_not_committed = '',
})
vim.keymap.set('n', '<leader>gb', ':GitBlameToggle<CR>')
