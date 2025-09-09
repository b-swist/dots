return {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    version = "v2.*",
    build = "make install_jsregexp",
    cond = function()
        return vim.fn.executable("make") == 1
    end,
}
