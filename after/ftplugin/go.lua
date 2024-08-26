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
        newtext[#newtext + 1] =  line
    end
    newtext[#newtext + 1] = "//gobra:endrewrite " .. hash

    vim.api.nvim_buf_set_lines(0, opts.line1 - 1, opts.line2, false, newtext)

    vim.api.nvim_win_set_cursor(0, { opts.line2 + 3, 0 })
end, { range = true })
