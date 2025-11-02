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
        formatters_by_ft = {
            lua = { "stylua" },
            go = { "gofmt" },
            sh = { "shfmt" },
            bash = { "shfmt" },
            typst = { lsp_format = "prefer" },
            json = { "jq" },
            javascript = { "prettier" },
            css = { "prettier" },
            scss = { "prettier" },
            html = { "prettier" },
        },
        format_on_save = function(bufnr)
            local ignore_ft = { "json" }
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
