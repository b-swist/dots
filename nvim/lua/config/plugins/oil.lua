vim.pack.add({ gh("stevearc/oil.nvim") })

local oil = require("oil")

oil.setup({
    default_file_explorer = true,
    skip_confirm_for_simple_edits = true,
    view_options = {
        show_hidden = true,
    },
})

vim.keymap.set("n", "<leader>e", function()
    if vim.bo.ft ~= "oil" then
        oil.open()
    else
        oil.close()
    end
end)
