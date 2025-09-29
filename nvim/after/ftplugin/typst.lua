vim.bo.tabstop = 2
vim.bo.expandtab = true
vim.wo.conceallevel = 3

vim.keymap.set("n", "<leader>l", "<cmd>LspTinymistExportPdf<CR>", { buffer = 0 })
