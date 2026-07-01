vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if kind == "update" and name == "nvim-treesitter" then
            vim.cmd.TSUpdate()
        end
    end,
})

vim.pack.add({
    {
        src = gh("nvim-treesitter/nvim-treesitter"),
        version = "main",
    },
    {
        src = gh("nvim-treesitter/nvim-treesitter-textobjects"),
        version = "main",
    },
    gh("nvim-treesitter/nvim-treesitter-context"),
    gh("windwp/nvim-ts-autotag"),
})

local ts = require("nvim-treesitter")

---@param ft string
---@return boolean
local is_installed = function(ft)
    local installed = ts.get_installed()
    return vim.tbl_contains(installed, ft)
end

---@param ft string
---@return boolean
local is_available = function(ft)
    local parsers = ts.get_available()
    return vim.tbl_contains(parsers, ft)
end

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    group = vim.api.nvim_create_augroup("TreesitterAutoInstall", { clear = true }),
    callback = function(ev)
        if not vim.fn.executable("tree-sitter") then
            return
        end

        local ft = vim.bo.filetype
        if not ft or ft == "" then
            return
        end

        if is_installed(ft) or not is_available(ft) then
            return
        end

        ts.install(ft):wait(5 * 60 * 1000)
        vim.treesitter.start(ev.buf)
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    group = vim.api.nvim_create_augroup("TreesitterAutoStart", { clear = true }),
    callback = function(ev)
        local ft = vim.bo.filetype
        if not ft or ft == "" then
            return
        end

        if is_available(ft) then
            pcall(function()
                vim.treesitter.start(ev.buf)
            end)
        end
    end,
})

require("nvim-treesitter-textobjects").setup({
    select = {
        enable = true,
        lookahead = true,
        selection_modes = {
            ["@parameter.outer"] = "v",
            ["@function.outer"] = "V",
            ["@class.outer"] = "<c-v>",
        },
    },
    move = {
        enable = true,
    },
})

local swap = require("nvim-treesitter-textobjects.swap")
vim.iter({
    { "<leader>a", swap.swap_next, "@parameter.inner" },
    { "<leader>A", swap.swap_previous, "@parameter.outer" },
}):map(function(t)
    local lhs, fn, query = t[1], t[2], t[3]
    vim.keymap.set("n", lhs, function()
        fn(query)
    end)
end)

local sel = require("nvim-treesitter-textobjects.select")
vim.iter({
    { "af", "@function.outer" },
    { "if", "@function.inner" },
    { "ac", "@class.outer" },
    { "ic", "@class.inner" },
    { "aa", "@parameter.outer" },
    { "ia", "@parameter.inner" },
    { "ad", "@comment.outer" },
    { "as", "@statement.outer" },
}):map(function(t)
    local lhs, query = t[1], t[2]
    vim.keymap.set({ "x", "o" }, lhs, function()
        sel.select_textobject(query, "textobjects")
    end)
end)

local mv = require("nvim-treesitter-textobjects.move")
vim.iter({
    { "]f", mv.goto_next_start, "@function.outer" },
    { "[f", mv.goto_previous_start, "@function.outer" },
    { "]F", mv.goto_next_end, "@function.outer" },
    { "[F", mv.goto_previous_end, "@function.outer" },
    { "]o", mv.goto_next_start, { "@loop.inner", "@loop.outer" } },
    { "[o", mv.goto_previous_start, { "@loop.inner", "@loop.outer" } },
}):map(function(t)
    local lhs, fn, query = t[1], t[2], t[3]
    vim.keymap.set({ "n", "o", "x" }, lhs, function()
        fn(query, "textobjects")
    end)
end)

require("nvim-ts-autotag").setup()
