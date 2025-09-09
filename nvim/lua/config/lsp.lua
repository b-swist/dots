vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(event)
        local client = assert(vim.lsp.get_client_by_id(event.data.client_id))

        if client:supports_method("textDocument/documentHighlight") then
            vim.api.nvim_create_autocmd("CursorHold", {
                buffer = event.buf,
                group = group.hl,
                callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "ModeChanged" }, {
                buffer = event.buf,
                group = group.hl,
                callback = vim.lsp.buf.clear_references,
            })
        end
    end,
})

vim.api.nvim_create_autocmd("LspDetach", {
    group = group.detach,
    callback = function(event)
        vim.lsp.buf.clear_references()
        vim.api.nvim_clear_autocmds({
            group = group.hl,
            buffer = event.buf,
        })
    end,
})

vim.diagnostic.config({
    underline = {
        severity = vim.diagnostic.severity.ERROR,
    },
    virtual_text = {
        spacing = 2,
        source = "if_many",
        prefix = "",
    },
    severity_sort = true,
    signs = true,
})
