vim.api.nvim_set_keymap("i", "$", "", {
    nowait = true,
    noremap = true,
    callback = function()
        require("autotemplate").autotemplate("tsx")
    end,
})

require("hyde.lsp").load_server("typescript")
