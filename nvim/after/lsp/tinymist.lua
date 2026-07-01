return {
    root_markers = { ".git", { "justfile", ".justfile" } },
    settings = {
        exportPdf = "onSave",
        outputPath = "$root/target/$name",
        formatterMode = "typstyle",
    },
}
