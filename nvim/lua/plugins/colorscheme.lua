vim.schedule(function()
    vim.pack.add({
        gh("ellisonleao/gruvbox.nvim"),
    })

    require("gruvbox").setup({
        italic = {
            strings = false,
        },
        overrides = {
            SignColumn = { bg = "#282828" },
        },
    })

    vim.cmd.colorscheme("gruvbox")
end)
