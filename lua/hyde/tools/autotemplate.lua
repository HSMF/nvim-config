local ts_utils = require("nvim-treesitter.ts_utils")

local M = {}

function M.yas(language)
    local cursor_node = ts_utils.get_node_at_cursor()
    local string_node = require("hyde.util").filter_treesitter_parent(cursor_node, function(v)
        return v:type() == "string"
    end)
    if string_node == nil then
        return
    end
    local query = vim.treesitter.query.get(language, string.upper(language) .. "AutoTemplate")
    if query == nil then
        vim.notify(
            "query " .. string.upper(language) .. "AutoTemplate was nil, did you call setup?",
            vim.log.levels.ERROR
        )
        return
    end

    local collected_info = {}
    local matched = false
    for id, node in query:iter_captures(string_node, 0) do
        matched = true
        local name = query.captures[id]
        if name == "string_text" then
            collected_info.text = vim.treesitter.get_node_text(node, 0)
        elseif name == "string_outer" then
            local start_row, start_col, end_row, end_col = node:range(false)
            collected_info.start_row = start_row
            collected_info.start_col = start_col
            collected_info.end_row = end_row
            collected_info.end_col = end_col
        end
    end
    if not matched then
        return
    end
    collected_info.text = collected_info.text or ""
    vim.api.nvim_buf_set_text(
        0,
        collected_info.start_row,
        collected_info.start_col,
        collected_info.end_row,
        collected_info.end_col,
        { "`" .. collected_info.text .. "`" }
    )
end

function M.setup()
    for _, lang in ipairs({ "javascript", "typescript", "tsx" }) do
        vim.treesitter.query.set(
            lang,
            string.upper(lang) .. "AutoTemplate",
            [[ [
                (string (string_fragment) @string_text) @string_outer
                (string) @string_outer
            ] ]]
        )
    end
end

function M.autotemplate(language, trigger)
    if trigger == nil then
        trigger = "$"
    end
    local pos = vim.api.nvim_win_get_cursor(0)
    local row = pos[1] - 1
    local col = pos[2]
    M.yas(language)
    vim.api.nvim_buf_set_text(0, row, col, row, col, { trigger })
    vim.api.nvim_win_set_cursor(0, { row + 1, col + 1 })
end

return M
