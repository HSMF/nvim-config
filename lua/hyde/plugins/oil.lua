local detail = false

return {
    {
        "stevearc/oil.nvim",
        opts = {
      skip_confirm_for_simple_edits = true,
            keymaps = {
                ["ga"] = {
                    desc = "git add",
                    callback = function()
                        local entry = require("oil").get_cursor_entry()
                        if entry == nil then
                            return
                        end
                        print(vim.inspect(entry))
                    end,
                },
                ["gd"] = {
                    desc = "Toggle file detail view",
                    callback = function()
                        detail = not detail
                        if detail then
                            require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
                        else
                            require("oil").set_columns({ "icon" })
                        end
                    end,
                },
            },
            view_options = {
                show_hidden = true,
            },
        },
        -- Optional dependencies
        -- dependencies = { { "echasnovski/mini.icons", opts = {} } },
        dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
    },
}
