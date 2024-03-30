local function config()
    vim.g.vimtex_view_method = require("hyde.vars").latex_viewer
end

return { {
    "lervag/vimtex",
    config = config,
} }
