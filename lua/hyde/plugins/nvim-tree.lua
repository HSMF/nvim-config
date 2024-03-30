local nvim_tree_icons = {
    default = "",
    symlink = "",
    git = {
        unstaged = "",
        staged = "ᛊ",
        -- staged = "S",
        unmerged = "",
        renamed = "➜",
        deleted = "",
        untracked = "ᚧ",
        -- untracked = "U",
        ignored = "◌",
    },
    folder = {
        default = "",
        open = "",
        empty = "",
        empty_open = "",
        symlink = "",
    },
}

return {
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            local nvim_tree = require("nvim-tree")
            local nvim_tree_config = require("nvim-tree.api").config

            local tree_cb = nvim_tree_config.nvim_tree_callback

            local function open_nvim_tree(data)
                -- buffer is a directory
                local directory = vim.fn.isdirectory(data.file) == 1

                if not directory then
                    return
                end

                -- change to the directory
                vim.cmd.cd(data.file)

                -- open the tree
                require("nvim-tree.api").tree.open()
            end
            vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

            nvim_tree.setup({
                hijack_netrw = true,
                disable_netrw = true,
                -- ignore_ft_on_setup = {
                --     "startify",
                --     "dashboard",
                --     "alpha",
                -- },
                open_on_tab = false,
                hijack_cursor = false,
                update_cwd = true,
                -- update_to_buf_dir = {
                --     enable = true,
                --     auto_open = true,
                -- },
                diagnostics = {
                    enable = true,
                    icons = {
                        hint = "",
                        info = "",
                        warning = "",
                        error = "",
                    },
                },
                update_focused_file = {
                    enable = true,
                    update_cwd = true,
                    ignore_list = {},
                },
                system_open = {
                    cmd = "open", -- open(1) on macOS
                    args = {},
                },
                renderer = {
                    icons = {
                        glyphs = nvim_tree_icons,
                    },
                },
                filters = {
                    dotfiles = false,
                    custom = {},
                },
                git = {
                    enable = false, -- i think this hides ignored dirs
                    ignore = false,
                    timeout = 500,
                },
                view = {
                    width = 30,
                    --[[ height = 30, ]]
                    side = "left",
                    -- auto_resize = true,
                    -- https://github.com/nvim-tree/nvim-tree.lua/wiki/Migrating-To-on_attach
                    -- mappings = {
                    -- custom_only = false,
                    -- list = {
                    --     { key = { "l", "<CR>", "o" }, cb = tree_cb("edit") },
                    --     { key = "h",                  cb = tree_cb("close_node") },
                    --     { key = "v",                  cb = tree_cb("vsplit") },
                    -- },
                    -- },
                    number = false,
                    relativenumber = false,
                },
                trash = {
                    cmd = "trash",
                    require_confirm = true,
                },
                actions = {
                    open_file = {
                        resize_window = true,
                        quit_on_open = true,
                    },
                },
            })
        end,
    },
}
