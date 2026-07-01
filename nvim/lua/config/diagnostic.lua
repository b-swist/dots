vim.diagnostic.config({
    severity_sort = true,
    signs = true,

    underline = {
        severity = {
            min = vim.diagnostic.severity.WARN,
        },
    },
    float = {
        source = "if_many",
    },

    virtual_text = {
        spacing = 2,
        source = "if_many",
        prefix = vim.g.nerd_font and "",
    },

    jump = {
        on_jump = function(_, buf)
            vim.diagnostic.open_float({
                bufnr = buf,
                scope = "cursor",
                focus = false,
            })
        end,
    },
})
