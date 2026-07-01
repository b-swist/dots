vim.api.nvim_create_user_command("Undotree", function()
    vim.api.nvim_del_user_command("Undotree")
    vim.cmd.packadd("nvim.undotree")
    vim.cmd.Undotree()
end, {})

vim.keymap.set("n", "<leader>u", "<Cmd>Undotree<CR>")
