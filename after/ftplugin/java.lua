local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/")
local jdtls = require("jdtls")

local capabilities = require("hyde.lsp.handlers").new_capabilities()
local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

-- Setup Workspace
local home = os.getenv("HOME")
local workspace_path = home .. "/.local/share/jdtls-workspace/"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = workspace_path .. project_name

-- Determine OS
local os_config = "linux"
if vim.fn.has("mac") == 1 then
    os_config = "mac"
end

local bundles = {}
vim.list_extend(bundles, vim.split(vim.fn.glob(mason_path .. "packages/java-test/extension/server/*.jar"), "\n"))
vim.list_extend(
    bundles,
    vim.split(
        vim.fn.glob(mason_path .. "packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"),
        "\n"
    )
)

local config = {
    -- The command that starts the language server
    -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
    cmd = {

        -- 💀
        "java", -- or '/path/to/java17_or_newer/bin/java'
        -- depends on if `java` is in your $PATH env variable and if it points to the right version.

        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xmx1g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",

        -- 💀
        "-jar",
        vim.fn.glob(home .. "/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),

        -- 💀
        "-configuration",
        home .. "/.local/share/nvim/mason/packages/jdtls/config_" .. os_config,
        -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
        -- Must point to the                      Change to one of `linux`, `win` or `mac`
        -- eclipse.jdt.ls installation            Depending on your system.

        -- 💀
        -- See `data directory configuration` section in the README
        "-data",
        workspace_dir,
    },

    -- 💀
    -- This is the default if not provided, you can remove it. Or adjust as needed.
    -- One dedicated LSP server & client will be started per unique root_dir
    root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),

    -- Here you can configure eclipse.jdt.ls specific settings
    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    -- for a list of options
    settings = {
        java = {
            format = {
                enabled = false,
            },
        },
    },

    -- Language server `initializationOptions`
    -- You need to extend the `bundles` with paths to jar files
    -- if you want to use additional eclipse.jdt.ls plugins.
    --
    -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
    --
    -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
    init_options = {
        bundles = {},
    },
}

config["on_attach"] = function(client, bufnr)
    local _, _ = pcall(vim.lsp.codelens.refresh)
    require("jdtls").setup_dap({ hotcodereplace = "auto" })
    require("hyde.lsp.handlers").on_attach(client, bufnr)
    local status_ok, jdtls_dap = pcall(require, "jdtls.dap")
    if status_ok then
        jdtls_dap.setup_dap_main_class_configs()
    end
end

local config = {
    -- cmd = { mason_path .. "/bin/jdtls" },
    cmd = { "jdtls" },
    settings = {
        java = {
            format = {
                enabled = false,
            },
        },
    },
    on_attach = require("hyde.lsp.handlers").on_attach,
    root_dir = "/fxxxx/java", -- vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]),
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    pattern = { "*.java" },
    callback = function()
        local _, _ = pcall(vim.lsp.codelens.refresh)
    end,
})

vim.keymap.set({ "v" }, "<leader>m", "<cmd>'<,'>lua require('jdtls').extract_method(true)<cr>")

local function file_exists(path)
    local stat = vim.loop.fs_stat(path)
    return stat and stat.type == "file"
end

vim.api.nvim_buf_create_user_command(0, "GoToTest", function()
    local filename = vim.fn.expand("%")
    local dir = vim.fn.fnamemodify(filename, ":h")
    local file = vim.fn.fnamemodify(filename, ":t")

    local newfilename = filename
    if dir:match("/main/") ~= nil then
        dir = dir:gsub("/main/", "/test/")

        if file_exists(dir .. "/" .. vim.fn.fnamemodify(file, ":r") .. ".java") then
            newfilename = dir .. "/" .. vim.fn.fnamemodify(file, ":r") .. ".java"
        else
            newfilename = dir .. "/Test" .. file
        end
    else
        dir = dir:gsub("/test/", "/main/")
        local newfile = file:gsub("^Test", ""):gsub("Test.java$", ".java")
        newfilename = dir .. "/" .. newfile

        if not file_exists(newfilename) then
            newfilename = vim.fn.fnamemodify(newfilename, ":h")
        end
    end
    vim.cmd.edit({ args = { newfilename } })
end, {})

vim.api.nvim_buf_create_user_command(0, "RefactorBuilder", function()
    require("java-builder").create_builder()
end, {})

require("jdtls").start_or_attach(config)
