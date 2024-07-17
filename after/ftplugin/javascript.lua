vim.api.nvim_set_keymap("i", "$", "", {
    nowait = true,
    noremap = true,
    callback = function()
        require("autotemplate").autotemplate(vim.bo.filetype)
    end,
})
