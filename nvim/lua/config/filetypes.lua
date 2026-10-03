vim.filetype.add({
    extension = {
        qs = "qsharp",
    },
})

vim.treesitter.language.register("qsharp", "qsharp")
