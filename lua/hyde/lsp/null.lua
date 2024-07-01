local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
    return
end

local helpers = require("null-ls.helpers")

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions

local sqlfmt = {
    method = null_ls.methods.FORMATTING,
    filetypes = { "sql" },
    generator = null_ls.formatter({
        command = "python3.11",
        args = function()
            return { "sql-pretty.py", "-" }
        end,
        to_stdin = true,
    }),
}

local asmfmt = {
    method = null_ls.methods.FORMATTING,
    filetypes = { "asm" },
    generator = null_ls.formatter({
        command = "asmfmt",
        -- args = function()
        --     return { vim.fn.expand("%") }
        -- end,
        to_stdin = true,
    }),
}

local texfmt = {
    method = null_ls.methods.FORMATTING,
    filetypes = { "tex" },
    generator = null_ls.formatter({
        command = "latexindent",
        to_stdin = true,
    }),
}

local google_java_format = {
    method = null_ls.methods.FORMATTING,
    filetypes = { "java" },
    generator = null_ls.formatter({
        command = "google-java-format",
        args = function()
            return {
                "--aosp",
                "--replace",
                "-",
            }
        end,
        to_stdin = true,
    }),
}

local gobra = {
    method = null_ls.methods.DIAGNOSTICS,
    filetypes = { "gobra", "go" },
    -- generator = {
    --     fn = function(params)
    --         local diagnostics = {}
    --         -- TODO: make this better
    --         local output = vim.fn.system({ "/home/hyde/eth/6/bachelor/rungobra.sh", ".", "." })
    --
    --         for line in output:gmatch("[^\r\n]+") do
    --             local match = string.match(line, "([^: ]+):(%d+):(%d+):error: (.+)")
    --             if match ~= nil then
    --                 local file, line, col = match
    --             end
    --         end
    --
    --         return diagnostics
    --     end,
    -- },
    generator = null_ls.generator({
        command = "rungobra-file.sh",
        args = function()
            local out = {
                vim.fn.expand("%:p"),
                ".",
            }
            return out
        end,
        to_stdin = false,
        from_stderr = false,
        format = "line",
        check_exit_code = function(code, stderr)
            local success = code <= 1

            if not success then
                -- can be noisy for things that run often (e.g. diagnostics), but can
                -- be useful for things that run on demand (e.g. formatting)
                print(stderr)
            end

            return success
        end,
        on_output = helpers.diagnostics.from_patterns({
            {
                pattern = [[[^: ]+:(%d+):(%d+):error: (.+)]],
                groups = { "row", "col", "message" },
            },
            {
                pattern = [[<[^: ]+:(%d+):(%d+)> (.+)]],
                groups = { "row", "col", "message" },
            },
        }),
    }),
}

null_ls.setup({
    --[[ debug = true, ]]
    sources = {
        -- formatting.prettier.with({ }),
        formatting.prettierd.with({
            filetypes = {
                "javascript",
                "javascriptreact",
                "typescript",
                "typescriptreact",
                -- "vue",
                -- "css",
                -- "scss",
                -- "less",
                "html",
                -- "json",
                "jsonc",
                -- "yaml",
                -- "graphql",
                -- "handlebars",
                "svelte",
            },
        }),
        formatting.black.with({ extra_args = { "--fast" } }),
        formatting.stylua.with({ extra_args = { "--indent-type", "Spaces" } }),
        --diagnostics.eslint_d,
        --code_actions.eslint_d,
        -- formatting.markdown_toc,
        formatting.mdformat,
        formatting.shfmt,
        formatting.google_java_format.with({ extra_args = { "--aosp" } }),
        -- diagnostics.flake8
        sqlfmt,
        texfmt,
        asmfmt,
        diagnostics.fish,
        gobra,
    },
})
