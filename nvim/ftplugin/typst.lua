vim.bo.tabstop = 2
vim.bo.expandtab = true
vim.wo.wrap = true

vim.keymap.set("n", "<leader>l", vim.cmd.LspTinymistExportPdf, { buffer = 0 })
