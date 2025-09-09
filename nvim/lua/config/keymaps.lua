vim.g.mapleader = vim.keycode("<space>")
vim.g.maplocalleader = "\\"

local opts = setmetatable({
    noremap = true,
    silent = true,
}, {
    __concat = function(t1, t2)
        return vim.tbl_extend("force", t1, t2)
    end,
})

vim.keymap.set("n", "x", '"_x', opts)
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", opts)
vim.keymap.set("n", "<Esc>", "<cmd>noh<CR>")

-- motions
vim.keymap.set({ "n", "x" }, "j", function()
    return vim.v.count == 0 and "gj" or "j"
end, opts .. { expr = true })

vim.keymap.set({ "n", "x" }, "k", function()
    return vim.v.count == 0 and "gk" or "k"
end, opts .. { expr = true })

-- vim.keymap.set("x", "J", ":m '>+1<CR>gv=gv", opts .. { desc = "Move selection down" })
-- vim.keymap.set("x", "K", ":m '<-2<CR>gv=gv", opts .. { desc = "Move selection up" })

vim.keymap.set({ "n", "x" }, "<C-h>", "<C-w>h", opts)
vim.keymap.set({ "n", "x" }, "<C-l>", "<C-w>l", opts)
vim.keymap.set({ "n", "x" }, "<C-j>", "<C-w>j", opts)
vim.keymap.set({ "n", "x" }, "<C-k>", "<C-w>k", opts)

vim.keymap.set("x", "<", "<gv", opts)
vim.keymap.set("x", ">", ">gv", opts)

vim.keymap.set("n", "<Space>", "<Nop>", opts)
vim.keymap.set("n", "<BS>", "<Nop>", opts)

-- tabs
for i = 1, 9 do
    vim.keymap.set("n", "<M-" .. i .. ">", i .. "gt", opts .. { desc = "Jump to tab #" .. i })
end
vim.keymap.set("n", "<leader>dt", "<cmd>tabclose<CR>", opts .. { desc = "Delete current tab" })

-- buffers
vim.keymap.set("n", "gb", "<cmd>bnext<CR>", opts .. { desc = "Jump to the next buffer" })
vim.keymap.set("n", "gB", "<cmd>bprev<CR>", opts .. { desc = "Jump to the previous buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdel<CR>", opts .. { desc = "Delete current buffer" })

-- quickfix
vim.keymap.set({ "n", "i" }, "<M-j>", "<cmd>cnext<CR>", opts .. { desc = "Jump to the next quickfix item" })
vim.keymap.set({ "n", "i" }, "<M-k>", "<cmd>cprev<CR>", opts .. { desc = "Jump to the previous quickfix item" })

-- lsp
vim.keymap.set("n", "grd", vim.lsp.buf.definition, opts .. { desc = "Jump to definition" })
vim.keymap.set("n", "grD", vim.lsp.buf.declaration, opts .. { desc = "Jump to declaration" })
vim.keymap.set("n", "grt", vim.lsp.buf.type_definition, opts .. { desc = "Jump to type definition" })

-- diagnostic
vim.keymap.set("n", "<leader>c", vim.diagnostic.setloclist, opts .. { desc = "Open quickfix diagnostic list" })
vim.keymap.set("n", "gd", function()
    vim.diagnostic.jump({ count = 1, float = true })
end, opts .. { desc = "Jump to the next diagnostic message" })
vim.keymap.set("n", "gD", function()
    vim.diagnostic.jump({ count = -1, float = true })
end, opts .. { desc = "Jump to the previous diagnostic message" })
