require("cmp").setup.buffer({
    sources = require("cmp").config.sources({ { name = "conventionalcommits" } }, { { name = "buffer" } }),
})

vim.bo.textwidth = 72
vim.wo.colorcolumn = "+0"
