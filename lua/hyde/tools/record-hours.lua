local M = {}
local next_emit = 0
local interval = 2

local projects = {}

local function on_key()
    local now = os.time()

    if now > next_emit then
        local cwd = vim.fn.getcwd()
        if string.find(cwd, "fokus") == nil then return end

        next_emit = now + interval

        local file = (os.getenv("HOME") or vim.uv.os_homedir()) .. "/.local/share/hours.log.json"

        local args = { "record-hours", "--file", file, "record" }
        if projects[cwd] ~= nil then
            args[#args + 1] = "--sub-project"
            args[#args + 1] = projects[cwd]
        end

        vim.system(args)
    end
end

function M.register()
    vim.on_key(on_key, 0)
end

function M.add_project(path, project)
    projects[path] = project
end

return M
