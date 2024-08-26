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

local rep = require("luasnip.extras").rep
local ts_locals = require("nvim-treesitter.locals")
local ts_utils = require("nvim-treesitter.ts_utils")
local get_node_text = vim.treesitter.get_node_text

vim.treesitter.query.set(
    "go",
    "LuaSnip_Result",
    [[ [
    (method_declaration result: (_) @id)
    (function_declaration result: (_) @id)
    (func_literal result: (_) @id)
  ] ]]
)

local transform = function(text, info)
    if text == "int" then
        return t("0")
    elseif text == "error" then
        if info then
            info.index = info.index + 1

            return c(info.index, {
                t(string.format('fmt.Errorf("%s: %%v", %s)', info.func_name, info.err_name)),
                t(info.err_name),
                -- Be cautious with wrapping, it makes the error part of the API of the
                -- function, see https://go.dev/blog/go1.13-errors#whether-to-wrap
                t(string.format('fmt.Errorf("%s: %%w", %s)', info.func_name, info.err_name)),
                -- Old style (pre 1.13, see https://go.dev/blog/go1.13-errors), using
                -- https://github.com/pkg/errors
                t(string.format('errors.Wrap(%s, "%s")', info.err_name, info.func_name)),
            })
        else
            return t("err")
        end
    elseif text == "bool" then
        return t("false")
    elseif text == "string" then
        return t('""')
    elseif string.find(text, "*", 1, true) then
        return t("nil")
    end

    return t(text)
end

local handlers = {
    ["parameter_list"] = function(node, info)
        local result = {}

        local count = node:named_child_count()
        for idx = 0, count - 1 do
            table.insert(result, transform(get_node_text(node:named_child(idx), 0), info))
            if idx ~= count - 1 then
                table.insert(result, t({ ", " }))
            end
        end

        return result
    end,

    ["type_identifier"] = function(node, info)
        local text = get_node_text(node, 0)

        return { transform(text, info) }
    end,
}

local function go_result_type(opts)
    local cursor_node = ts_utils.get_node_at_cursor()
    local scope = ts_locals.get_scope_tree(cursor_node, 0)

    print(vim.inspect(opts))
    local function_node
    for _, v in ipairs(scope) do
        if v:type() == "function_declaration" or v:type() == "method_declaration" or v:type() == "func_literal" then
            function_node = v
            break
        end
    end

    if true then
        return { t("nil") }
    end

    local query = vim.treesitter.query.get("go", "LuaSnip_Result")
    for _, node in query:iter_captures(function_node, 0) do
        if handlers[node:type()] then
            return handlers[node:type()](node, opts)
        end
    end

    return { t("nil") }
end

local function go_return_values(args)
    return sn(
        nil,
        go_result_type({
            index = 0,
            err_name = args[1][1],
            func_name = args[2][1],
        })
    )
end

-- (
--  [
--   (
--    (short_var_declaration
--     left: (expression_list (identifier) @err))
--    (#match? @err "err")
--   )
--   (
--    (assignment_statement
--     left: (expression_list (identifier) @err))
--    (#match? @err "err")
--   )
--  ]
-- ) @assignment

local function slice_eq()
    local index = 1
    local arr = 2
    local slice = 3
    local endslice = 4
    return s("sliceeq", {
        t("forall "),
        i(index, "i"),
        t(" int :: {"),
        i(arr, "arr"),
        t("["),
        i(slice, "1"),
        t(":"),
        i(endslice, ""),
        t("]"),
        t("["),
        rep(index),
        t("]} 0 <= "),
        rep(index),
        t(" && "),
        rep(index),
        t(" < len("),
        rep(arr),
        t("["),
        rep(slice),
        t(":"),
        rep(endslice),
        t("]"),
        t(") ==> &"),
        rep(arr),
        t("["),
        rep(slice),
        t(":"),
        rep(endslice),
        t("]["),
        rep(index),
        t("] == &"),
        rep(arr),
        t("["),
        rep(index),
        t("+"),
        rep(slice),
        t("]"),
    })
end

return {
    s("iferr", {
        i(1, { "val" }),
        t(", "),
        i(2, { "err" }),
        t(" := "),
        i(3, { "f" }),
        t("("),
        i(4),
        t(")"),
        t({ "", "if " }),
        shared.same(2),
        t({ " != nil {", "\treturn " }),
        d(5, go_return_values, { 2, 3 }),
        t({ "", "}" }),
        i(0),
    }),
    s("accall", {
        t("forall "),
        i(1, "i"),
        t(" int :: {"),
        i(2, "arr"),
        t("["),
        rep(1),
        t("]} 0 <= "),
        rep(1),
        t(" && "),
        rep(1),
        t(" < len("),
        rep(2),
        t(") ==> acc(&"),
        rep(2),
        t("["),
        rep(1),
        t("]"),
        i(3, ", _"),
        t(")"),
    }),
    slice_eq(),
}
