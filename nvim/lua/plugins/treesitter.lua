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

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    group = vim.api.nvim_create_augroup("TreesitterAutoInstall", { clear = true }),
    callback = function(ev)
        if vim.fn.executable("tree-sitter") == 0 then
            return
        end

        local lang = vim.treesitter.language.get_lang(ev.match)
        if not lang then
            return
        end

        local installed = ts.get_installed("parsers")
        if vim.tbl_contains(installed, lang) then
            return
        end

        local available = ts.get_available()
        if not vim.tbl_contains(available, lang) then
            return
        end

        ts.install(lang):await(function()
            vim.treesitter.start(ev.buf, lang)
        end)
    end,
})

require("nvim-treesitter-textobjects").setup({
    select = {
        enable = true,
        lookahead = true,
    },
    move = {
        enable = true,
    },
})

local sel = require("nvim-treesitter-textobjects.select")
vim.iter(pairs({
    ["af"] = "@function.outer",
    ["if"] = "@function.inner",
    ["ac"] = "@class.outer",
    ["ic"] = "@class.inner",
    ["aa"] = "@parameter.outer",
    ["ia"] = "@parameter.inner",
    ["ao"] = "@loop.outer",
    ["io"] = "@loop.inner",
    ["as"] = "@statement.outer",
})):each(function(lhs, query)
    vim.keymap.set({ "x", "o" }, lhs, function()
        sel.select_textobject(query, "textobjects")
    end)
end)

local swap = require("nvim-treesitter-textobjects.swap")
vim.iter(ipairs({
    { "<leader>a", swap.swap_next, "@parameter.inner" },
    { "<leader>A", swap.swap_previous, "@parameter.outer" },
})):each(function(_, t)
    local lhs, fn, query = t[1], t[2], t[3]
    vim.keymap.set("n", lhs, function()
        fn(query)
    end)
end)

local mv = require("nvim-treesitter-textobjects.move")
vim.iter(ipairs({
    { "]f", mv.goto_next_start, "@function.outer" },
    { "[f", mv.goto_previous_start, "@function.outer" },
    { "]F", mv.goto_next_end, "@function.outer" },
    { "[F", mv.goto_previous_end, "@function.outer" },
    { "]o", mv.goto_next_start, { "@loop.inner", "@loop.outer" } },
    { "[o", mv.goto_previous_start, { "@loop.inner", "@loop.outer" } },
})):each(function(_, t)
    local lhs, fn, query = t[1], t[2], t[3]
    vim.keymap.set({ "n", "o", "x" }, lhs, function()
        fn(query, "textobjects")
    end)
end)

require("nvim-ts-autotag").setup()
