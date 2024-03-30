return {
    {
        "catppuccin/nvim",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "macchiato", -- mocha, macchiato, frappe, latte
            })
            vim.api.nvim_command("colorscheme catppuccin")
        end,
    }
}
