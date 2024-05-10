local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node

local M = {}

M.same = function(index)
    return f(function(args)
        return args[1]
    end, { index })
end

M.autos = function(context, nodes, opts)
    if type(context) == "string" then
        context = {
            trig = context,
        }
    end
    context["snippetType"] = "autosnippet"
    return s(context, nodes, opts)
end

M.get_visual = function(args, parent)
    if #parent.snippet.env.LS_SELECT_RAW > 0 then
        return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
    else -- If LS_SELECT_RAW is empty, return a blank insert node
        return sn(nil, i(1))
    end
end

M.first_capture = function()
    return f(function(_, snip)
        return snip.captures[1]
    end)
end

return M
