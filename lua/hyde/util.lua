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

return M
