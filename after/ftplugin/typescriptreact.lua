vim.api.nvim_set_keymap("i", "$", "", {
    nowait = true,
    noremap = true,
    callback = function()
        require("hyde.tools.autotemplate").autotemplate("tsx")
    end,
})
