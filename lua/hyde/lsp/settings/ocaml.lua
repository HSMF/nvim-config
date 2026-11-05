vim.g.no_ocaml_maps = true

vim.lsp.config("ocamllsp", {
    cmd = { "ocamllsp" },
    filetypes = { "ocaml", "ocaml.menhir", "ocaml.interface", "ocaml.ocamllex", "reason", "dune" },
    root_markers = {
        "*.opam",
        "esy.json",
        "package.json",
        ".git",
        "dune-project",
        "dune-workspace"
    },
    on_attach = require("hyde.lsp.handlers").on_attach,
    capabilities = require("hyde.lsp.handlers").capabilities,
})
vim.lsp.enable("ocamllsp")
