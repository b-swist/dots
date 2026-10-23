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
            GruvboxRedSign = { bg = "#282828" },
            GruvboxYellowSign = { bg = "#282828" },
            GruvboxGreenSign = { bg = "#282828" },
            GruvboxPurpleSign = { bg = "#282828" },
            GruvboxAquaSign = { bg = "#282828" },
            GruvboxBlueSign = { bg = "#282828" },
            GruvboxOrangeSign = { bg = "#282828" },
        },
    })

    vim.cmd.colorscheme("gruvbox")
end)
