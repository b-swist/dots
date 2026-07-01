vim.g.mapleader = vim.keycode("<Space>")
vim.g.maplocalleader = "\\"

vim.keymap.set("n", "x", '"_x')
vim.keymap.set("x", "p", '"_dP')
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
vim.keymap.set("n", "<Esc>", "<Cmd>noh<CR>")

vim.iter({ "<Up>", "<Down>" }):map(function(k)
    vim.keymap.set("c", k, function()
        return vim.fn.wildmenumode() == 1 and "<C-e>" .. k or k
    end, { expr = true })
end)

vim.iter({ "h", "j", "k", "l" }):map(function(k)
    vim.keymap.set({ "n", "x" }, "<C-" .. k .. ">", "<C-w>" .. k)
end)

vim.keymap.set("x", "<", "<gv")
vim.keymap.set("x", ">", ">gv")
vim.keymap.set("n", "<leader>d", "<cmd>bdel<CR>")

vim.keymap.set({ "n", "i" }, "<M-j>", "<cmd>cnext<CR>")
vim.keymap.set({ "n", "i" }, "<M-k>", "<cmd>cprev<CR>")

vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gD", vim.lsp.buf.declaration)

vim.keymap.set("n", "<leader>i", vim.show_pos)
vim.keymap.set("n", "<leader>I", vim.treesitter.inspect_tree)

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

vim.iter({
    "<Space>",
    "<BS>",
    "<Up>",
    "<Down>",
    "<Left>",
    "<Right>",
}):map(function(k)
    vim.keymap.set({ "n", "x" }, k, "<Nop>")
end)
