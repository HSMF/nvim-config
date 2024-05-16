local default_ibl = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}

local funky_ibl = {
    "Comment",
}

return {
    {
        "folke/zen-mode.nvim",
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
            on_open = function()
                require("ibl").update({ indent = { highlight = funky_ibl } })
            end,
            on_close = function()
                require("ibl").update({ indent = { highlight = default_ibl } })
            end,
        },
    },
    {
        "folke/twilight.nvim",
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
    },
}
