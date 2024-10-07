local util = require("hyde.util")
local buffer = vim.api.nvim_get_current_buf()

local function expand_pred(pred, line, pos)
    local start = util.find_index(pred, 1, string.len(line), pos, -1) or 0
    local end_ = util.find_index(pred, 1, string.len(line), pos, 1) or (string.len(line) + 1)

    return string.sub(line, start + 1, end_ - 1)
end

local function expand_kw(line, pos)
    local function p(i)
        local ch = string.sub(line, i, i)
        return not string.match(ch, "[a-zA-Z_.]")
    end
    return expand_pred(p, line, pos)
end

local function expand_not_sp(line, pos)
    local function p(i)
        local ch = string.sub(line, i, i)
        return string.match(ch, "[ \t\n]") ~= nil
    end
    return expand_pred(p, line, pos)
end

local function expand(line, pos)
    local ch = string.sub(line, pos, pos)

    if string.match(ch, "[a-zA-Z_.]") then
        return expand_kw(line, pos)
    end

    if string.match(ch, "%s") or ch == ")" or ch == "(" then
        return ""
    end

    return '"' .. expand_not_sp(line, pos) .. '"'
end

local function cword_cmd(cmd)
    return function()
        -- local cword = vim.fn.expand("<cWORD>")
        local cursor = vim.api.nvim_win_get_cursor(0)
        local line_num, col = cursor[1], cursor[2]
        col = col + 1
        local lines = vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, true)
        local line = lines[1]

        local cword = expand(line, col)

        print(cword)

        if cword == "" then
            return
        end
        local com = ":" .. cmd .. " " .. cword
        print(vim.inspect(com))
        vim.cmd(com)
    end
end

vim.keymap.set("n", "<leader>lj", "<cmd>CoqNext<cr>", { buffer = buffer })
vim.keymap.set("n", "<leader>lk", "<cmd>CoqUndo<cr>", { buffer = buffer })
vim.keymap.set("n", "<leader>ll", "<cmd>CoqToLine<cr>", { buffer = buffer })
vim.keymap.set("n", "gd", cword_cmd("CoqGotoDef"), { buffer = buffer })
vim.keymap.set("n", "<leader>lh", cword_cmd("Coq About"), { buffer = buffer })
vim.keymap.set("n", "K", cword_cmd("Coq Print"), { buffer = buffer })
