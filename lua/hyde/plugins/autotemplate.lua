return {
    {
        "HSMF/autotemplate.nvim",
        name = "autotemplate.nvim",
        dev = true,
        opts = {},
        config = function()
            if true then return end
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
                callback = function(args)
                    vim.keymap.set("i", "$", function()
                        require "autotemplate".autotemplate(vim.bo.filetype)
                    end, {
                        buffer = args.buf
                    })
                end
            })
        end
    },
}
