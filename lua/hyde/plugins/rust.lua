return {
    "arindas/rust-tools.nvim",
    "qnighy/lalrpop.vim",
    { "https://git.sr.ht/~p00f/godbolt.nvim", name = "godbolt.nvim" },
    {
        "saecki/crates.nvim",
        tag = "v0.3.0",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("crates").setup()
        end,
        lazy = true,
    },
    "pest-parser/pest.vim",
}
