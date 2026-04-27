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
local fmta = require("luasnip.extras.fmt").fmta

local function z3_ints(args)
    local text = args[1][1]
    local ret = ""
    local first = true
    for var in text:gmatch("%S+") do
        vim.print(var)
        if first then
            first = false
        else
            ret = ret .. ", "
        end
        ret = ret .. var
    end
    return ret
end

return {
    s("main", {
        t({ "def main():",
            "\tparser = argparse.ArgumentParser()",
            "\targs = parser.parse_args()",
            "\t"
        }),
        i(0),
        t({ "", "", [[if __name__ == "__main__":]], "    main()" }),
    }),
    s("smtmain", fmta([[
    from z3 import *

    s = Solver()
    s.set(auto_config=False, mbqi=False)

    <>

    print(s.check())
    ]], { i(0) })),
    s("forall", fmta([[ForAll([<>], <>, patterns=[<>])]], {
        i(1),
        i(2),
        i(3)
    })),
    s("ints", {
        f(z3_ints, { 1 }, { user_args = {} }),
        t(' = Ints("'),
        i(1, "var"),
        t('")'),
    }),
}
