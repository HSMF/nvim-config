-- require("lspconfig").sqls.setup({
--     on_attach = function(client, bufnr)
--         client.server_capabilities.document_formatting = false
--         require("hyde.lsp.handlers").on_attach(client, bufnr)
--         require("sqls").on_attach(client, bufnr)
--     end,
-- })
