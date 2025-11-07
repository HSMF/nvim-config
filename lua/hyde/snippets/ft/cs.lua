local ls = require("luasnip")
local shared = require("hyde.snippets")
local util = require("hyde.util")
local filter_treesitter_parent = require("hyde.util").filter_treesitter_parent

local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local fmta = require("luasnip.extras.fmt").fmta

---@return TSNode|nil
local function first_field(node, field)
    if node == nil then
        return nil
    end
    local fi = node:field(field)
    if fi == nil then
        return nil
    end
    return fi[1]
end

---@return TSNode|nil
local function get_surrounding_class_node()
    local cursor_node = util.get_node_at_cursor()
    return filter_treesitter_parent(cursor_node, function(v)
        return v:type() == "class_declaration"
    end)
end

local function gettype()
    local class_declaration = get_surrounding_class_node()
    if class_declaration == nil then
        return "void"
    end
    local name = first_field(class_declaration, "name")
    if name == nil then
        return "void"
    end
    return vim.treesitter.get_node_text(name, 0)
end

local QUERY = nil
---@return vim.treesitter.Query
local function get_query()
    if QUERY ~= nil then
        return QUERY
    end
    QUERY = vim.treesitter.query.parse(
        vim.treesitter.language.get_lang("cs"),
        [[(field_declaration
            (variable_declaration
              (variable_declarator
                name: (identifier) @name)))]]
    )
    return QUERY
end

local function get_field_name()
    local class_declaration = get_surrounding_class_node()
    local body = first_field(class_declaration, "body")
    if body == nil then
        return "inner"
    end

    local query = get_query()

    for _, node, _ in query:iter_captures(body, 0) do
        local name = vim.treesitter.get_node_text(node, 0)
        if name ~= "package" then
            return name
        end
    end
    return "inner"
end

return {
    s(
        "field",
        fmta(
            [[
/**
 * <<returns>>itself<</returns>>
 */
public <> Set<>(<> value)
{
	<>.<> = value;
	return this;
}
]],
            {
                f(gettype, {}, {}),
                i(1),
                i(3, "string"),
                d(2, function()
                    return sn(nil, { i(1, get_field_name()) })
                end, { 1 }),
                d(4, function(args)
                    return sn(nil, { i(1, args[1]) })
                end, { 1 }),
            }
        )
    ),
    s(
        "archivische",
        fmta(
            [[
/**
 * <<returns>>itself<</returns>>
 */
public <> AddArchivischeNotiz(string description, DateTime date, string author)
{
    <>.ArchivischeNotiz.Add(new ArchivischeNotiz()
    {
        Id = package.idGenerator.NextId(),
        NotizBeschreibung = description,
        NotizDatum = date.ToHistorischerZeitpunkt().Datum,
        NotizErfasser = author
    });
    return this;
}
        ]],
            {
                f(gettype, {}, {}),
                f(get_field_name, {}, {}),
            }
        )
    ),
}
