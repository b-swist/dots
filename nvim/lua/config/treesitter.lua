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
    vim.treesitter.start(0, opts.args)
end, {
    nargs = "?",
    desc = "Start treesitter for current buffer",
    complete = "filetype",
})
