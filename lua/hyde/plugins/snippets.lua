local function config()
    local snip_status_ok, ls = pcall(require, "luasnip")
    if not snip_status_ok then
        return
    end

    -- https://github.com/L3MON4D3/LuaSnip/blob/master/Examples/snippets.lua#L190

    local s = ls.snippet
    local sn = ls.snippet_node
    local t = ls.text_node
    local i = ls.insert_node
    local f = ls.function_node
    local c = ls.choice_node
    local d = ls.dynamic_node
    local r = ls.restore_node

    require("luasnip.loaders.from_lua").load({ paths = { "./lua/hyde/snippets/ft/" } })

    ls.add_snippets("rust", {
        s("tests", {
            t({ "#[cfg(test)]", "mod tests {", "\tuse super::*;", "\t" }),
            i(1),
            t({ "", "}", "" }),
        }),
    })

    ls.add_snippets("python", {
        s("debug", {
            t({ [[__import__("IPython").embed()]] }),
        }),
    })

    ls.add_snippets("svelte", {
        s("script", {
            t({ [[<script lang="ts">]], "\t" }),
            i(1),
            t({ "", "</script>", "" }),
        }),
    })

    local function texsnip(chr, expand_to)
        if expand_to == nil then
            expand_to = {
                t("\\" .. chr),
            }
        end

        return s(chr, expand_to, {
            condition = function(line_to_cursor)
                return string.match(line_to_cursor, "\\" .. chr .. "$") == nil
            end,
        })
    end

    local text_snips = {
        texsnip("alpha"),
        texsnip("beta"),
        texsnip("gamma"),
        texsnip("delta"),
        texsnip("eps"),
        texsnip("omega"),
        texsnip("sigma"),
        texsnip("phi"),
        texsnip("theta"),
        texsnip("delta"),
        texsnip("Omega"),
        texsnip("Theta"),

        texsnip("infty"),

        texsnip("sqrt", {
            t("\\sqrt{"),
            i(1),
            t("}"),
            i(0),
        }),
    }

    ls.add_snippets("markdown", text_snips, { type = "autosnippets" })
    ls.add_snippets("markdown", {
        s("ccc", {
            t("`"),
            i(1),
            t("`"),
        }),
        s("cocc", {
            t({ "```", "" }),
            i(1),
            t({ "", "```" }),
        }),
        s("ccoc", {
            t({ "```", "" }),
            i(1),
            t({ "", "```" }),
        }),
        s("2#", t("## ")),
        s("3#", t("### ")),
        s("4#", t("#### ")),
        s("5#", t("##### ")),
    }, { type = "autosnippets" })
    ls.add_snippets("tex", text_snips, { type = "autosnippets" })
    ls.add_snippets("tex", {
        s("ccc", {
            t("`"),
            i(1),
            t("'"),
        }),
        -- TODO: fix autopairs
        s("l(", {
            t("\\left("),
            i(1),
            t("\\right"),
        }),
        s("//", {
            t([[\frac{]]),
            i(1),
            t([[}{]]),
            i(2),
            t([[}]]),
        }),
        s("->", {
            t([[\to]]),
        }),
    }, { type = "autosnippets" })

    ls.add_snippets("tex", {
        s("document", {

            t({ "\\documentclass{article}", "\\usepackage{hyde}", "", "\\begin{document}", "" }),
            i(1),
            t({ "", "\\end{document}" }),
        }),
    })

    local function test(args, parent, user_args)
        if args[1] ~= nil and args[1][1] ~= nil and args[1][1] ~= "" then
            if user_args ~= nil then
                return args[1][1]
            end
            return ""
        else
            local bufname = vim.api.nvim_buf_get_name(0)

            local name
            for v in string.gmatch(bufname, "[^/]+") do
                name = v
            end

            name = name:gsub("%.", "_")

            return "__" .. name .. "__"
        end
    end

    ls.add_snippets("h", {
        s("guard", {
            t("#ifdef "),
            f(
                test, -- callback (args, parent, user_args) -> string
                { 1 }, -- node indice(s) whose text is passed to fn, i.e. i(2)
                {}
            ),
            i(1),
            t({ "", "#define " }),
            f(
                test, -- callback (args, parent, user_args) -> string
                { 1 }, -- node indice(s) whose text is passed to fn, i.e. i(2)
                { user_args = { "" } }
            ),
            i(0),
            t({ "", "#endif" }),
        }),
    })

    ls.filetype_extend("h", { "c" })

    ls.add_snippets("oat", {
        s("program", {
            t({ "int program(int argc, string[] argv) {", "\t" }),
            i(1),
            t({ "", "}", "" }),
        }),
    })

    ls.add_snippets("all", {
        s("bad", { t({ "😹👎" }) }),
        s("ymd", { f(function()
            return os.date("%Y-%m-%d")
        end, {}, {}) }),
    })

    -- ls.add_snippets("tex", {
    --     s("bininf", {
    --         t({ "bininf{", }),
    --         i(1),
    --         t({"}{"}),
    --     }),
    -- })
end

return {
    {
        "L3MON4D3/LuaSnip",
        dependencies = {
            "rafamadriz/friendly-snippets",
        },
        config = config,
    },
}
