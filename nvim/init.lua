require("config.opts")
require("config.keymaps")
require("config.lazy")

vim.cmd.colorscheme("retrobox")

vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("yank-highlight", { clear = true }),
    callback = function()
        vim.hl.on_yank({
            -- higroup = "Visual",
            timeout = 220,
        })
    end,
})
