return {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
        {
            "grf",
            function()
                require("conform").format()
            end,
        },
    },
    opts = {
        stop_after_first = true,
        formatters_by_ft = {
            lua = { "stylua" },
            sh = { "shfmt" },
            bash = { "shfmt" },
        },
        format_on_save = function(bufnr)
            local ignore_ft = {}

            if vim.tbl_contains(ignore_ft, vim.bo[bufnr].filetype) then
                return
            end

            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
            end
            return { lsp_format = "fallback" }
        end,
    },
    init = function()
        vim.api.nvim_create_user_command("ConformDisable", function(args)
            if args.bang then
                vim.b.disable_autoformat = true
            else
                vim.g.disable_autoformat = true
            end
        end, { bang = true })

        vim.api.nvim_create_user_command("ConformEnable", function()
            vim.b.disable_autoformat = false
            vim.g.disable_autoformat = false
        end, {})
    end,
}
