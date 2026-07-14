vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
    callback = function()
        local timeout = 220
        if vim.fn.has("nvim-0.13") then
            vim.hl.hl_op({
                timeout = timeout,
            })
        else
            ---@diagnostic disable-next-line
            vim.hl.on_yank({
                timeout = timeout,
            })
        end
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
