local M = {}

function M.require(path) end

local api = vim.api

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

function M.pick_by_host(options)
    local sysname = vim.loop.os_uname().sysname
    local hostname = vim.loop.os_gethostname()

    if options[hostname] ~= nil then
        return options[hostname]
    end

    if sysname == "Linux" then
        return options.linux
    end
    if sysname == "Darwin" then
        return options.mac
    end
    return options.default
end

function M.get_node_at_cursor(winnr, ignore_injected_langs)
    winnr = winnr or 0
    local cursor = api.nvim_win_get_cursor(winnr)
    local cursor_range = { cursor[1] - 1, cursor[2] }

    local buf = vim.api.nvim_win_get_buf(winnr)
    local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
    local root_lang_tree = vim.treesitter.get_parser(buf, lang)
    if not root_lang_tree then
        return
    end

    local root ---@type TSNode|nil
    if ignore_injected_langs then
        for _, tree in pairs(root_lang_tree:trees()) do
            local tree_root = tree:root()
            if tree_root and vim.treesitter.is_in_node_range(tree_root, cursor_range[1], cursor_range[2]) then
                root = tree_root
                break
            end
        end
    else
        root = M.get_root_for_position(cursor_range[1], cursor_range[2], root_lang_tree)
    end

    if not root then
        return
    end

    return root:named_descendant_for_range(cursor_range[1], cursor_range[2], cursor_range[1], cursor_range[2])
end

-- Gets a table with all the scopes containing a node
-- The order is from most specific to least (bottom up)
---@param node TSNode
---@param bufnr integer
---@return TSNode[]
function M.get_scope_tree(node, bufnr)
    local scopes = {} ---@type TSNode[]

    for scope in M.iter_scope_tree(node, bufnr) do
        table.insert(scopes, scope)
    end

    return scopes
end

-- Iterates over a nodes scopes moving from the bottom up
---@param node TSNode
---@param bufnr integer
---@return fun(): TSNode|nil
function M.iter_scope_tree(node, bufnr)
    local last_node = node
    return function()
        if not last_node then
            return
        end

        local scope = M.containing_scope(last_node, bufnr, false) or ts_utils.get_root_for_node(node)

        last_node = scope:parent()

        return scope
    end
end

return M
