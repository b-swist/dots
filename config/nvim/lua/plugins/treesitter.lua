return {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    lazy = false,
    opts = {
        ensure_installed = {
            "lua",
            "bash",
            "typst",
            "html",
            "javascript",
        },
        auto_install = true,
        ignore_install = { "latex" },
        highlight = { enable = true },
        indent = { enable = true },
        fold = { enable = true },
    },
    config = function(_, opts)
        require("nvim-treesitter.configs").setup(opts)
        vim.o.foldmethod = "expr"
        vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end,
}
