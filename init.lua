require("hyde.options")
require("hyde.lazy")
require("hyde.autocmd")
require("hyde.commands")

require("hyde.tools")

local after_conf = require("hyde.util").get_vars().after_conf
if after_conf ~= nil then
    after_conf()
end

vim.filetype.add({
    extension = {
        gobra = "gobra",
        ll = "llvm",
    },
})
vim.treesitter.language.register("gobra", { "gobra" })
-- vim.treesitter.language.add(
--     "gobra",
--     { path = vim.uv.os_homedir() .. "/.config/nvim/parsers/gobra.so", filetype = "gobra" }
-- )
