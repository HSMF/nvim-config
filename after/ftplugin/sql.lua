vim.lsp.start({
    name = "sqruff",
    cmd = {
        "sqruff",
        "lsp",
    },

    root_dir = vim.fs.root(0, { ".git" }),
})
