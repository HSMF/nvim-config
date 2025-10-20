return {
    {
        "mfussenegger/nvim-dap",
        config = function()
            local dap = require("dap")
            dap.adapters.coreclr = {
                type = "executable",
                command = vim.fn.exepath("netcoredbg"),
                args = { "--interpreter=vscode" },
                options = {
                    detached = false,
                }
            }

            dap.configurations.cs = {
                {
                    type = "coreclr",
                    name = "attach - netcoredbg",
                    request = "attach",
                    console = "integratedTerminal",
                    processId = function()
                        return vim.fn.input("Enter process ID: ")
                    end,
                    -- program = function()
                    --     return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/net9.0", "file")
                    -- end,
                },
                {
                    type = "coreclr",
                    name = "launch",
                    request = "launch",
                    program = function()
                        local suggestion = vim.g.last_dll
                        if suggestion == nil then
                            suggestion = vim.fn.getcwd() .. '/bin/Debug/'
                        end
                        local ret = vim.fn.input('Path to dll: ', suggestion, 'file')
                        if ret then
                            vim.g.last_dll = ret
                        end
                        return ret
                    end
                }
            }
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        opts = {},
        { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
    },
}
