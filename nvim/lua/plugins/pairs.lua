vim.api.nvim_create_autocmd("InsertEnter", {
    once = true,
    callback = function()
        vim.pack.add({ gh("windwp/nvim-autopairs") })
        require("nvim-autopairs").setup()
    end,
})
