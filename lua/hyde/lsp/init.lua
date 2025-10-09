local M = {}
local quick_list_enabled_servers = {
    "hdl_checker",
    "texlab",
    "jsonls",
    "taplo",
    "zls",
    "bashls",
    "julials",
    "elixirls",
    "dockerls",
    "docker_compose_language_service",
    "intelephense",
    "rescriptls",
    "templ",
    "roc_ls",
    "elmls",
    "clangd",
}

local function load_all()
    local pfile = assert(
        io.popen(
            ("find '%s/nvim/lua/hyde/lsp/settings' -mindepth 1 -maxdepth 1 -print0 -type f"):format(
                vim.env.XDG_CONFIG_HOME or (vim.env.HOME .. "/.config")
            ),
            "r"
        )
    )
    local list = pfile:read("*a")
    pfile:close()

    local tbl = {}

    for filename in list:gmatch("[^%z]+") do
        local file = filename:match("([^/]+).lua$")
        if file ~= "init" then
            tbl[#tbl + 1] = require("hyde.lsp.settings." .. file)
        end
    end
    return tbl
end

function M.setup()
    -- local global_capabilities = vim.lsp.protocol.make_client_capabilities()
    -- global_capabilities.textDocument.completion.completionItem.snippetSupport = true

    vim.lsp.config("*", {
        on_attach = require("hyde.lsp.handlers").on_attach,
        capabilities = require("hyde.lsp.handlers").capabilities,
    })

    vim.lsp.config("*", {
        capabilities = {
            textDocument = {
                completion = {
                    completionItem = {
                        snippetSupport = true
                    }
                }
            }
        }
    })
    vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        float = { border = "single" },
    })
    local handlers = require("hyde.lsp.handlers")
    handlers.setup()

    require("hyde.lsp.settings.omnisharp")
    -- load_all()
    require("hyde.lsp.null")

    for _, server in ipairs(quick_list_enabled_servers) do
        vim.lsp.enable(server)
    end
end

local loaded_servers = {}
function M.load_server(name)
    if loaded_servers[name] ~= nil then
        return
    end

    local ok, _ = pcall(require, "hyde.lsp.settings." .. name)
    if ok then
        loaded_servers[name] = true
        return
    end

    vim.lsp.config(name)
    loaded_servers[name] = true
end

return M
