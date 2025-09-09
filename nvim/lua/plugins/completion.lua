return {
    "saghen/blink.cmp",
    dependencies = {
        { "nvim-mini/mini.icons", config = true },
        "L3MON4D3/LuaSnip",
    },
    event = "InsertEnter",
    version = "1.*",
    opts = {
        appearance = {
            nerd_font_variant = "normal",
        },
        fuzzy = {
            sorts = { "exact", "score", "sort_text" },
        },
        sources = {
            default = { "snippets", "lsp", "path", "buffer" },
        },
        signature = { enabled = true },
        snippets = { preset = "luasnip" },

        completion = {
            keyword = { range = "full" },
            ghost_text = { enabled = true },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 500,
            },
            menu = {
                auto_show = true,
                draw = {
                    components = {
                        kind_icon = {
                            text = function(ctx)
                                local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                                return kind_icon
                            end,
                            highlight = function(ctx)
                                local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                                return hl
                            end,
                        },
                        kind = {
                            highlight = function(ctx)
                                local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                                return hl
                            end,
                        },
                    },
                },
            },
        },
    },
}
