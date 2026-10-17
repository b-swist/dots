vim.api.nvim_create_autocmd("InsertEnter", {
    once = true,
    callback = function()
        vim.pack.add({ gh("saghen/blink.lib"), gh("saghen/blink.cmp") })

        local blink = require("blink.cmp")
        blink.build():pwait()
        blink.setup({
            completion = {
                documentation = { auto_show = true },
            },
        })
    end,
})
