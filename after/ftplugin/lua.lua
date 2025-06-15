local ts_utils = require("nvim-treesitter.ts_utils")
local string_context = vim.treesitter.query.parse(
    "lua",
    [[
    (string) @string_outer
]]
)

require("nvim-surround").buffer_setup({
    surrounds = {
        ["]"] = {
            add = function()
                local cursor_node = ts_utils.get_node_at_cursor()
                local string_node = require("hyde.util").filter_treesitter_parent(cursor_node, function(v)
                    return v:type() == "string"
                end)
                if string_node == nil then
                    return { { "[" }, { "]" } }
                end

                for _, node in string_context:iter_captures(string_node, 0) do
                    local text = vim.treesitter.get_node_text(node, 0)
                    local quote_char = string.sub(text, 1, 1)
                    if quote_char == "'" or quote_char == '"' then
                        return { { "[[" }, { "]]" } }
                    end
                end
                return { { "[" }, { "]" } }
            end,
        },
    },
})

require("hyde.lsp").load_server("lua")
