-- local handlers = require("hyde.lsp.handlers")
-- local lldb_ext_path = vim.env.HOME .. "/.vscode/extensions/vadimcn.vscode-lldb-1.8.1/"
-- local codelldb_path = lldb_ext_path .. "adapter/codelldb"
-- local liblldb_path = lldb_ext_path .. "lldb/lib/liblldb.dylib"
--
-- local opts = {
--     tools = {
--         autoSetHints = true,
--         -- hover_with_actions = true,
--         runnables = {
--             use_telescope = true,
--         },
--         inlay_hints = {
--             show_parameter_hints = false,
--             only_current_line = false,
--             parameter_hints_prefix = "",
--             other_hints_prefix = "",
--         },
--     },
--     server = {
--         -- on_attach is a callback called when the language server attachs to the buffer
--         on_attach = function(client, bufnr)
--             vim.keymap.set("n", "<C-space>", require("rust-tools").hover_actions.hover_actions, { buffer = bufnr })
--             vim.keymap.set("n", "<leader>º", function()
--                 require("rust-tools").move_item.move_item(true)
--             end, { buffer = bufnr })
--             vim.keymap.set("n", "<leader>∆", function()
--                 require("rust-tools").move_item.move_item(true)
--             end, { buffer = bufnr })
--             vim.keymap.set("n", "<leader>le", function()
--                 require("rust-tools.expand_macro").expand_macro()
--             end, { buffer = bufnr })
--             --[[ vim.keymap.set("n", "K", function() ??? end, { buffer = bufnr }) ]]
--             handlers.on_attach(client, bufnr)
--         end,
--         settings = {
--             -- to enable rust-analyzer settings visit:
--             -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
--             -- https://rust-analyzer.github.io/manual.html#features
--             -- https://rust-analyzer.github.io/manual.html
--             ["rust-analyzer"] = {
--                 -- enable clippy on save
--                 check = { command = "clippy" },
--                 -- check = { command = "check" },
--                 -- checkOnSave = {
--                 --     command = "clippy",
--                 -- },
--                 completion = {
--                     callable = {
--                         snippets = "fill_arguments",
--                     },
--                 },
--             },
--         },
--         capabilities = vim.lsp.protocol.make_client_capabilities(),
--     },
--     dap = {
--         adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
--     },
--     on_attach = require("hyde.lsp.handlers").on_attach
-- }
--
-- require("rust-tools").setup(opts)

local function split_path(path)
    local ret = {}
    for p in string.gmatch(path, "[^.]+") do
        ret[#ret + 1] = p
    end
    return ret
end

local function set_at_path(obj, path, value)
    if #path == 0 then
        return
    end

    for i = 1, #path - 1 do
        local t = obj[path[i]]
        if t == nil then
            t = {}
            obj[path[i]] = t
        end
        obj = t
    end

    obj[path[#path]] = value
end

local function on_init(client)
    local root = vim.fs.root(0, { ".git" })
    if root == nil then
        return
    end
    local file = io.open(root .. "/.vim/coc-settings.json", "r")
    if file == nil then
        return
    end
    local content = file:read("*a")
    file:close()
    local settings = vim.json.decode(content)

    local new_settings = {}

    for path, value in pairs(settings) do
        local split = split_path(path)
        if split[1] == "rust-analyzer" then
            set_at_path(new_settings, split, value)
        end
    end

    client.notify("workspace/didChangeConfiguration", { settings = new_settings })
end

vim.lsp.config("rust_analyzer", {
    on_init = on_init,
    settings = {
        -- to enable rust-analyzer settings visit:
        -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
        -- https://rust-analyzer.github.io/manual.html#features
        -- https://rust-analyzer.github.io/manual.html
        ["rust-analyzer"] = {
            -- enable clippy on save
            check = { command = "clippy" },
            -- check = { command = "check" },
            completion = {
                callable = {
                    snippets = "fill_arguments",
                },
            },
        },
    },
})
vim.lsp.enable("rust_analyzer")
