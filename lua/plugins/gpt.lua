return {
  "robitx/gp.nvim",
  config = function()
    local conf = {
      providers = {
        openai = {},
        googleai = {
          endpoint =
          "https://generativelanguage.googleapis.com/v1beta/models/{{model}}:streamGenerateContent?key={{secret}}",
          secret = os.getenv("GEMINI_API_KEY"),
        },

      },
      agents = {
        {
          provider = "googleai",
          name = "ChatGemini",
          chat = true,
          command = false,
          -- string with model name or table with model name and parameters
          model = { model = "gemini-2.0-flash", temperature = 1.1, top_p = 1 },
          -- system prompt (use this to specify the persona/role of the AI)
          system_prompt = require("gp.defaults").chat_system_prompt .. "Please be very specific and unless told do not give much explanation. Be as short as possible to answer the question!",
        },
        {
          provider = "googleai",
          name = "CodeGemini",
          chat = false,
          command = true,
          -- string with model name or table with model name and parameters
          model = { model = "gemini-2.0-flash", temperature = 0.8, top_p = 1 },
          system_prompt = require("gp.defaults").code_system_prompt,
        },
      }
    }
    require("gp").setup(conf)
    vim.keymap.set({ "n", "v" }, "<C-g>r", ":GpRewrite<CR>", { desc = "Rewrite selection with GPT" })
    vim.keymap.set({ "n", "v" }, "<C-g>g", ":GpGenerate<CR>", { desc = "Generate code from prompt" })
    vim.keymap.set({ "n", "v" }, "<C-g>a", ":GpAppend<CR>", { desc = "Rewrite with GPT - append" })
    vim.keymap.set({ "v" }, "<C-g>c", ":GpChatPaste vsplit<CR>", { desc = "Paste to chat - split" })
    vim.keymap.set({ "n" }, "<C-g>c", ":GpChatToggle vsplit<CR>", { desc = "Toggle chat - split" })
  end,
}
