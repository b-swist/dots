vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(event)
        local client = assert(vim.lsp.get_client_by_id(event.data.client_id))

        if client:supports_method("textDocument/documentHighlight") then
            local hl_group = vim.api.nvim_create_augroup("cursor-hl", { clear = false })

            vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI"}, {
                buffer = event.buf,
                group = hl_group,
                callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                buffer = event.buf,
                group = hl_group,
                callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
                callback = function(ev)
                    vim.lsp.buf.clear_references()
                    vim.api.nvim_clear_autocmds({
                        group = hl_group,
                        buffer = ev.buf,
                    })
                end,
            })
        end
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
