
vim.fn.setreg("n", [[s/\s*\([^,]\+\),\?/useEffect(() => console.log("\1:", \1), [\1]);/]])

require("hyde.lsp").load_server("typescript")
