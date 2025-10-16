return {
    {
        "mfussenegger/nvim-dap",
        config = function()
            local dap = require("dap")
            dap.adapters.coreclr = {
                type = "executable",
                command = "netcoredbg",
                args = { "--interpreter=vscode" },
            }

            dap.configurations.cs = {
                {
                    type = "coreclr",
                    name = "launch - netcoredbg",
                    request = "attach",
                    console = "integratedTerminal",
                    processId = function()
                        return vim.fn.input("Enter process ID: ")
                    end,
                    -- program = function()
                    --     return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/net9.0", "file")
                    -- end,
                },
            }
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        opts = {},
        { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
    },
}
