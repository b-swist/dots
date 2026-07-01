vim.pack.add({ cb("mfussenegger/nvim-lint") })

local linters = {}

local lint = require("lint")

lint.linters_by_ft = {}

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
    group = vim.api.nvim_create_augroup("AutoLint", { clear = true }),
    callback = function()
        lint.try_lint()
    end,
})

vim.keymap.set("n", "grl", lint.try_lint)

return { linters = linters }
