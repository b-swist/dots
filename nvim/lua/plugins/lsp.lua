vim.pack.add({ gh("neovim/nvim-lspconfig") })

local servers = {
    "lua_ls",
    "bashls",
    "pylsp",
    "gopls",
    "tinymist",
    "ts_ls",
    "clangd",
    "svelte",
}

vim.iter(servers):map(function(s)
    vim.lsp.enable(s)
end)

return { servers = servers }
