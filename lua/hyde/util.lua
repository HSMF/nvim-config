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
---@param query TSQuery
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

function M.parser_of_filetype(filetype)
    return vim.treesitter.language.get_lang(filetype)
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

-- functions taken from the master branch of nvim-treesitter.
-- this is to not break my config while also having updated query files

---@param bufnr integer|nil
---@param lang string|nil
function M.get_parser(bufnr, lang)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    lang = lang or vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)

    return vim.treesitter.get_parser(bufnr, lang)
end

function M.get_node_at_cursor(winnr, ignore_injected_langs)
    winnr = winnr or 0
    local cursor = api.nvim_win_get_cursor(winnr)
    local cursor_range = { cursor[1] - 1, cursor[2] }

    local buf = vim.api.nvim_win_get_buf(winnr)
    local root_lang_tree = M.get_parser(buf)
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

function M.get_root_for_position(line, col, root_lang_tree)
    if not root_lang_tree then
        root_lang_tree = M.get_parser()
        if root_lang_tree == nil then
            return
        end
    end

    local lang_tree = root_lang_tree:language_for_range({ line, col, line, col })

    while true do
        for _, tree in pairs(lang_tree:trees()) do
            local root = tree:root()

            if root and vim.treesitter.is_in_node_range(root, line, col) then
                return root, tree, lang_tree
            end
        end

        if lang_tree == root_lang_tree then
            break
        end

        -- This case can happen when the cursor is at the start of a line that ends a injected region,
        -- e.g., the first `]` in the following lua code:
        -- ```
        -- vim.cmd[[
        -- ]]
        -- ```
        lang_tree = lang_tree:parent() -- NOTE: parent() method is private
    end

    -- This isn't a likely scenario, since the position must belong to a tree somewhere.
    return nil, nil, lang_tree
end

---@param node TSNode
---@return TSNode result
function M.get_root_for_node(node)
    local parent = node
    local result = node

    while parent ~= nil do
        result = parent
        parent = result:parent()
    end

    return result
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

        local scope = M.containing_scope(last_node, bufnr, false) or M.get_root_for_node(node)

        last_node = scope:parent()

        return scope
    end
end

---@param node TSNode
---@param bufnr? integer
---@param allow_scope? boolean
---@return TSNode|nil
function M.containing_scope(node, bufnr, allow_scope)
    bufnr = bufnr or api.nvim_get_current_buf()
    allow_scope = allow_scope == nil or allow_scope == true

    local scopes = M.get_scopes(bufnr)
    if not node or not scopes then
        return
    end

    local iter_node = node

    while iter_node ~= nil and not vim.tbl_contains(scopes, iter_node) do
        iter_node = iter_node:parent()
    end

    return iter_node or (allow_scope and node or nil)
end

function M.get_scopes(bufnr)
    local locals = M.get_locals(bufnr)

    local scopes = {}

    for _, loc in ipairs(locals) do
        if loc["local"]["scope"] and loc["local"]["scope"].node then
            table.insert(scopes, loc["local"]["scope"].node)
        end
    end

    return scopes
end

---@param bufnr integer
---@return any
function M.get_locals(bufnr)
    return M.get_matches(bufnr, "locals")
end

local EMPTY_ITER = function() end

---@class QueryInfo
---@field root TSNode
---@field source integer
---@field start integer
---@field stop integer

---@param bufnr integer
---@param query_name string
---@param root TSNode
---@param root_lang string|nil
---@return vim.treesitter.Query|nil, QueryInfo|nil
local function prepare_query(bufnr, query_name, root, root_lang)
    local parser = M.get_parser(bufnr)
    if not parser then
        return
    end

    if not root then
        local first_tree = parser:trees()[1]

        if first_tree then
            root = first_tree:root()
        end
    end

    if not root then
        return
    end

    local range = { root:range() }

    if not root_lang then
        local lang_tree = parser:language_for_range(range)

        if lang_tree then
            root_lang = lang_tree:lang()
        end
    end

    if not root_lang then
        return
    end

    local query = vim.treesitter.query.get(root_lang, query_name)
    if not query then
        return
    end

    return query,
        {
            root = root,
            source = bufnr,
            start = range[1],
            -- The end row is exclusive so we need to add 1 to it.
            stop = range[3] + 1,
        }
end

---Iterates matches from a query file.
---@param bufnr integer the buffer
---@param query_group string the query file to use
---@param root TSNode the root node
---@param root_lang? string the root node lang, if known
function M.iter_group_results(bufnr, query_group, root, root_lang)
    local query, params = prepare_query(bufnr, query_group, root, root_lang)
    if not query then
        return EMPTY_ITER
    end
    assert(params)

    return M.iter_prepared_matches(query, params.root, params.source, params.start, params.stop)
end

function M.collect_group_results(bufnr, query_group, root, lang)
    local matches = {}

    for prepared_match in M.iter_group_results(bufnr, query_group, root, lang) do
        table.insert(matches, prepared_match)
    end

    return matches
end

---@param bufnr integer
---@param query_group string
---@return any
function M.get_matches(bufnr, query_group)
    bufnr = bufnr or api.nvim_get_current_buf()
    return M.collect_group_results(bufnr, query_group) or {}
end

return M
