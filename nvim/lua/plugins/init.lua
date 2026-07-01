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

require("plugins.icons")
require("plugins.oil")

require("plugins.lsp")
require("plugins.format")
require("plugins.lint")
require("plugins.mason")

require("plugins.treesitter")

require("plugins.surround")
require("plugins.pairs")
require("plugins.undotree")
require("plugins.git")
require("plugins.picker")

vim.api.nvim_create_user_command("PackUpdate", function()
    vim.pack.update()
end, {})
