vim.schedule(function()
    vim.pack.add({ gh("nvim-mini/mini.notify") })

    require("mini.notify").setup({
        content = {
            format = function(notif)
                return string.format("%s │ %s", notif.level, notif.msg)
            end,
        },
    })

    _G.MiniNotify = nil
end)
