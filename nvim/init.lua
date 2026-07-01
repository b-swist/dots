if vim.fn.has("nvim-0.12") ~= 1 then
    vim.notify("this config works only works with version 0.12")
    return
end

vim.loader.enable()
require("vim._core.ui2").enable()

require("config")
require("plugins")

vim.cmd.colorscheme("retrobox")
