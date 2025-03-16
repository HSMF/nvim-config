vim.bo.commentstring = "// %s"

vim.api.nvim_buf_create_user_command(0, "DocComment", function()
    require("hyde.tools.c-doc-comment").generate_doc_comment()
end, {})
