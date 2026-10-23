vim.schedule(function()
    vim.pack.add({ gh("kylechui/nvim-surround") })
    require("nvim-surround").setup()
end)
