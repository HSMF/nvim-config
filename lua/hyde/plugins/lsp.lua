return {
    {
        "neovim/nvim-lspconfig",
        config = function()
            require("hyde.lsp").setup()
        end,
    },
    {
        "folke/neodev.nvim",
        opts = {},
    },
    {
        "pmizio/typescript-tools.nvim",
        requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    },
    {
        "mrcjkb/haskell-tools.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim", -- optional
        },
        version = "^5",
        lazy = false,
    },
    "nvim-lua/lsp_extensions.nvim",
    "nvimtools/none-ls.nvim",
    "mlr-msft/vim-loves-dafny",

    { "nanotee/sqls.nvim", lazy = true, ft = "sql" },

    "jose-elias-alvarez/nvim-lsp-ts-utils",

    {
        "mfussenegger/nvim-jdtls",
    },
}
