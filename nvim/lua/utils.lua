local M = {}

---@param ... table
---@return table
M.merge_lists = function(...)
    local result = {} ---@type table
    for i = 1, select("#", ...) do
        local tbl = select(i, ...) --[[@as table]]
        if tbl then
            for _, v in pairs(tbl) do
                table.insert(result, v)
            end
        end
    end
    return vim.list.unique(result)
end

return M
