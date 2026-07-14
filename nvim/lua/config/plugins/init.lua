---@param domain string
---@return fun(repo: string): string
local function make_url(domain)
    return function(repo)
        return "https://" .. domain .. "/" .. repo
    end
end

_G.gh = make_url("github.com")
_G.gl = make_url("gitlab.com")
_G.cb = make_url("codeberg.org")

require("config.plugins.icons")
require("config.plugins.oil")

require("config.plugins.lsp")
require("config.plugins.format")
require("config.plugins.lint")
require("config.plugins.mason")

require("config.plugins.treesitter")

require("config.plugins.surround")
require("config.plugins.pairs")
require("config.plugins.undotree")
require("config.plugins.git")
require("config.plugins.picker")

vim.api.nvim_create_user_command("PackUpdate", function()
    vim.pack.update()
end, {})
