vim.pack.add({
    gh("mason-org/mason.nvim"),
    gh("mason-org/mason-lspconfig.nvim"),
    gh("WhoIsSethDaniel/mason-tool-installer.nvim"),
})

local servers = require("plugins.lsp").servers
local formatters = require("plugins.format").formatters
local linters = require("plugins.lint").linters

local ensure_installed = vim.tbl_deep_extend("force", servers, formatters, linters)

vim.g.test = ensure_installed

require("mason").setup()
require("mason-tool-installer").setup({
    ensure_installed = ensure_installed,
})
