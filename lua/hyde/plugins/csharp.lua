return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter"
        },
        after = "nsidorenco/neotest-vstest",
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-vstest")
                }
            })
        end

    },
    {
        "nsidorenco/neotest-vstest"
    },
    {
        "MoaidHathot/dotnet.nvim",
        cmd = "DotnetUI",
        opts = {},
    },
    { "Hoffs/omnisharp-extended-lsp.nvim" },
    {
        "GustavEikaas/easy-dotnet.nvim",
        dependencies = { "nvim-lua/plenary.nvim", 'nvim-telescope/telescope.nvim', },
        config = function()
            require("easy-dotnet").setup()
        end
    }
    -- {
    --     "iabdelkareem/csharp.nvim",
    --     dependencies = {
    --         "williamboman/mason.nvim", -- Required, automatically installs omnisharp
    --         "mfussenegger/nvim-dap",
    --         "Tastyep/structlog.nvim", -- Optional, but highly recommended for debugging
    --     },
    --     config = function()
    --         require("mason").setup() -- Mason setup must run before csharp, only if you want to use omnisharp
    --         print("what")
    --         require("csharp").setup()
    --     end,
    -- },
}
