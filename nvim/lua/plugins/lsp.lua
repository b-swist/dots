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
    "hls",
    "ocamllsp",
    "nushell",
}

vim.iter(ipairs(servers)):each(function(_, s)
    vim.lsp.enable(s)
end)
