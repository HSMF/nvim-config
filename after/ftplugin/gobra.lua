local extends = vim.fn.stdpath("config") .. "/after/ftplugin/go.lua"
dofile(extends)

vim.opt_local.commentstring = "// %s"

local client

function start_lsp()
    if client ~= nil then
        vim.lsp.stop_client(client, false)
    end

    client = vim.lsp.start({
        name = "gobrapls",
        cmd = {
            "/home/hyde/projects/gobrapls/target/debug/gobrapls",
            "--java",
            "/usr/lib/jvm/java-11-openjdk/bin/java",
            -- "echo",
            "--gobra",
            "/home/hyde/opt/gobra2/target/scala-2.13/gobra.jar",
        },

        -- Set the "root directory" to the parent directory of the file in the
        -- current buffer (`ev.buf`) that contains either a "setup.py" or a
        -- "pyproject.toml" file. Files that share a root directory will reuse
        -- the connection to the same LSP server.
        root_dir = vim.fs.root(0, { ".git", "go.mod" }),
    })
end

start_lsp()

vim.api.nvim_buf_create_user_command(0, "GobraRestart", function()
    start_lsp()
end, { range = false })
