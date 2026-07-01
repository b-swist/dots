return {
    "stevearc/oil.nvim",
    dependencies = { "nvim-mini/mini.icons", config = true },
    lazy = false,
    keys = {
        {
            "<leader>e",
            function()
                if vim.bo.ft ~= "oil" then
                    require("oil").open()
                end
            end,
        },
    },
    opts = {
        default_file_explorer = true,
        skip_confirm_for_simple_edits = true,
        view_options = { show_hidden = true },
        float = {
            max_width = 0.6,
            max_height = 0.6,
        },
    },
}
