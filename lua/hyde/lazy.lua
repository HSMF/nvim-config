
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local my_plugins = {
    "nvim-lua/popup.nvim",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "norcalli/nvim_utils",
    "nvim-tree/nvim-web-devicons",
    "nvim-tree/nvim-tree.lua",
    "akinsho/bufferline.nvim",
    "Aasim-A/scrollEOF.nvim",
}
-- local plugins = load_all()

-- for _, value in ipairs(my_plugins) do
--     plugins[#plugins + 1] = value
-- end

local opts = {}

require("lazy").setup("hyde.plugins", opts)
