vim.g.nerd_font = true

vim.o.mouse = "a"
vim.o.confirm = true
vim.o.undofile = true

vim.o.splitbelow = true
vim.o.splitright = true
vim.o.scrolloff = 6

vim.o.updatetime = 500
vim.o.timeoutlen = 600

vim.schedule(function()
    vim.o.clipboard = "unnamedplus"
end)

vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"

vim.o.list = true
vim.o.listchars = "tab:> ,trail:-,nbsp:."

vim.o.virtualedit = "block"
vim.o.guicursor = "n-v-c-sm:block,i-ci-ve-t:ver25,r-cr-o:hor20"
vim.o.winborder = "single"

vim.o.pumheight = 20
vim.o.shortmess = vim.o.shortmess .. "c"

vim.o.wildmode = "noselect:lastused,full"
vim.o.wildoptions = "pum"

vim.o.complete = "o"
vim.o.completeopt = "menuone,popup,noselect,fuzzy"

vim.o.foldenable = true
vim.o.foldlevelstart = 99
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"

vim.o.wrap = true
vim.o.linebreak = true
vim.o.breakindent = true

vim.o.tabstop = 4
vim.o.shiftwidth = 0
vim.o.softtabstop = -1
vim.o.expandtab = false
vim.o.smarttab = true

vim.o.ignorecase = true
vim.o.infercase = true
vim.o.smartcase = true
vim.o.inccommand = "split"
