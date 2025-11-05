-- require("lspconfig").basedpyright.setup({
--     settings = {
--         -- venvPath = "/home/hyde/.local/share/py-venv/",
--         venvPath = "/home/hyde/Documents/programming/earley/earley-rs/",
--         -- venvPath = "/var/folders/vp/rn8vfv3958z7w097l0qc9dcw0000gn/T/tmp.43OB1kQP/homework-1p-beras-NancyZhu15/",
--         venv = ".env",
--     },
-- })
vim.lsp.config("pyrefly", {
    settings = {
        displayTypeErrors = "force-on"
    }
})
vim.lsp.enable("pyrefly")
