local M = {}

local icons = require("hyde.tools.icons")
local configs0 = require("hyde.lsp.configs")
local set_config = configs0.set_config
local configs = configs0.configs

local contains = function(tbl, el)
    for _, value in pairs(tbl) do
        if value == el then
            return true
        end
    end

    return false
end

function M.new_capabilities()
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
    capabilities.textDocument.colorProvider = {
        dynamicRegistration = true,
    }
    return capabilities
end

M.setup = function()
    local signs = {
        { name = "DiagnosticSignError", text = icons.error },
        { name = "DiagnosticSignWarn", text = icons.warningTriangle },
        { name = "DiagnosticSignHint", text = icons.info },
        { name = "DiagnosticSignInfo", text = icons.questionCircle },
    }
    for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
    end

    local config = {
        virtual_text = true,
        signs = {
            active = signs,
        },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
    }

    vim.diagnostic.config(config)
    vim.o.updatetime = 250

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
    })

    -- vim.cmd([[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]])

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()

    local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if not status_ok then
        return
    end

    M.capabilities = M.new_capabilities()
end

local function lsp_highlight_document(client)
    if client.server_capabilities.document_highlight then
        vim.api.nvim_exec(
            [[
          augroup lsp_document_highlight
            autocmd! * <buffer>
            autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
            autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
          augroup END
        ]],
            false
        )
    end
end

local keymaps = {
    { "<leader>l", group = "LSP" },
    { "<leader>lD", "<cmd>lua require('telescope.builtin').diagnostics()<cr>", desc = "Document diagnostics" },
    { "<leader>lI", "<cmd>LspInstallInfo<cr>", desc = "Installer Info" },
    { "<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace Symbols" },
    { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Action" },
    { "<leader>lf", "<cmd>lua vim.lsp.buf.format({ async = true })<cr>", desc = "Format" },
    { "<leader>lh", "<cmd>lua vim.lsp.buf.hover()<cr>", desc = "hover" },
    { "<leader>li", "<cmd>LspInfo<cr>", desc = "Info" },
    { "<leader>lj", "<cmd>lua vim.diagnostic.goto_next()<CR>", desc = "Next Diagnostic" },
    { "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev()<cr>", desc = "Prev Diagnostic" },
    { "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>", desc = "CodeLens Action" },
    { "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<cr>", desc = "Quickfix" },
    { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename" },
    { "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
    { "<leader>lw", "<cmd>Telescope lsp_workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
    { "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>" },

    { "gd", "<cmd>lua vim.lsp.buf.definition()<CR>" },
    { "K", "<cmd>lua vim.lsp.buf.hover()<CR>" },
    { "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>" },
    { "gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>" },
    { "gr", "<cmd>Telescope lsp_references<CR>" },
    { "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>' },
    { "gl", "<cmd>lua vim.diagnostic.open_float()<CR>" },
    { "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>' },
    { "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>" },
}

for _, v in ipairs(keymaps) do
    v.nowait = true
    v.remap = false
end

local function lsp_keymaps(bufnr)
    for _, v in ipairs(keymaps) do
        if type(v[1]) == "string" and type(v[2]) == "string" then
            vim.keymap.set("n", v[1], v[2], { silent = true, buffer = bufnr })
        end
    end
    -- for _, v in ipairs(keymaps) do
    --     v.buffer = bufnr
    -- end
    -- require("which-key").add(keymaps)
    vim.cmd([[ command! Format execute 'lua vim.lsp.buf.format({async = true})' ]])
end

M.go_org_imports = function(wait_ms)
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
    for cid, res in pairs(result or {}) do
        for _, r in pairs(res.result or {}) do
            if r.edit then
                local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                vim.lsp.util.apply_workspace_edit(r.edit, enc)
            end
        end
    end
end

M.on_attach = function(client, bufnr)
    if client.name == "ts_ls" then
        client.server_capabilities.document_formatting = false
    end

    if client.name == "rust-analyzer" then
        vim.cmd([[
            autocmd BufEnter,BufWinEnter *.rs :RustSetInlayHints
        ]])
    end

    if client.name == "gopls" then
        vim.cmd([[
            " autocmd BufWritePre *.go lua require("hyde.lsp.handlers").go_org_imports()
        ]])
    end

    local formatting_disabled = {
        "jsonls",
        "ts_ls",
        "svelte",
    }

    if contains(formatting_disabled, client.name) then
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
    end

    if client.name == "biome" then
        client.server_capabilities.documentFormattingProvider = true
        client.server_capabilities.documentRangeFormattingProvider = true
    end

    local client_config = configs[client.name]
    set_config(client_config)

    if client.name == "ocamllsp" then
        -- require("which-key").register({
        --     l = {
        --         u = {
        --             t = {
        --                 require("ocaml.actions").update_interface_type,
        --                 "Ocaml Update Type",
        --             },
        --         },
        --     },
        -- }, {
        --     mode = "n",
        --     prefix = "<leader>",
        --     buf = bufnr,
        --     silent = true, -- use `silent` when creating keymaps
        --     noremap = true, -- use `noremap` when creating keymaps
        --     nowait = true, -- use `nowait` when creating keymaps
        -- })
    end

    if client.resolved_capabilities and client.resolved_capabilities.code_lens then
        local codelens = vim.api.nvim_create_augroup("LSPCodeLens", { clear = true })
        vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "CursorHold" }, {
            group = codelens,
            callback = function()
                vim.lsp.codelens.refresh()
            end,
            buffer = bufnr,
        })
    end

    lsp_keymaps(bufnr)
    lsp_highlight_document(client)
end

M.capabilities = nil

return M
