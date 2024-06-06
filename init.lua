require("hyde.options")
require("hyde.lazy")
require("hyde.autocmd")

require("hyde.tools")

local after_conf = require("hyde.util").get_vars().after_conf
if after_conf ~= nil then
    after_conf()
end
