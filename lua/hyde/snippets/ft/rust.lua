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

local function split(str)
    local lines = {}
    for line in str:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end
    return lines
end

return {
    s("serde_fromstr", {

        t(split([[
impl<'de> Deserialize<'de> for S {
fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
    where D: Deserializer<'de>
    {
        let s = String::deserialize(deserializer)?;
        FromStr::from_str(&s).map_err(de::Error::custom)
    }
}
]])),
    }),
    s(
        "extern-fn",
        fmta(
            [[
#[unsafe(no_mangle)]
pub unsafe extern "C" fn <>(<>) <> {
    <>
}
            ]],
            { i(1, "func"), i(2), i(3), i(0) }
        )
    ),
}
