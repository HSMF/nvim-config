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
local M = {
    s("inversion", {
        t("inversion "),
        i(1),
        t("; simplify_eq. "),
    }),
}

local auto_expand = {
    [ [[\and]] ] = "∧",
    [ [[\or]] ] = "∨",
    [ [[\exists]] ] = "∃",
    [ [[\forall]] ] = "∀",
    [ [[\iff]] ] = "↔",
    [ [[->]] ] = "→",
    [ [[\succ]] ] = "≻",
    [ [[>>]] ] = "≻",
    [ [[\down]] ] = "↓",
    [ [[\squigright]] ] = "⇝",
    [ [[~>]] ] = "⇝",
    [ [[\Gamma]] ] = "Γ",
    [ [[|-]] ] = "⊢",
    [ [[\Lambda]] ] = "Λ",
    [ [[\lambda]] ] = "λ",
    [ [[\tau]] ] = "τ"
}

local words = {
    "simpl",
    "simplify_eq",
    "induction",
    "intros",
}

for trig, expand in pairs(auto_expand) do
    M[#M + 1] = autos(trig, t(expand))
end

for _, expand in ipairs(words) do
    M[#M + 1] = s(expand, t(expand))
end

return M
