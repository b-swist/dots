vim.filetype.add({
    extension = {
        tcss = "tcss",
    },
    pattern = {
        [".*/srcpkgs/.*/template"] = "sh",
    },
})
