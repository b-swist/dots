vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    group = vim.api.nvim_create_augroup("TreesitterAutoStart", { clear = true }),
    callback = function(ev)
        local buf = ev.buf

        local lang = vim.treesitter.language.get_lang(ev.match)
        if not lang then
            return
        end

        local avail = vim.treesitter.language.add(lang)
        if avail then
            vim.treesitter.start(buf, lang)
        end
    end,
})

vim.api.nvim_create_user_command("TSStart", function(opts)
    local buf = vim.api.nvim_get_current_buf()
    if opts.count >= 1 then
        vim.treesitter.start(buf, opts.args)
    else
        vim.treesitter.start(buf)
    end
end, {
    nargs = "?",
    desc = "Start treesitter for current buffer",
    complete = "filetype",
})
