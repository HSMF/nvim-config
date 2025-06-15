vim.bo.commentstring = "// %s"

vim.api.nvim_buf_create_user_command(0, "DocComment", function()
    require("hyde.tools.c-doc-comment").generate_doc_comment()
end, {})

vim.api.nvim_buf_create_user_command(0, "SwitchHeader", function()
    local resp =
        vim.lsp.buf_request_sync(0, "textDocument/switchSourceHeader", vim.lsp.util.make_text_document_params(0))
    if resp == nil then
        vim.notify("timed out", vim.log.levels.ERROR)
        return
    end
    local _, position = next(resp)
    if position == nil then
        vim.notify("no client is attached", vim.log.levels.ERROR)
        return
    end

    if position.error ~= nil then
        vim.notify(position.error.message, vim.log.levels.ERROR)
        return
    end

    local bufnr = vim.uri_to_bufnr(position.result)
    vim.api.nvim_win_set_buf(0, bufnr)
end, {})

DONTFORMATBUF[vim.api.nvim_get_current_buf()] = true

require("hyde.lsp").load_server("clangd")
