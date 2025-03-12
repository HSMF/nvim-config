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
        after = "which-key",
        config = function()
            local wk = require("which-key")
            wk.add({
                {
                    "<leader>m",
                    function()
                        require("grapple").toggle()
                    end,
                },
                { "<leader>M", require("grapple").toggle_tags },
            })
        end,
    },
}
