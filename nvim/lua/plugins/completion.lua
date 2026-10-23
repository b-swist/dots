vim.pack.add({ gh("saghen/blink.lib"), gh("saghen/blink.cmp") })

local blink = require("blink.cmp")

local setup = function()
    blink.setup({
        appearance = {
            nerd_font_variant = "normal",
        },
        cmdline = {
            keymap = {
                preset = "inherit",
            },
            completion = {
                menu = {
                    auto_show = function()
                        return vim.fn.getcmdtype() == ":"
                    end,
                },
            },
        },
    })
end

blink.build():map(setup):catch(function(err)
    vim.notify("blink.cmp build failed: " .. tostring(err), vim.log.levels.ERROR)
end)
