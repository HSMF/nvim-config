return {
    "nvim-lua/popup.nvim",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    {
        "folke/noice.nvim",
        event = "VimEnter",
        config = function()
            if vim.g.neovide == nil then
                require("noice").setup({
                    messages = {
                        enabled = false,
                    },
                    notify = {
                        enabled = false,
                    },
                })
            end
        end,
        dependencies = {
            "MunifTanjim/nui.nvim",
            -- "rcarriga/nvim-notify",
        },
    },
    {
        "NvChad/nvim-colorizer.lua",
        opts = {
            user_default_options = {
                tailwind = "lsp",
            },
        },
    },
}
