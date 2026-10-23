vim.schedule(function()
    vim.pack.add({ gh("kylechui/nvim-surround") })
    require("nvim-surround").setup({
        aliases = {
            ["v"] = ">",
            ["b"] = ")",
            ["B"] = "}",
            ["r"] = "]",
            ["q"] = '"',
            ["Q"] = "'",
            ["s"] = { "}", "]", ")", ">", '"', "'", "`" },
        },
    })
end)
