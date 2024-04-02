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
    "clangd",
    "dockerls",
    "docker_compose_language_service",
    "intelephense",
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
    local nvim_lspconfig = require("lspconfig")
    local global_capabilities = vim.lsp.protocol.make_client_capabilities()
    global_capabilities.textDocument.completion.completionItem.snippetSupport = true
    nvim_lspconfig.util.default_config = vim.tbl_extend("force", nvim_lspconfig.util.default_config, {
        capabilities = global_capabilities,
    })
    vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        float = { border = "single" },
    })
    local handlers = require("hyde.lsp.handlers")
    handlers.setup()
    load_all()
    require("hyde.lsp.null")

    for _, server in ipairs(quick_list_enabled_servers) do
        nvim_lspconfig[server].setup({ on_attach = handlers.on_attach, capabilities = handlers.capabilities })
    end
end

return M
