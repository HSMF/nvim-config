require("lspconfig").sqls.setup({
    on_attach = function(client, bufnr)
        require("hyde.lsp.handlers").on_attach(client, bufnr)
        require("sqls").on_attach(client, bufnr)
    end,
})
