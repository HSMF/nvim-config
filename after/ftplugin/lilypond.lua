local group = vim.api.nvim_create_augroup("LilyPond", {
    clear = true,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    buffer = vim.api.nvim_get_current_buf(),
    group = group,
    command = ":silent LilyCmp",
})
