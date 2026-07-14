vim.pack.add({ gh("nvim-mini/mini.pick") })

local pick = require("mini.pick")

pick.setup({
    options = {
        use_cache = true,
    },
    window = {
        config = function()
            local columns = vim.api.nvim_get_option_value("columns", { scope = "global" })
            local lines = vim.api.nvim_get_option_value("lines", { scope = "global" })
            local width = math.floor(columns * 0.6)
            local height = math.floor(lines * 0.6)
            return {
                width = width,
                height = height,
                col = (columns - width) / 2,
                row = (lines - height) / 2,
                anchor = "NW",
            }
        end,
    },
})

_G.MiniPick = nil

vim.keymap.set("n", "<leader>ff", pick.builtin.files)
vim.keymap.set("n", "<leader>fh", pick.builtin.help)
vim.keymap.set("n", "<leader>fg", pick.builtin.grep_live)
