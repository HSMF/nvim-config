local map = vim.keymap.set

local function lsp_maps()
    map("n", "<leader>.", vim.lsp.buf.code_action, { desc = "Code Action" })
    map("n", "gö", vim.diagnostic.open_float, { desc = "Line diagnostics" })

    map("n", "gd", vim.lsp.buf.definition, { silent = true, desc = "Goto definition" })
    map("n", "gD", vim.lsp.buf.declaration, { silent = true, desc = "Goto declaration" })
    map("n", "gi", vim.lsp.buf.implementation, { silent = true, desc = "Goto implementation" })
    map("n", "gr", vim.lsp.buf.references, { silent = true, desc = "References" })

    -- helldivers :D
    map("n", "<leader>llk", "<CMD>LspRestart<CR>", { silent = true }) -- ▶▶▲
    map("n", "<leader>khjjj", "<CMD>LspRestart<CR>", { silent = true }) -- ▲◀▼▼▼

    local goto_diag = function(count)
        return function()
            vim.diagnostic.jump({ count = count, severity = vim.diagnostic.severity.ERROR })
        end
    end
    map("n", "<leader>LJ", goto_diag(1), { desc = "Next error" })
    map("n", "<leader>LK", goto_diag(-1), { desc = "Prev error" })
    map("n", "<leader>Lj", goto_diag(1), { desc = "Next error" })
    map("n", "<leader>Lk", goto_diag(-1), { desc = "Prev error" })

    local range_formatting = function()
        local start_row = vim.api.nvim_buf_get_mark(0, "<")[1]
        local end_row = vim.api.nvim_buf_get_mark(0, ">")[1]
        vim.lsp.buf.format({
            range = {
                ["start"] = { start_row, 0 },
                ["end"] = { end_row, 0 },
            },
            async = true,
        })
    end
    map("v", "<leader>lf", range_formatting, { desc = "Range Formatting" })
end

