return {
  "theprimeagen/harpoon",
  config = function()
    local mark = require("harpoon.mark")
    local ui = require("harpoon.ui")

    vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "Harpoon: Add file" })
    vim.keymap.set("n", "<C-H>", ui.toggle_quick_menu, { desc = "Harpoon: Toggle quick menu" })

    for i = 1, 9 do
      vim.keymap.set("n", "<leader>" .. i, function() ui.nav_file(i) end, { desc = "Harpoon: Navigate to file " .. i })
    end
  end,
}
