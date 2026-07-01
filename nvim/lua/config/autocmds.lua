vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
    callback = function()
        vim.hl.on_yank({
            timeout = 220,
        })
    end,
})

vim.api.nvim_create_autocmd("CmdlineChanged", {
    group = vim.api.nvim_create_augroup("CmdlineWildtrigger", { clear = true }),
    pattern = "[:/?]",
    callback = function()
        vim.fn.wildtrigger()
    end,
})

vim.api.nvim_create_autocmd("TermOpen", {
    callback = function()
        vim.cmd.startinsert()
    end,
})
