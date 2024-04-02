require("lspconfig").jdtls.setup({
    on_attach = require("hyde.lsp.handlers").on_attach,
    capabilities = require("hyde.lsp.handlers").capabilities,
})
