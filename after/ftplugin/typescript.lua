local util = require("hyde.util")

vim.api.nvim_set_keymap("i", "$", "", {
    nowait = true,
    noremap = true,
    callback = function()
        require("autotemplate").autotemplate(vim.bo.filetype)
    end,
})

vim.api.nvim_buf_create_user_command(0, "MakeAsync", function(opts)
    local cursor_node = util.get_node_at_cursor()
    local node = cursor_node
    while node ~= nil do
        if node:type() == "arrow_function" then
            break
        end
        node = node:parent()
    end
    if node == nil then
        print("no arrow function")
        return
    end

    local start_row, start_col = node:range(false)

    local line = vim.api.nvim_buf_get_lines(0, start_row, start_row + 1, true)[1]

    local before = string.sub(line, 1, start_col)
    local after = string.sub(line, start_col + 1)

    if string.match(after, "async") ~= nil then
        return
    end

    local new = before .. "async " .. after
    vim.api.nvim_buf_set_lines(0, start_row, start_row + 1, true, { new })
end, {})

require("hyde.lsp").load_server("typescript")
