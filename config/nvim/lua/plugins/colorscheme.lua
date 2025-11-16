return {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    opts = {
        palette_overrides = {
            dark1 = "#282828",
        },
        overrides = {
            Pmenu = { link = "Normal" },
        },
    },
    config = function(_, opts)
        require("gruvbox").setup(opts)
        vim.cmd.colorscheme("gruvbox")
    end,
}
