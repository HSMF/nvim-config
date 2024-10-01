vim.api.nvim_create_user_command("Wrap", function()
    vim.opt_local.wrap = true
    vim.opt_local.breakindent = true
    vim.opt_local.linebreak = true
end, {})

vim.api.nvim_create_user_command("NoWrap", function()
    vim.opt_local.wrap = false
    vim.opt_local.breakindent = false
    vim.opt_local.linebreak = false
end, {})
