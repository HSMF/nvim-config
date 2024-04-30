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

return {
    -- a snippet for snippets, how ironic
    s("snippets", {
        t({
            [[local ls = require("luasnip")]],
            [[local shared = require("hyde.snippets")]],
            [[]],
            [[local s = ls.snippet]],
            [[local sn = ls.snippet_node]],
            [[local t = ls.text_node]],
            [[local i = ls.insert_node]],
            [[local f = ls.function_node]],
            [[local c = ls.choice_node]],
            [[local d = ls.dynamic_node]],
            [[local r = ls.restore_node]],
            [[]],
            [[return {]],
            "\t",
        }),
        i(0),
        t({ "", "}" }),
    }),
}
