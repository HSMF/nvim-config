return function()
    local nodeactions = require("ts-node-action")
    local actions = require("ts-node-action.actions")
    local builtin_filetypes = require("ts-node-action.filetypes")
    local treesj = require("treesj")

    local js_padding = {
        [","] = "%s ",
        [":"] = "%s ",
        ["{"] = "%s ",
        ["}"] = " %s",
    }

    -- local toggle_multiline = treesj.toggle
    -- local js = vim.tbl_deep_extend("force", builtin_filetypes.javascript, {
    --     ["object"] = toggle_multiline,
    --     ["array"] = toggle_multiline,
    --     ["statement_block"] = toggle_multiline,
    --     ["object_pattern"] = toggle_multiline,
    --     ["object_type"] = toggle_multiline,
    --     ["formal_parameters"] = toggle_multiline,
    --     ["arguments"] = toggle_multiline,
    -- })
    local js = vim.tbl_deep_extend('force', builtin_filetypes.javascript, {
    })


    nodeactions.setup({
        tsx = js,
        javascript = js,
        javascriptreact = js,
        typescript = js,
        svelte = js,
    })

    vim.keymap.set({ "n" }, "<leader>lx", require("ts-node-action").node_action, { desc = "Trigger Node Action" })

    vim.keymap.set({ "n" }, "S", require("ts-node-action").node_action, { desc = "Trigger Node Action" })
end
