local ls = require("luasnip")
local shared = require("hyde.snippets")

local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node

local ts_locals = require("nvim-treesitter.locals")
local ts_utils = require("nvim-treesitter.ts_utils")
local get_node_text = vim.treesitter.get_node_text

vim.treesitter.query.set(
    "ocaml",
    "LuaSnip_FunctionName",
    [[
    (let_binding pattern: (_) @fname)
    ]]
)

vim.treesitter.query.set(
    "ocaml",
    "LuaSnip_MatchCasePattern",
    [[
    (match_case pattern: (_) @pattern)
    ]]
)

local function todo_info()
    local cursor_node = ts_utils.get_node_at_cursor()
    local scope = ts_locals.get_scope_tree(cursor_node, 0)
    local around_cursor = scope[1]
    local compilation_unit
    for j = #scope, 1, -1 do
        if scope[j]:type() == "let_binding" then
            compilation_unit = scope[j]
            break
        end
    end
    local query_function_name = vim.treesitter.query.get("ocaml", "LuaSnip_FunctionName")
    local query_match_case_pattern = vim.treesitter.query.get("ocaml", "LuaSnip_MatchCasePattern")

    if compilation_unit == nil then
        return "todo"
    end

    local text = ""

    for _, node in query_function_name:iter_captures(compilation_unit, 0) do
        text = text .. " " .. get_node_text(node, 0)
        break
    end
    for _, node in query_match_case_pattern:iter_captures(around_cursor, 0) do
        text = text .. " case " .. get_node_text(node, 0)
    end
    text = text:gsub("\n", " ")

    return "todo" .. text
end

return {
    s("todo", {
        t('(failwith "'),

        f(todo_info, {}),
        t('")'),
    }),
}
