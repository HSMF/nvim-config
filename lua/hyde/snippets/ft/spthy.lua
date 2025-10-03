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

return {
    s("rule", fmta([[
rule <>:
	[ <> ]
	--[
		<>
	]->>
	[ <> ]
    ]], { i(1), i(2), i(3), i(4) } ))
}
