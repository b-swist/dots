vim.pack.add({ cb("mfussenegger/nvim-lint") })

local lint = require("lint")

lint.linters_by_ft = {}

vim.keymap.set("n", "grl", lint.try_lint)
