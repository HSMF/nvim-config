local pid = vim.fn.getpid()

local omnisharp_choices = {
    vim.fn.stdpath("data") .. "/mason/bin/OmniSharp",
    vim.fn.expand("~") .. "/opt/omnisharp/OmniSharp",
}

local omnisharp_bin
for _, choice in ipairs(omnisharp_choices) do
    if vim.fn.filereadable(choice) == 1 then
        omnisharp_bin = choice
        break
    end
end

if omnisharp_bin == nil then
    vim.notify("OmniSharp not installed", vim.log.levels.WARN)
    return
end

vim.lsp.config("omnisharp", {
    cmd = { omnisharp_bin, "--languageserver", "--hostPID", tostring(pid) },
    on_attach = require("hyde.lsp.handlers").on_attach
})
vim.lsp.enable("omnisharp")
