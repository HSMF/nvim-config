local function config()
    local configs = require("nvim-treesitter.configs")

    require("treesitter-context").setup({ enable = true, max_lines = 1 })

    require("ts_context_commentstring").setup({})
    vim.g.skip_ts_context_commentstring_module = true

    configs.setup({
        ensure_installed = "all",
        sync_install = false,
        ignore_install = { "latex" },
        autopairs = {
            enable = true,
        },
        autotags = {
            enable = true,
        },
        highlight = {
            enable = true,
            disable = { "org", "latex" },                           -- Remove this to use TS highlighter for some of the highlights (Experimental)
            additional_vim_regex_highlighting = { "org" }, -- Required since TS highlighter doesn't support all syntax features (conceal)
        },
        indent = { enable = true, disable = { "yaml" } },
        -- context_commentstring = {
        --     enable = true,
        --     enable_autocmd = false,
        -- },
        -- rainbow = {
        --     enable = true,
        --     extended_mode = true,
        -- },
        textobjects = {
            select = {
                enable = true,
                lookahead = true,
                keymaps = {
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    -- You can optionally set descriptions to the mappings (used in the desc parameter of
                    -- nvim_buf_set_keymap) which plugins like which-key display
                    ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                    -- You can also use captures from other query groups like `locals.scm`
                    ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
                    ["ib"] = { query = "@block.inner", desc = "inner block" },
                    ["ab"] = { query = "@block.outer", desc = "outer block" },
                    ["aS"] = { query = "@statement.outer", desc = "outer statement" },
                    ["aa"] = "@parameter.outer",
                    ["ia"] = "@parameter.inner",
                },
            },
        },
    })

    -- This module contains a number of default definitions
    local rainbow_delimiters = require("rainbow-delimiters")
    require("rainbow-delimiters.setup").setup({
        strategy = {
            [""] = rainbow_delimiters.strategy["global"],
            vim = rainbow_delimiters.strategy["local"],
        },
        query = {
            [""] = "rainbow-delimiters",
            lua = "rainbow-blocks",
        },
        highlight = {
            "RainbowDelimiterRed",
            "RainbowDelimiterYellow",
            "RainbowDelimiterBlue",
            "RainbowDelimiterOrange",
            "RainbowDelimiterGreen",
            "RainbowDelimiterViolet",
            "RainbowDelimiterCyan",
        },
        priority = {
            [""] = 110,
            lua = 210,
        },
    })
end

return {
    {
        "nvim-treesitter/nvim-treesitter",
        config = config,
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

}
