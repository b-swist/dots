vim.schedule(function()
    vim.pack.add({ gh("rachartier/tiny-inline-diagnostic.nvim") })

    vim.diagnostic.config({ virtual_text = false })
    require("tiny-inline-diagnostic").setup({
        preset = "classic",
        hi = {
            background = "CursorLineSign",
        },
        options = {
            override_open_float = true,
            multilines = {
                enabled = true,
            },
            show_code = false,
        },
    })
end)
