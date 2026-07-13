vim.pack.add({
    gh("mason-org/mason.nvim"),
    gh("mason-org/mason-lspconfig.nvim"),
    gh("WhoIsSethDaniel/mason-tool-installer.nvim"),
})

local servers = require("plugins.lsp").servers
local formatters = require("plugins.format").formatters
local linters = require("plugins.lint").linters

---@param ...table
---@return table
local merge_lists = function(...)
    local result = {} ---@type table
    for i = 1, select("#", ...) do
        local tbl = select(i, ...) --[[@as table]]
        if tbl then
            for _, v in pairs(tbl) do
                table.insert(result, v)
            end
        end
    end
    return vim.list.unique(result)
end

local ensure_installed = merge_lists(servers, formatters, linters)

require("mason").setup()
require("mason-tool-installer").setup({
    ensure_installed = ensure_installed,
    auto_update = true,
})
