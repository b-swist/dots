return {
    on_init = function(client)
        if not client.workspace_folders or client.workspace_folders == {} then
            return
        end

        local path = client.workspace_folders[1].name
        if path ~= vim.fn.stdpath("config") then
            return
        end

        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = {
                version = "LuaJIT",
                path = {
                    "lua/?.lua",
                    "lua/?/init.lua",
                },
            },
            workspace = {
                checkThirdParty = "Apply",
                library = {
                    vim.env.VIMRUNTIME,
                    vim.api.nvim_get_runtime_file("lua/lspconfig", false)[1],
                    "${3rd}/luv/library",
                },
            },
        })
    end,
    settings = {
        Lua = {
            completion = {
                callSnippet = "Replace",
                keywordSnippet = "Disable",
            },
            format = {
                enable = false,
            },
        },
    },
}
