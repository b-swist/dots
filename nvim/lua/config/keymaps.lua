vim.g.mapleader = vim.keycode("<Space>")
vim.g.maplocalleader = "\\"

vim.keymap.set("n", "x", '"_x')
vim.keymap.set("x", "p", '"_dP')
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
vim.keymap.set("n", "<Esc>", vim.cmd.nohlsearch)

vim.iter(pairs({
    ["<Up>"] = "<C-e>",
    ["<Down>"] = "<C-e>",
    ["<Left>"] = "<Space><BS>",
    ["<Right>"] = "<Space><BS>",
})):each(function(key, prefix)
    vim.keymap.set("c", key, function()
        return vim.fn.wildmenumode() == 1 and prefix .. key or key
    end, { expr = true })
end)

vim.iter(ipairs({ "h", "j", "k", "l" })):each(function(_, k)
    vim.keymap.set({ "n", "x" }, "<C-" .. k .. ">", "<C-w>" .. k)
end)

vim.keymap.set("x", "<", "<gv")
vim.keymap.set("x", ">", ">gv")
vim.keymap.set("n", "<leader>d", vim.cmd.bdelete)

vim.keymap.set({ "n", "i" }, "<M-j>", vim.cmd.cnext)
vim.keymap.set({ "n", "i" }, "<M-k>", vim.cmd.cprev)

vim.keymap.set("n", "<leader>i", vim.show_pos)
vim.keymap.set("n", "<leader>I", vim.treesitter.inspect_tree)

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

vim.iter(ipairs({
    "<Space>",
    "<BS>",
    "<Up>",
    "<Down>",
    "<Left>",
    "<Right>",
})):each(function(_, k)
    vim.keymap.set({ "n", "x" }, k, "<Nop>")
end)
