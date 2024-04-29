vim.opt.expandtab = false
vim.cmd([[setlocal wrap linebreak]])
vim.cmd([[setlocal breakindent]])

local function map(mode, pat, to)
    vim.api.nvim_set_keymap(mode, pat, to, { noremap = true, silent = true })
end
