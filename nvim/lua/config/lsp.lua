vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(event)
        local id = event.data.client_id
        local client = vim.lsp.get_client_by_id(id)

        if not client then
            return
        end

        local buf = event.buf

        if client:supports_method("textDocument/documentHighlight", buf) then
            local hl_group = vim.api.nvim_create_augroup("CursorHighlight", { clear = false })

            vim.api.nvim_create_autocmd({ "CursorHold" }, {
                buffer = buf,
                group = hl_group,
                callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "ModeChanged" }, {
                buffer = buf,
                group = hl_group,
                callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
                callback = function(e)
                    vim.lsp.buf.clear_references()
                    vim.api.nvim_clear_autocmds({
                        group = hl_group,
                        buffer = e.buf,
                    })
                end,
            })
        end

        if client:supports_method("textDocument/inlayHint", buf) then
            vim.keymap.set("n", "grh", function()
                local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = buf })
                vim.lsp.inlay_hint.enable(not enabled, { bufnr = buf })
            end, { buf = buf })
        end

        if client:supports_method("textDocument/codeLens", buf) then
            vim.keymap.set("n", "grl", function()
                local enabled = vim.lsp.codelens.is_enabled({ bufnr = buf })
                vim.lsp.codelens.enable(not enabled, { bufnr = buf })
            end)
        end

        if client:supports_method("textDocument/completion", buf) then
            vim.schedule(function()
                local chars = {}
                for i = 32, 126 do
                    table.insert(chars, string.char(i))
                end
                client.server_capabilities.completionProvider.triggerCharacters = chars

                vim.lsp.completion.enable(true, client.id, buf, {
                    autotrigger = true,
                    convert = function(i)
                        return { abbr = i.label:gsub("%b()", "") }
                    end,
                })
            end)
        end

        if client:supports_method("textDocument/onTypeFormatting", buf) then
            vim.schedule(function()
                vim.lsp.on_type_formatting.enable(true, { id = id })
            end)
        end
    end,
})
