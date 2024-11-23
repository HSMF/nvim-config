local ls = require("luasnip")
local shared = require("hyde.snippets")
local autos = shared.autos
local get_visual = shared.get_visual

local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local rep = require("luasnip.extras").rep
local fmta = require("luasnip.extras.fmt").fmta

local function append(tbl, more)
    for _, value in ipairs(more) do
        tbl[#tbl + 1] = value
    end
end

--- prepends a backslash to the string, minimal gains
local function cmd(str)
    return t("\\" .. str)
end

local function reg_trig(trig)
    return {
        trig = trig,
        regTrig = true,
        wordTrig = false,
    }
end

local function in_mathzone()
    return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end
local function in_text()
    return not in_mathzone()
end
local function in_comment()
    return vim.fn["vimtex#syntax#in_comment"]() == 1
end
local function in_env(name)
    local is_inside = vim.fn["vimtex#env#is_inside"](name)
    return (is_inside[1] > 0 and is_inside[2] > 0)
end
local function in_equation() -- equation environment detection
    return in_env("equation")
end
local function in_itemize() -- itemize environment detection
    return in_env("itemize")
end
local function in_tikz() -- TikZ picture environment detection
    return in_env("tikzpicture")
end

local M = {
    autos(";a", { t([[\alpha]]) }),
    autos(";b", { t([[\beta]]) }),
    autos(";g", { t([[\gamma]]) }),
    autos(";e", { t([[\vareps]]) }),
    autos(";p", { t([[\varphi]]) }),
    autos(
        { trig = "([^%a])ff", regTrig = true, wordTrig = false },
        fmta([[<>\frac{<>}{<>}]], {
            shared.first_capture(),
            d(1, get_visual),
            i(2),
        }),
        { condition = in_mathzone }
    ),
    s("env", {
        cmd("begin{"),
        i(1),
        t({ "}", "\t" }),
        i(0),
        t({ "", [[\end{]] }),
        rep(1),
        t("}"),
    }),
    s("frame", {
        t({ [[\begin{frame}]], "" }),
        t("\t\\frametitle{"),
        i(1),
        t({ "}", "\t" }),
        i(0),
        t({ "", [[\end{frame}]] }),
    }),
    s(
        { trig = "hr", dscr = "The hyperref package's href{}{} command (for url links)" },
        fmta([[\href{<>}{<>}]], {
            i(1, "url"),
            i(2, "display name"),
        })
    ),
    autos(
        reg_trig("([^%a])ee"),
        fmta("<>e^{<>}", {
            shared.first_capture(),
            d(1, get_visual),
        })
    ),
    autos(
        reg_trig("([^%a])mm"),
        fmta("<>$ <> $", {
            shared.first_capture(),
            d(1, get_visual),
        }),
        {
            condition = in_text,
        }
    ),
    autos(
        "dd",
        fmta("\\draw [<>] ", {
            i(1, "params"),
        }),
        { condition = in_tikz }
    ),
    autos("ii", t([[\item ]]), { condition = in_itemize }),
}

-- modifiers
append(M, {
    autos(
        "tii",
        fmta([[\textit{<>}]], {
            d(1, get_visual),
        })
    ),
    autos(
        "tbb",
        fmta([[\textbf{<>}]], {
            d(1, get_visual),
        })
    ),
    autos(
        "ul",
        fmta([[\underline{<>}]], {
            d(1, get_visual),
        })
    ),
    autos("tt", fmta("\\texttt{<>}", { d(1, get_visual) })),
    s("gos", { t([[Go standard library]]) }),
    s("pmatrix", fmta([[\begin{pmatrix}<>\end{pmatrix}]], { i(1) })),
})

for idx = 1, 10, 1 do
    local pat = "([%a%(%)%{%}%[%]])" .. idx .. idx
    M[#M + 1] = autos(reg_trig(pat), fmta("<>_{<>}", { shared.first_capture(), t("" .. idx) }))
end
return M
