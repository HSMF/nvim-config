return function()
    local configs = require("nvim-treesitter.configs")

    require("treesitter-context").setup({ enable = true, max_lines = 1 })

    require("ts_context_commentstring").setup({})
    vim.g.skip_ts_context_commentstring_module = true

    configs.setup({
        modules = {},
        auto_install = true,
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "gnn",
                node_incremental = "gnn",
            },
        },
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
            disable = { "org", "latex" }, -- Remove this to use TS highlighter for some of the highlights (Experimental)
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
            lsp_interop = {
                enable = true,
                border = "none",
                floating_preview_opts = {},
                peek_definition_code = {
                    ["<leader>ld"] = "@function.outer",
                    -- ["<leader>l"] = "@class.outer",
                },
            },
            select = {
                enable = true,
                lookahead = true,
                keymaps = {
                    -- function
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    -- scope
                    ["aS"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
                    -- statement
                    ["as"] = { query = "@statement.outer", desc = "outer statement" },
                    -- block
                    ["ib"] = { query = "@block.inner", desc = "inner block" },
                    ["ab"] = { query = "@block.outer", desc = "outer block" },
                    -- parameter
                    ["aa"] = "@parameter.outer",
                    ["ia"] = "@parameter.inner",
                    -- comment
                    ["ac"] = "@comment.outer",
                    ["ic"] = "@comment.inner",
                    -- class
                    ["aC"] = { query = "@class.outer", desc = "Select outer part of a class region" },
                    ["iC"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                    -- function calls
                    ["aF"] = { query = "@call.outer", desc = "Select outer part of a function call" },
                    ["iF"] = { query = "@call.inner", desc = "Select inner part of a function call" },
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
