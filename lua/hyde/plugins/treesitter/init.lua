
return {
    {
        "nvim-treesitter/nvim-treesitter",
        config = require"hyde.plugins.treesitter.nvim-treesitter",
        build = ":TSUpdate",
        dependencies = {
            { url = "https://gitlab.com/HiPhish/rainbow-delimiters.nvim" },
        },
    },
    "nvim-treesitter/playground",
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        after = "nvim-treesitter",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        after = "nvim-treesitter",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },
    "JoosepAlviste/nvim-ts-context-commentstring",

    {
        "wansmer/treesj",
        keys = {
            "<leader>um",
            "<leader>uj",
            "<leader>us",
            dependencies = { "nvim-treesitter/nvim-treesitter" },
            config = function()
                require("treesj").setup({ use_default_keymaps = false })
            end,
        },
    },

    {
        "lukas-reineke/headlines.nvim",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = true, -- or `opts = {}`
    },

    {
        "CKolkey/ts-node-action",
        config = require("hyde.plugins.treesitter.ts-node-action"),
    },
}
