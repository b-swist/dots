---@diagnostic disable-next-line
local hl_func = vim.fn.has("nvim-0.13") == 1 and vim.hl.hl_op or vim.hl.on_yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
    callback = function()
        hl_func({
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
