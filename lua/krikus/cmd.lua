-- define command for saving sudo
vim.api.nvim_create_user_command("W", "w !sudo tee > /dev/null %", { bang = true })
