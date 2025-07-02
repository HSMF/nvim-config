require("lspconfig").tinymist.setup({
    on_attach = require("hyde.lsp.handlers").on_attach,
    capabilities = require("hyde.lsp.handlers").capabilities,
    settings = {
        formatterMode = "typstyle",
    },
})
