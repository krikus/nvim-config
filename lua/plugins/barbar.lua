return {
  "romgrk/barbar.nvim",
   dependencies = {
    "lewis6991/gitsigns.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    vim.g.barbar_auto_setup = false
    local opts = { noremap = false, silent = true }
    local map = vim.api.nvim_set_keymap

    require('barbar').setup {
      animation = true,
      auto_hide = false,
      tabpages = true,
      clickable = true,
      exclude_ft = {''},
      exclude_name = {''},
      focus_on_close = 'left',
      hide = { extensions = true, inactive = false },
      highlight_alternate = false,
      highlight_inactive_file_icons = false,
      highlight_visible = true,

      icons = {
        buffer_index = false,
        buffer_number = false,
        button = '',
        diagnostics = {
          [vim.diagnostic.severity.ERROR] = { enabled = true, icon = 'ﬀ' },
          [vim.diagnostic.severity.WARN] = { enabled = false },
          [vim.diagnostic.severity.INFO] = { enabled = false },
          [vim.diagnostic.severity.HINT] = { enabled = true },
        },
        gitsigns = {
          added = { enabled = true, icon = '+' },
          changed = { enabled = true, icon = '~' },
          deleted = { enabled = true, icon = '-' },
        },
        filetype = {
          custom_colors = false,
          enabled = true,
        },
        separator = { left = '▎', right = '' },
        separator_at_end = true,
        modified = { button = '●' },
        pinned = { button = '', filename = true },
        preset = 'default',
        alternate = { filetype = { enabled = false } },
        current = { buffer_index = true },
        inactive = { button = '×' },
        visible = { modified = { buffer_number = false } },
      },

      insert_at_end = false,
      insert_at_start = false,
      maximum_padding = 1,
      minimum_padding = 1,
      maximum_length = 30,
      minimum_length = 0,
      semantic_letters = true,
      sidebar_filetypes = {
        NvimTree = true,
        undotree = { text = 'undotree', align = 'center' },
        ['neo-tree'] = { event = 'BufWipeout' },
        Outline = { event = 'BufWinLeave', text = 'symbols-outline', align = 'right' },
      },
      letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',
      no_name_title = nil,
    }

    -- Keymaps
    -- Move to previous/next buffer
    map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
    map('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)
    -- Re-order to previous/next
    map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
    map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)
    -- Goto buffer in position
    for i = 1, 9 do
      map('n', '<A-'..i..'>', '<Cmd>BufferGoto '..i..'<CR>', opts)
    end
    map('n', '<A-0>', '<Cmd>BufferLast<CR>', opts)
    -- Pin/unpin buffer
    map('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)
    -- Close buffer
    map('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)
    -- Close other (not pinned)
    map('n', '<A-x>', '<Cmd>BufferCloseAllButCurrentOrPinned<CR>', opts)
    -- Sort buffers
    map('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
    map('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>', opts)
    map('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', opts)
    map('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)
  end,
}
