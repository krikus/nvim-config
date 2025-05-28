return {
  "smoka7/hop.nvim",
  version = "*",
  config = function()
    local hop = require("hop")
    local directions = require("hop.hint").HintDirection

    hop.setup({})

    vim.keymap.set("", "f", function()
      hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
    end, { remap = true })

    vim.keymap.set("", "F", function()
      hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
    end, { remap = true })

    vim.keymap.set("", "t", function()
      hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
    end, { remap = true })

    vim.keymap.set("", "T", function()
      hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
    end, { remap = true })

    vim.keymap.set("", "<leader>hh", function()
      hop.hint_words()
    end, { remap = true })

    vim.keymap.set("", "<leader>hw", function()
      hop.hint_words({ direction = directions.AFTER_CURSOR })
    end, { remap = true })

    vim.keymap.set("", "<leader>hW", function()
      hop.hint_words({ direction = directions.BEFORE_CURSOR, hint_offset = -1 })
    end, { remap = true })
  end,
}
