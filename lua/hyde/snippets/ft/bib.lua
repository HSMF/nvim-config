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
    s("online", {
        t("@online{"),
        i(1),
        t({ ",", "" }),

        t("\tauthor = {"),
        i(2),
        t({ "},", "\ttitle = {" }),
        i(3),
        t({ "},", "\turl = {" }),
        i(4),
        t({ "},", "\turldate = {" }),
        d(5, function()
            return sn(nil, i(1, os.date("%Y-%m-%d")))
        end, nil, {}),
        t({ "},", "}" }),
    }),
}
