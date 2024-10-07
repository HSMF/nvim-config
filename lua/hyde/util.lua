local M = {}

function M.require(path) end

function M.get_vars()
    local config_dir = vim.api.nvim_list_runtime_paths()[1]
    local path = config_dir .. "/lua/hyde/vars.lua"
    if vim.fn.filereadable(path) ~= 0 then
        return require("hyde.vars")
    end

    local file = io.open(path, "w")
    if file == nil then
        return {}
    end

    file:write([[
return {
    auto_format = false,
    latex_viewer = "zathura",
    after_conf = function() end
}]])
    file:close()

    return require("hyde.vars")
end

function M.filter_treesitter_parent(node, pred)
    while node ~= nil do
        if pred(node) then
            return node
        end
        node = node:parent()
    end

    return nil
end

---iterate over captures and applies the correct function
---@param query Query
---@param node TSNode
---@param cases table<string, fun(node: TSNode, accum: any)> function to apply to the node, if the capture is not present, it is ignored
---@param initial_value any
function M.reduce_captures(query, node, cases, initial_value)
    if initial_value == nil then
        initial_value = {}
    end
    for id, node in query:iter_captures(node, 0) do
        local name = query.captures[id]
        local fun = cases[name]
        if fun ~= nil then
            initial_value = fun(node, initial_value)
        end
    end
    return initial_value
end

local parser_map = {
    html = "html",
    typescriptreact = "tsx",
    javascriptreact = "jsx",
}

function M.parser_of_filetype(filetype)
    local parser = parser_map[filetype]
    if parser == nil then
        -- maybe it's the same ¯\_(ツ)_/¯
        return filetype
    end
    return parser
end

--- returns the first integer `i` such that `low <= i <= high and p(index)` or `nil` if none was found
--- @param p function
--- @param low number
--- @param high number
--- @param index number|nil
--- @param offset number|nil
--- @return any
function M.find_index(p, low, high, index, offset)
    if offset == nil then
        offset = 1
    end
    if index == nil and offset > 0 then
        index = low
    end
    if index == nil and offset < 0 then
        index = high
    end
    while low <= index and index <= high do
        if p(index) then
            return index
        end
        index = index + offset
    end
end

--- returns the index of first element such that `p(tbl[index])` holds, or nil if none was found
---@param tbl table
---@param p function
---@param index number|nil
---@param offset number|nil
---@return number|nil
function M.tbl_find_index(tbl, p, index, offset)
    offset = offset or 1
    index = index or 1
    while 1 <= index and index <= #tbl do
        if p(tbl[index]) then
            return index
        end
        index = index + offset
    end

    return nil
end

return M
