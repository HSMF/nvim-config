local M = {}

local nvim_lspconfig = require("lspconfig")
local handlers = require("hyde.lsp.handlers")

M.make_impl = function(target, iface)
    print(target, iface)
    if target == nil or target == "" or iface == nil or iface == "" then
        return
    end
    local file = vim.fn.expand("%")
    local result = vim.fn.systemlist("impl -dir $(dirname " .. file .. ") 'self " .. target .. "' '" .. iface .. "'")
    --[[ local r,_ = unpack(vim.api.nvim_win_get_cursor(0)) ]]
    local r = vim.api.nvim_buf_line_count(0)

    vim.fn.append(r, result)
    --[[ for _, v in pairs(result) do ]]
    --[[ end ]]
end

M.impl = function()
    local target = vim.fn.expand("<cword>")

    vim.ui.input({ prompt = "enter interface name: " }, function(input)
        M.make_impl(target, input)
    end)
end

nvim_lspconfig.gopls.setup({
    on_attach = function(client, bufnr)
        handlers.on_attach(client, bufnr)
    end,
    settings = {
        gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            analyses = {
                unusedparams = true,
            },
        },
    },
})

return M
