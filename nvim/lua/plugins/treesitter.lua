return {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    lazy = vim.fn.argc(-1) == 0,
    branch = "master",
    build = ":TSUpdate",
    opts = {
        ensure_installed = {
            "lua",
            "bash",
            "typst",
            "java",
        },
        auto_install = true,
        ignore_install = "latex",
        highlight = { enable = true },
        indent = { enable = true },
    },
}
