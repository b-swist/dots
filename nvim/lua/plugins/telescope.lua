return {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            cond = function()
                return vim.fn.executable("make") == 1
            end,
        },
    },
    keys = {
        {
            "<leader>ff",
            function()
                require("telescope.builtin").find_files()
            end,
        },
        {
            "<leader>fg",
            function()
                require("telescope.builtin").live_grep()
            end,
        },
        {
            "<leader>fb",
            function()
                require("telescope.builtin").buffers()
            end,
        },
        {
            "<leader>fr",
            function()
                require("telescope.builtin").registers()
            end,
        },
        {
            "<leader>fh",
            function()
                require("telescope.builtin").help_tags()
            end,
        },
        {
            "<leader>fd",
            function()
                require("telescope.builtin").diagnostics()
            end,
        },
    },
    config = function()
        pcall(require("telescope").load_extension, "fzf")
    end,
}
