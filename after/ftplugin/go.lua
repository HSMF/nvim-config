vim.opt_local.expandtab = false

vim.opt_local.listchars = [[tab:  ,trail:+,nbsp:·]]
local autocmd = vim.api.nvim_create_autocmd

autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
        local params = vim.lsp.util.make_range_params()
        params.context = { only = { "source.organizeImports" } }
        -- buf_request_sync defaults to a 1000ms timeout. Depending on your
        -- machine and codebase, you may want longer. Add an additional
        -- argument after params if you find that you have to write the file
        -- twice for changes to be saved.
        -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
        local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
        for cid, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
                if r.edit then
                    local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                    vim.lsp.util.apply_workspace_edit(r.edit, enc)
                end
            end
        end
    end,
})

vim.api.nvim_buf_create_user_command(0, "GobraRewrite", function(opts)
    local text = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)

    local res = vim.system({ "sha256sum" }, {
        stdin = text,
        text = true,
    }):wait()

    local hash = res.stdout:match("[^ ]+")

    local newtext = {
        "//gobra:rewrite " .. hash,
    }

    for _, line in ipairs(text) do
        newtext[#newtext + 1] = "//gobra:cont " .. line
    end
    newtext[#newtext + 1] = "//gobra:end-old-code " .. hash
    for _, line in ipairs(text) do
        newtext[#newtext + 1] = line
    end
    newtext[#newtext + 1] = "//gobra:endrewrite " .. hash

    vim.api.nvim_buf_set_lines(0, opts.line1 - 1, opts.line2, false, newtext)

    vim.api.nvim_win_set_cursor(0, { opts.line2 + 3, 0 })
end, { range = true })

---find_line
---@param start number
---@param offset number
---@param matcher function
---@return number|nil,string|nil
local function find_line(start, offset, matcher)
    local row = start
    local buffer = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    while true do
        if row < 1 or row > #buffer then
            return nil, nil
        end
        local text = buffer[row]
        if matcher(text) then
            return row, text
        end

        row = row + offset
    end
end

vim.api.nvim_buf_create_user_command(0, "GobraRevert", function()
    local pos = vim.api.nvim_win_get_cursor(0)
    local row, _ = pos[1], pos[2]
    local text = vim.api.nvim_buf_get_lines(0, row - 1, row, false)

    local start, line = find_line(row, -1, function(l)
        local match = string.match(l, "^[\t ]*//gobra:rewrite")
        return match ~= nil
    end)

    if start == nil or line == nil then
        print("no start found")
        return
    end

    local hash = string.match(line, "^[\t ]*//gobra:rewrite ([a-f0-9]+)")

    local end_row, line = find_line(row, 1, function(l)
        local match = string.match(l, "^[\t ]*//gobra:endrewrite " .. hash)
        return match ~= nil
    end)

    if end_row == nil or line == nil then
        print("no end found")
        return
    end

    local end_old_code, _ = find_line(start, 1, function(l)
        local match = string.match(l, [[^[\t ]*//gobra:end%-old%-code ([a-f0-9]+)]])
        return match == hash
    end)
    if end_old_code == nil then
        print("no middle found")
        return
    end

    local lines = vim.api.nvim_buf_get_lines(0, start, end_old_code - 1, false)

    local newlines = {}
    for i, theline in ipairs(lines) do
        local match = string.match(theline, [[^[\t ]*//gobra:cont ?(.*)]])
        if match == nil then
            vim.notify("ERROR IN OLD CODE: on line " .. (i + start) .. ". stopping", vim.log.levels.ERROR)
            return
        end

        newlines[#newlines + 1] = match
    end


    vim.api.nvim_buf_set_lines(0, start - 1, end_row, false, newlines)
end, { range = false })
