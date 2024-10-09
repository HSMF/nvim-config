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
local autos = shared.autos
local fmta = require("luasnip.extras.fmt").fmta
local M = {}

local auto_expand = {
    [ [[\and]] ] = "∧",
    [ [[\or]] ] = "∨",
    [ [[\exists]] ] = "∃",
    [ [[\forall]] ] = "∀",
    [ [[\iff]] ] = "↔",
    [ [[->]] ] = "→",
}

for trig, expand in pairs(auto_expand) do
    M[#M + 1] = autos(trig, t(expand))
end


return M
