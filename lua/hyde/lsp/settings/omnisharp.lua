local pid = vim.fn.getpid()
local omnisharp_bin = vim.fn.expand("~") .. "/opt/omnisharp/OmniSharp"

return {
    cmd = { omnisharp_bin, "--languageserver", "--hostPID", tostring(pid) },
    on_attach = require("hyde.lsp.handlers").on_attach
}
