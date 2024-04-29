local function config()
    vim.g.vimtex_view_method = require("hyde.util").get_vars().latex_viewer
end

return { {
    "lervag/vimtex",
    config = config,
} }
