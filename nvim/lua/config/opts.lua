vim.schedule(function()
    vim.o.clipboard = "unnamedplus"
end)
vim.o.mouse = "a"
vim.o.confirm = true
vim.o.undofile = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.scrolloff = 6
vim.o.exrc = true

vim.o.updatetime = 500
vim.o.timeoutlen = 650

vim.o.foldlevelstart = 99

vim.o.number = true
vim.o.relativenumber = true
vim.o.list = true
vim.o.listchars = "tab:> ,trail:-,nbsp:."
vim.o.showmode = true
vim.o.signcolumn = "yes"
vim.o.showtabline = 1
vim.o.virtualedit = "block"
vim.o.guicursor = "n-v-c-sm:block,i-ci-ve-t:ver25,r-cr-o:hor20"
vim.o.winborder = "rounded"
vim.o.completeopt = "menuone,popup,noinsert"

vim.o.wrap = true
vim.o.linebreak = true
vim.o.breakindent = true
-- vim.o.showbreak = "> "
vim.o.smoothscroll = true

vim.o.tabstop = 4
vim.o.shiftwidth = 0
vim.o.softtabstop = -1
vim.o.expandtab = true
vim.o.smarttab = true

vim.o.autoindent = true
vim.o.smartindent = true

vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.inccommand = "split"

vim.o.background = "dark"
vim.o.termguicolors = true