local function editing_maps()
    local opts = { silent = true }

    -- copy paste
    map({ "n", "v" }, "<leader>y", '"+y')
    map({ "n", "v" }, "<leader>p", '"+p')

    map("n", "<leader>mt", ":MinimapToggle<CR>")
    map("n", "Y", "yg_")
    map("n", "gx", ":!open <c-r><c-a><cr>", opts)
    map("n", "<C-f>", "/\\v")

    -- move lines
    for _, keys in ipairs({ { "º", "∆" }, { "<A-j>", "<A-k>" } }) do
        local down, up = keys[1], keys[2]
        map("n", down, "<Esc>:m .+1<CR>==", opts)
        map("n", up, "<Esc>:m .-2<CR>==", opts)
        map("i", down, "<Esc>:m .+1<CR>==a", opts)
        map("i", up, "<Esc>:m .-2<CR>==a", opts)
        map("s", down, ":m .+1<CR>==", opts)
        map("s", up, ":m .-2<CR>==", opts)
        map("x", down, ":move '>+1<CR>gv-gv", opts)
        map("x", up, ":move '<-2<CR>gv-gv", opts)
    end
    map("x", "K", ":move '<-2<CR>gv-gv", opts)
    map("x", "J", ":move '>+1<CR>gv-gv", opts)

    -- paste over selection without yanking it
    map("x", "p", '"_dP', opts)

    map("n", "Zz", "<cmd>wincmd _ | wincmd |<cr>", opts)
    map("n", "Zo", "<cmd>wincmd =<cr>", opts)

    -- spider motions
    map({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
    map({ "n", "o", "x" }, "ge", "<cmd>lua require('spider').motion('ge')<CR>", { desc = "Spider-ge" })

    -- movement with word wrap
    map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
    map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

    -- snippets: <c-k> expands or jumps forward, <c-j> jumps back
    map({ "i", "s" }, "<c-j>", function()
        local ls = require("luasnip")
        if ls.jumpable(-1) then
            ls.jump(-1)
        end
    end, { silent = true })
    map({ "i", "s" }, "<c-k>", function()
        local ls = require("luasnip")
        if ls.expand_or_jumpable() then
            ls.expand_or_jump()
        end
    end, { silent = true })
    map("n", "<leader>sn", function()
        require("luasnip.loaders.from_lua").load({ paths = { "./lua/hyde/snippets/ft/" } })
    end, { silent = true, desc = "Reload snippets" })

    map("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

    map("v", "qq", '"cc<C-r>=<C-r>c<cr><esc>', { desc = "evaluate expression in place" })
    map("v", "qw", '"cy`>a = <C-r>=<C-r>c<cr><esc>', { desc = "evaluate expression" })

    -- terminal
    map("t", "<c-w><c-w>", "<cmd>wincmd w<cr>")
    map("t", "<c-w>h", "<cmd>wincmd h<cr>")
    map("t", "<c-w>j", "<cmd>wincmd j<cr>")
    map("t", "<c-w>k", "<cmd>wincmd k<cr>")
    map("t", "<c-w>l", "<cmd>wincmd l<cr>")
    map("t", "<esc>", "<C-\\><C-n>")
end

-- { lhs (after <leader>), rhs, desc }
local leader_maps = {
    -- misc
    { "a", "<cmd>nohlsearch<cr>", "No Highlight" },
    { "q", "<cmd>q<CR>", "Quit" },
    { "w", "<cmd>w!<CR>", "Save" },
    { "e", "<CMD>Oil<CR>", "Open Parent directory" },
    { "#", "<cmd>e #<cr>", "Alternate file" },
    { " ", vim.diagnostic.open_float, "show diagnostics" },
    { "i", "<cmd>Portal jumplist forward<cr>", "portal jump ahead" },
    { "o", "<cmd>Portal jumplist backward<cr>", "portal jump backwards" },
    { "R", function() require("hyde.tools.autorun").start_buf_exec() end, "start live-executing buffer" },

    -- telescope
    {
        "b",
        function()
            require("telescope.builtin").buffers(require("telescope.themes").get_dropdown({ previewer = false }))
        end,
        "Buffers",
    },
    {
        "f",
        function()
            require("telescope.builtin").find_files(require("telescope.themes").get_dropdown({ previewer = false }))
        end,
        "Find files",
    },
    { "F", "<cmd>Telescope live_grep theme=ivy<cr>", "Find Text" },
    { "P", "<cmd>Telescope projects<cr>", "Projects" },

    -- git
    { "gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", "Lazygit" },
    { "gj", function() require("gitsigns").nav_hunk("next") end, "Next Hunk" },
    { "gk", function() require("gitsigns").nav_hunk("prev") end, "Prev Hunk" },
    { "gl", function() require("gitsigns").blame_line() end, "Blame" },
    { "gp", function() require("gitsigns").preview_hunk() end, "Preview Hunk" },
    { "ga", function() require("gitsigns").stage_hunk() end, "Stage Hunk" },
    { "gs", function() require("gitsigns").stage_hunk() end, "Stage Hunk" },
    { "gu", function() require("gitsigns").undo_stage_hunk() end, "Undo Stage Hunk" },
    { "gr", function() require("gitsigns").reset_hunk() end, "Reset Hunk" },
    { "gR", function() require("gitsigns").reset_buffer() end, "Reset Buffer" },
    { "gd", "<cmd>Gitsigns diffthis HEAD<cr>", "Diff" },
    { "gb", "<cmd>Telescope git_branches<cr>", "Checkout branch" },
    { "gc", "<cmd>Telescope git_commits<cr>", "Checkout commit" },
    { "go", "<cmd>Telescope git_status<cr>", "Open changed file" },

    -- terminal
    { "td", "<cmd>lua _DENO_TOGGLE()<cr>", "Deno" },
    { "tu", "<cmd>lua _NCDU_TOGGLE()<cr>", "NCDU" },
    { "tp", "<cmd>lua _PYTHON_TOGGLE()<cr>", "Python" },
    { "tn", "<cmd>lua _NODE_TOGGLE()<cr>", "Node" },
    { "tl", "<cmd>lua _LUA_TOGGLE()<cr>", "Lua" },
    { "ty", "<cmd>lua _YTOP_TOGGLE()<cr>", "Ytop" },
    { "tf", "<cmd>ToggleTerm direction=float<cr>", "Float" },
    { "tt", "<cmd>ToggleTerm direction=tab<cr>", "Tab" },
    { "tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical" },
    { "th", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" },

    -- search
    { "sR", "<cmd>Telescope registers<cr>", "Registers" },
    { "sf", "<cmd>Telescope treesitter<cr>", "List Function names, variables, from Treesitter" },
    { "sb", "<cmd>Telescope git_branches<cr>", "Checkout branch" },
    { "sC", "<cmd>Telescope commands<cr>", "Commands" },
    { "sk", "<cmd>Telescope keymaps<cr>", "Keymaps" },
    { "sr", function() require("ssr").open() end, "Structural search & replace" },
    { "sM", "<cmd>Telescope man_pages<cr>", "Man Pages" },
    { "sh", "<cmd>Telescope help_tags<cr>", "Find Help" },
    { "sc", "<cmd>Telescope colorscheme<cr>", "Colorscheme" },

    -- lsp
    { "lI", "<cmd>LspInstallInfo<cr>", "Installer Info" },
    { "lq", vim.diagnostic.setloclist, "Quickfix" },
    { "lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace Symbols" },
    { "lD", "<cmd>Telescope diagnostics bufnr=0<cr>", "Document diagnostics" },
    { "ll", vim.lsp.codelens.run, "CodeLens Action" },
    { "lh", vim.lsp.buf.hover, "hover" },
    { "ls", "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
    { "lf", function() vim.lsp.buf.format({ async = true }) end, "Format" },
    { "lk", function() vim.diagnostic.jump({ count = -1 }) end, "Prev Diagnostic" },
    { "lj", function() vim.diagnostic.jump({ count = 1 }) end, "Next Diagnostic" },
    { "lr", vim.lsp.buf.rename, "Rename" },
    { "lw", "<cmd>Telescope diagnostics<cr>", "Workspace Diagnostics" },
    { "li", "<cmd>LspInfo<cr>", "Info" },

    -- debugger
    { "d ", function() require("dap").continue() end, "continue" },
    { "dj", function() require("dap").step_over() end, "step over" },
    { "dl", function() require("dap").step_into() end, "step into" },
    { "dk", function() require("dap").step_out() end, "step out" },
    { "db", function() require("dap").toggle_breakpoint() end, "toggle breakpoint" },
    {
        "dB",
        function() require("dap").set_breakpoint(vim.fn.input("breakpoint condition: ")) end,
        "set conditional breakpoint",
    },
    { "dr", function() require("dap").repl.open() end, "open repl" },
    { "ds", function() require("dapui").toggle() end, "toggle dapui" },
    { "dp", function() require("dap.ui.widgets").preview() end, "open preview" },
    { "dh", function() require("dap.ui.widgets").hover() end, "Hover" },

    -- treesj
    { "zt", function() require("treesj").toggle() end, "toggle the current node." },
    { "zs", function() require("treesj").split() end, "split the current node." },
    { "zj", function() require("treesj").join() end, "join the current node." },
}

local function setup()
    editing_maps()
    lsp_maps()
    for _, m in ipairs(leader_maps) do
        map("n", "<leader>" .. m[1], m[2], { silent = true, desc = m[3] })
    end
end

return {
    {
        "chrisgrieser/nvim-spider",
        lazy = true,
        -- init runs at startup even though the plugin itself is lazy
        init = setup,
    },
}
