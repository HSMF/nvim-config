local M = {}

function M.require(path) end

function M.get_vars()
    local config_dir = vim.api.nvim_list_runtime_paths()[1]
    local path = config_dir .. "/lua/hyde/vars.lua"
    if vim.fn.filereadable(path) ~= 0 then
        return require("hyde.vars")
    end

    local file = io.open(path, "w")
    if file == nil then
        return {}
    end

    file:write([[
return {
    auto_format = false,
    latex_viewer = "zathura",
}]])
    file:close()

    return require("hyde.vars")
end

return M
