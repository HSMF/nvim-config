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

local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep
local util = require("hyde.util")
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
    local cursor_node = util.get_node_at_cursor()
    if cursor_node == nil then
        return
    end

    local function_node = util.filter_treesitter_parent(cursor_node, function(v)
        return v:type() == "function_declaration" or v:type() == "method_declaration" or v:type() == "func_literal"
    end)

    if function_node == nil then
        return i(1, "nil")
    end

    local query = vim.treesitter.query.get("go", "LuaSnip_Result")
    if query == nil then
        return i(1, "nil")
    end
    for _, node in query:iter_captures(function_node, 0) do
        if handlers[node:type()] then
            return handlers[node:type()](node, opts)
        end
    end

    return {}
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

local function slice_invariant()
    local low = 1
    local high = 2
    local name = 3

    return s("slice_invariant", {
        t("0 <= "),
        i(low, "lo"),
        t(" && "),
        rep(low),
        t(" <= "),
        i(high, "hi"),
        t(" && "),
        rep(high),
        t(" <= len("),
        i(name, "s"),
        t(")"),
    })
end

local function slice_eq()
    local index = 1
    local arr = 2
    local slice = 3
    local endslice = 4
    return s("sliceeq", {
        t("forall "),
        i(index, "i"),
        t(" int :: {&"),
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

local function bytes(lbl)
    local name = 1
    local start = 2
    -- local e = 3
    local perm = 3
    return s(lbl, {
        t("acc(sl.Bytes("),
        i(name, "s"),
        t(", "),
        i(start, "0"),
        t(", len("),
        rep(name),
        t(")), "),
        i(perm, "R40"),
        t(")"),
    })
end

local function pforall()
    local j = 1
    local low = 2
    local high = 3
    local property = 4
    local trigger = 5

    return s("pforall", {
        t("invariant InRangeInc("),
        rep(j),
        t(", "),
        rep(low),
        t(", "),
        rep(high),
        t({ ")", "" }),
        t("invariant forall i0 int :: { "),
        i(trigger),
        t(" }"),
        t(" InRange(i0, "),
        rep(low),
        t(", "),
        rep(j),
        t({ ") ==> ", "" }),
        t("\t"),
        i(property, "true"),
        t({ "", "" }),
        t("decreases "),
        rep(high),
        t(" - "),
        rep(low),
        t({ "", "" }),
        t("for "),
        i(j, "j"),
        t(" := "),
        i(low, "0"),
        t("; "),
        rep(j),
        t(" < "),
        i(high, "len(s)"),
        t("; "),
        rep(j),
        t({ "++ {", "\t" }),
        i(0),
        t({ "", "}" }),
    })
end

local function outline()
    return s(
        "outline",
        fmt(
            [[
requires {}
ensures {}
decreases
outline (
    {}
)
        ]],
            { i(1), i(2), i(0) }
        )
    )
end

local function block()
    return s(
        "block",
        fmt(
            [[
/* @
{}
@ */
        ]],
            { i(0) }
        )
    )
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
        t(" int :: {&"),
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
        i(3, ", R40"),
        t(")"),
    }),
    slice_eq(),
    slice_invariant(),
    bytes("bytes"),
    bytes("accbytes"),
    s("flemma", {
        t({ "ghost", "" }),
        t({ "decreases", "" }),
        t("func lemma"),
        i(1, ""),
        t("("),
        i(2, ""),
        t(")"),
        t({ " {", "" }),
        t("\t"),
        i(0),
        t({ "", "}" }),
    }),
    s("pfunc", {
        t({ "ghost", "" }),
        t({ "decreases", "" }),
        t("pure func "),
        i(1, "name"),
        t("("),
        i(2, ""),
        t(") (res "),
        i(3, ""),
        t(")"),
        t({ " {", "" }),
        t("\t"),
        i(0),
        t({ "", "}" }),
    }),
    pforall(),
    outline(),
    block(),
}
