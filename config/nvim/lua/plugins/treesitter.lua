return {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    opts = {
        ensure_installed = {
            "lua",
            "bash",
            "typst",
            "html",
        },
        auto_install = true,
        ignore_install = "latex",
        highlight = { enable = true },
        indent = { enable = true },
    },
}
