local ts_utils = require("nvim-treesitter.ts_utils")

local M = {}

-- local function p(node)
--     return node:sexpr()
-- end

local function t(node)
    return vim.treesitter.get_node_text(node, 0)
end

local function filter_treesitter_parent(node, pred)
    while node ~= nil do
        if pred(node) then
            return node
        end
        node = node:parent()
    end

    return nil
end

local function warn(msg)
    return vim.notify(msg, vim.log.levels.WARN)
end

local function first_field(node, field)
    local f = node:field(field)
    if f == nil then
        return nil
    end
    return f[1]
end

local function name_of_declaration(node)
    if node == nil then
        return nil
    end
    local node_type = node:type()
    if node_type == "identifier" then
        return t(node)
    end
    local declarator = first_field(node, "declarator")
    if declarator == nil then
        warn(string.format("node %s has no declarator", node_type))
        return nil
    end
    return name_of_declaration(declarator)
end

local function find_func_decl(return_type, node)
    local node_type = node:type()
    if node_type == "pointer_declarator" then
        local declarator = first_field(node, "declarator")
        if declarator == nil then
            warn(string.format("node %s has no declarator", node_type))
            return nil, return_type
        end
        return find_func_decl(return_type .. "*", declarator)
    elseif node_type == "function_declarator" then
        return node, return_type
    else
        warn("unknown node type " .. node_type)
        return nil, return_type
    end
end

local function get_info(func_node)
    local type = first_field(func_node, "type")
    if type == nil then
        warn("no type found for function")
        return
    end

    local declarator = first_field(func_node, "declarator")
    if declarator == nil then
        return
    end

    local fn, return_type = find_func_decl(t(type), declarator)
    if fn == nil then
        return
    end

    local parameters_list = first_field(fn, "parameters")
    if parameters_list == nil then
        warn("no parameter list")
        return
    end

    local parameters = {}
    for child in parameters_list:iter_children() do
        if child:named() and child:type() == "parameter_declaration" then
            parameters[#parameters + 1] = name_of_declaration(child)
        end
    end
    return {
        parameters = parameters,
        return_type = return_type,
    }
end

local function is_comment_node(node)
    if node == nil then
        return false
    end

    return node:type() == "comment"
end

local function return_type_text(return_type)
    if return_type == "void" then
        return nil
    elseif return_type == "errval_t" then
        return "error value indicating the success of the operation"
    end
    return ""
end

local function param_text(param)
    if param == "mm" then
        return " the memory manager"
    else
        return nil
    end
end

function M.generate_doc_comment()
    local cursor_node = ts_utils.get_node_at_cursor()
    local func_node = filter_treesitter_parent(cursor_node, function(v)
        return v:type() == "function_definition" or v:type() == "declaration"
    end)
    if func_node == nil then
        warn("no function node")
        return
    end
    if is_comment_node(func_node:prev_sibling()) then
        warn("function already has doc comment")
        return
    end
    local info = get_info(func_node)
    if info == nil then
        return
    end
    local row1, _, _, _ = func_node:range()
    local text = {
        "/**",
        " * @brief",
    }

    if #info.parameters > 0 then
        text[#text + 1] = " *"
    end

    for _, param in ipairs(info.parameters) do
        local doc_prompt = param_text(param) or ""
        text[#text + 1] = string.format(" * @param %s%s", param, doc_prompt)
    end

    local return_text = return_type_text(info.return_type)
    if return_text ~= nil then
        text[#text + 1] = " *"
        text[#text + 1] = string.format(" * @return %s", return_text)
    end
    text[#text + 1] = " */"
    vim.api.nvim_buf_set_lines(0, row1, row1, true, text)
end

function M.reload()
    package.loaded.cdoc = nil
    return require("cdoc")
end

return M
