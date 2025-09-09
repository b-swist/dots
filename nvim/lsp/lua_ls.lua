return {
    settings = {
        Lua = {
            path = {
                "lua/?.lua",
                "lua/?/init.lua",
            },
            workspace = {
                checkThirdParty = false,
                library = { vim.env.VIMRUNTIME },
            },
            completion = {
                callSnippet = "Replace",
            },
        },
    },
}
