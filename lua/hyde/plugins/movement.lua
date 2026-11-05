return {
    {
        "cbochs/portal.nvim",
        -- Optional dependencies
        dependencies = {
            "cbochs/grapple.nvim",
        },
    },
    {

        "cbochs/grapple.nvim",
        config = function()
            vim.keymap.set("n", "<leader>m", function()
                require("grapple").toggle()
            end, { desc = "Grapple toggle" })
            vim.keymap.set("n", "<leader>M", function()
                require("grapple").toggle_tags()
            end, { desc = "Grapple tags" })
        end,
    },
}
