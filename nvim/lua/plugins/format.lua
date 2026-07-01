vim.pack.add({ gh("stevearc/conform.nvim") })

local conform = require("conform")

local formatters = {
    "stylua",
    "black",
    "prettier",
    "shfmt",
}

conform.setup({
    formatters_by_ft = {
        lua = { "stylua" },
        go = { "gofmt" },
        python = { "black" },
        typst = { lsp_format = "prefer" },

        sh = { "shfmt" },
        bash = { "shfmt" },

        javascript = { "prettier" },
        typescript = { "prettier" },
        json = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        svelte = { "prettier" },

        c = { "clang-format" },
        cpp = { "clang-format" },
    },
    default_format_opts = {
        lsp_format = "fallback",
    },
    format_on_save = function(buf)
        local ignore_ft = {}
        if vim.tbl_contains(ignore_ft, vim.bo[buf].filetype) then
            return
        end

        if vim.g.disable_autoformat or vim.b[buf].disable_autoformat then
            return
        end

        return {}
    end,
})

vim.keymap.set({ "n", "x" }, "grf", function()
    conform.format({}, function(err)
        if err then
            return
        end

        local mode = vim.api.nvim_get_mode().mode
        if vim.startswith(string.lower(mode), "v") then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
        end
    end)
end)

vim.o.formatexpr = "v:lua.require('conform').formatexpr()"

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

return { formatters = formatters }
