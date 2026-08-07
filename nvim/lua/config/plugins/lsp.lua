vim.pack.add({ gh("neovim/nvim-lspconfig") })

local required_servers = {
    "lua_ls",
    "bashls",
    "pylsp",
    "gopls",
    "tinymist",
    "ts_ls",
    "clangd",
    "svelte",
    "hls",
}

-- for servers that can't be installed through Mason
local optional_servers = {
    "nixd",
}

all_servers = require("utils").merge_lists(required_servers, optional_servers)

vim.iter(ipairs(all_servers)):each(function(_, s)
    vim.lsp.enable(s)
end)

return { servers = required_servers }
