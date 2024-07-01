local lspconfig = require("lspconfig")
local util = require("lspconfig.util")
local ok, ts_utils = pcall(require, "nvim-lsp-ts-utils")
if not ok then
    return
end

local capabilities = require("hyde.lsp.handlers").capabilities

-- needs tsconfig.json
--       .eslintrc.json
--       .prettierrc.json

--[[ local buf_map = function(bufnr, mode, lhs, rhs, opts) ]]
--[[ 	vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts or { silent = true }) ]]
--[[ end ]]

local on_attach = function(client, bufnr)
    local options = {
        tabstop = 2,
        shiftwidth = 2,
        softtabstop = 2,
    }

    for k, v in pairs(options) do
        vim.opt[k] = v
    end

    require("hyde.lsp.handlers").on_attach(client, bufnr)
end

-- require("lspconfig").tsserver.setup({
--     -- settings = {
--     --     documentFormatting = true
--     -- }
-- })

-- require("typescript-tools").setup({
--     on_attach = function(client, bufnr)
--         print("attaching")
--         -- if vim.bo[bufnr].filetype ~= "svelte" then
--         --     client.server_capabilities.document_formatting = false
--         --     client.server_capabilities.document_range_formatting = false
--         -- end
--         ts_utils.setup({})
--         ts_utils.setup_client(client)
--         on_attach(client, bufnr)
--     end,
--     capabilities = capabilities,
--     settings = {
--         expose_as_code_action = "all",
--         tsserver_format_options = {},
--         complete_function_calls = false,
--     },
-- })

lspconfig.tsserver.setup({
    init_options = ts_utils.init_options,
    on_attach = function(client, bufnr)
        -- if vim.bo[bufnr].filetype ~= "svelte" and vim.bo[bufnr].filetype ~= "typescript" then
        --     client.server_capabilities.document_formatting = false
        --     client.server_capabilities.document_range_formatting = false
        -- end
        ts_utils.setup({})
        ts_utils.setup_client(client)

        -- buf_map(bufnr, "n", "<leader>do", ":NodeInspectRun<CR>")
        --       buf_map(bufnr, "n", "<leader>dq", ":NodeInspectStop<CR>")
        -- buf_map(bufnr, "n", "<leader>dl", ":NodeInspectStepInto<CR>")
        -- buf_map(bufnr, "n", "<leader>dj", ":NodeInspectStepOver<CR>")
        -- buf_map(bufnr, "n", "<leader>dk", ":NodeInspectStepOut<CR>")
        -- buf_map(bufnr, "n", "<leader>db", ":NodeInspectToggleBreakpoint<CR>")
        -- auto formatting
        on_attach(client, bufnr)
    end,
    root_dir = util.root_pattern(
        ".eslintrc",
        ".eslintrc.js",
        ".eslintrc.cjs",
        ".eslintrc.yaml",
        ".eslintrc.yml",
        ".eslintrc.json"
    ),
})

-- lspconfig.emmet_ls.setup({
--     on_attach = function(client, bufnr)
--         client.server_capabilities.document_formatting = false
--         client.server_capabilities.document_range_formatting = false
--         on_attach(client, bufnr)
--     end,
--     capabilities = capabilities,
-- })

lspconfig.svelte.setup({
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)
    end,
    settings = {
        svelte = {
            plugin = {
                svelte = {
                    format = {
                        enable = true,
                    },
                },
            },
        },
    },
    capabilities = capabilities,
})

lspconfig.tailwindcss.setup({
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)
    end,
    settings = {
        tailwindCSS = {
            suggestions = true,
        },
    },
    capabilities = capabilities,
})

lspconfig.eslint.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

-- lspconfig.biome.setup({
--     on_attach = function(client, bufnr)
--         on_attach(client, bufnr)
--     end,
--     filetypes = {
--         "javascript",
--         "javascriptreact",
--         "json",
--         "jsonc",
--         "typescript",
--         "typescript.tsx",
--         "typescriptreact",
--         -- , "svelte"
--     },
-- })
