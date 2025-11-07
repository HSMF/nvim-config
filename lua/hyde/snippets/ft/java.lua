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
    s("logger", {
        t("private static final Logger logger = LogManager.getLogger("),
        f(function()
            local bufname = vim.api.nvim_buf_get_name(0)
            local match = string.match(bufname, "([^/]*)%.java$")
            if match == nil then
                return ""
            end

            return match
        end, {}, {}),
        t(".class);"),
    }),
}
