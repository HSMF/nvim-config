local function direct_maps()
    local map = vim.api.nvim_set_keymap
    local opts = { noremap = true, silent = true }
    local unmap = vim.api.nvim_del_keymap

    -- unmap("n", "gc")
    -- unmap("n", "gb")
    -- map("n", "<leader>pv", ":wincmd v<CR> :Ex <CR> :vertical resize 30<CR>", { noremap = true })

    -- copy paste
    map("n", "<leader>y", '"+y', { noremap = true })
    map("v", "<leader>y", '"+y', { noremap = true })

    map("n", "<leader>p", '"+p', { noremap = true })
    map("v", "<leader>p", '"+p', { noremap = true })

    map("n", "<leader>tn", ":tabnew<CR>:NvimTreeOpen<CR>", { noremap = false })
    map("n", "<leader>mt", ":MinimapToggle<CR>", { noremap = true })
    map("n", "<leader>.", "lua vim.lsp.buf.code_action()<cr>", { noremap = true })

    -- map("n", "<leader>h", ":wincmd h<CR>", { noremap = false })
    -- map("n", "<leader>j", ":wincmd j<CR>", { noremap = true })
    -- map("n", "<leader>k", ":wincmd k<CR>", { noremap = true })
    -- map("n", "<leader>l", ":wincmd l<CR>", { noremap = true })
    -- map("n", "<leader>ll", ":wincmd l<CR>", { noremap = true })
    map("n", "Y", "yg_", { noremap = true })
    map("n", "gö", ":lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", { noremap = true })

    map("n", "gx", ":!open <c-r><c-a><cr>", opts)
    -- map("n", "gx", ":Open<cr>", opts)

    -- move
    map("n", "º", "<Esc>:m .+1<CR>==", opts)
    map("n", "∆", "<Esc>:m .-2<CR>==", opts)
    map("i", "º", "<Esc>:m .+1<CR>==a", opts)
    map("i", "∆", "<Esc>:m .-2<CR>==a", opts)
    map("v", "º", ":m .+1<CR>==", opts)
    map("v", "∆", ":m .-2<CR>==", opts)
    map("x", "º", ":move '>+1<CR>gv-gv", opts)
    map("x", "∆", ":move '<-2<CR>gv-gv", opts)

    map("n", "<A-j>", "<Esc>:m .+1<CR>==", opts)
    map("n", "<A-k>", "<Esc>:m .-2<CR>==", opts)
    map("i", "<A-j>", "<Esc>:m .+1<CR>==a", opts)
    map("i", "<A-k>", "<Esc>:m .-2<CR>==a", opts)
    map("v", "<A-j>", ":m .+1<CR>==", opts)
    map("v", "<A-k>", ":m .-2<CR>==", opts)
    map("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
    map("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

    vim.keymap.set("n", "<C-f>", "/\\v")

    -- indent
    -- map("n", "<S-Tab>", "<<", opts)
    -- map("i", "<S-Tab>", "<C-d>", opts)
    -- map("n", "<Tab>", ">>", opts)
    -- map("v", "<S-Tab>", "<", opts)
    -- map("v", "<Tab>", ">", opts)

    -- move
    map("x", "p", '"_dP', opts)

    map("x", "K", ":move '<-2<CR>gv-gv", opts)
    map("x", "J", ":move '>+1<CR>gv-gv", opts)
    -- map("x", "º", ":move '>+1<CR>gv-gv", opts)
    -- map("x", "∆", ":move '<-2<CR>gv-gv", opts)

    map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", { silent = true })
    map("n", "gD", "<cmd>lua vim.lsp.buf.definition()<cr>", { silent = true })

    map("n", "Zz", "<cmd>wincmd _ | wincmd |<cr>", opts)
    map("n", "Zo", "<cmd>wincmd =<cr>", opts)

    -- vim.keymap.set({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
    vim.keymap.set({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
    -- vim.keymap.set({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })
    vim.keymap.set({ "n", "o", "x" }, "ge", "<cmd>lua require('spider').motion('ge')<CR>", { desc = "Spider-ge" })

    -- movement with word wrap
    vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
    vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

    -- helldivers :D
    map("n", "<leader>llk", "<CMD>LspRestart<CR>", opts) -- ▶▶▲
    map("n", "<leader>khjjj", "<CMD>LspRestart<CR>", opts) -- ▲◀▼▼▼

    local ls = require("luasnip")
    local cmp = require("cmp")
    vim.keymap.set({ "i", "s" }, "<c-j>", function()
        if ls.jumpable(-1) then
            ls.jump(-1)
        end
    end, { silent = true })
    -- <c-k> is my expansion key
    -- this will expand the current item or jump to the next item within the snippet.
    vim.keymap.set({ "i", "s" }, "<c-k>", function()
        if ls.expand_or_jumpable() then
            ls.expand_or_jump()
        end
    end, { silent = true })

    vim.keymap.set("n", "<leader>sn", function()
        require("luasnip.loaders.from_lua").load({ paths = { "./lua/hyde/snippets/ft/" } })
    end, opts)
    vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

    local goto_diag = function(direction, severity)
        severity = severity or "ERROR"
        return function()
            vim.diagnostic["goto_" .. direction]({ severity = vim.diagnostic.severity[severity] })
        end
    end

    vim.keymap.set("n", "<leader>LJ", goto_diag("next"), {})
    vim.keymap.set("n", "<leader>LK", goto_diag("prev"), {})
    vim.keymap.set("n", "<leader>Lj", goto_diag("next"), {})
    vim.keymap.set("n", "<leader>Lk", goto_diag("prev"), {})

    vim.keymap.set("v", "qq", '"cc<C-r>=<C-r>c<cr><esc>', { desc = "evaluate expression in place" })
    vim.keymap.set("v", "qw", '"cy`>a = <C-r>=<C-r>c<cr><esc>', { desc = "evaluate expression" })

    local range_formatting = function()
        local start_row, _ = unpack(vim.api.nvim_buf_get_mark(0, "<"))
        local end_row, _ = unpack(vim.api.nvim_buf_get_mark(0, ">"))
        vim.lsp.buf.format({
            range = {
                ["start"] = { start_row, 0 },
                ["end"] = { end_row, 0 },
            },
            async = true,
        })
    end

    vim.keymap.set("v", "<leader>lf", range_formatting, { desc = "Range Formatting" })
end

local function config()
    local wk = require("which-key")

    local setup = {
        notify = false,
        plugins = {
            marks = true, -- shows a list of your marks on ' and `
            registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
            spelling = {
                enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
                suggestions = 20, -- how many suggestions should be shown in the list?
            },
            -- the presets plugin, adds help for a bunch of default keybindings in Neovim
            -- No actual key bindings are created
            presets = {
                operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
                motions = true, --adds help for motions
                text_objects = true, -- help for text objects triggered after entering an operator
                windows = true, -- default bindings on <c-w>
                nav = true, -- misc bindings to work with windows
                z = true, -- bindings for folds, spelling and others prefixed with z
                g = true, -- bindings for prefixed with g
            },
        },
        icons = {
            breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
            separator = "➜", -- symbol used between a key and it's label
            group = "+", -- symbol prepended to a group
        },
        -- popup_mappings = {
        --   scroll_down = "<c-d>", -- binding to scroll down inside the popup
        --   scroll_up = "<c-u>", -- binding to scroll up inside the popup
        -- },
        layout = {
            height = { min = 4, max = 25 }, -- min and max height of the columns
            width = { min = 20, max = 50 }, -- min and max width of the columns
            spacing = 3, -- spacing between columns
            align = "left", -- align columns left, center or right
        },
        show_help = true, -- show help message on the command line when the popup is visible
        triggers = { "auto" }, -- automatically setup triggers
        -- triggers = {"<leader>"} -- or specify a list manually
    }

    ---@param mode string
    local function opts(mode)
        return {
            mode = mode, -- NORMAL mode
            prefix = "<leader>",
            buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
            silent = true, -- use `silent` when creating keymaps
            noremap = true, -- use `noremap` when creating keymaps
            nowait = true, -- use `nowait` when creating keymaps
        }
    end

    function flatten_keymaps(prefix, mappings, res)
        if res == nil then
            res = {}
        end

        local group = mappings.name
        if group ~= nil then
            res[#res + 1] = { prefix, group = group }
        end
        for key, value in pairs(mappings) do
            if key == "name" then
                goto continue
            end

            assert(type(key) == "string")

            if type(value) == "string" or type(value) == "function" then
                local entry = { prefix .. key, value }
                res[#res + 1] = entry
                goto continue
            end

            assert(
                type(value) == "table",
                string.format(
                    "expected value to be a table at this point but it is %s (%s)",
                    type(value),
                    vim.inspect(value)
                )
            )

            if type(value[1]) == "string" or type(value[1]) == "function" then
                local entry = { prefix .. key, value[1] }
                if value[2] ~= nil then
                    entry.desc = value[2]
                end
                assert(#value <= 2, "todo: handle other keys" .. vim.inspect(value))
                res[#res + 1] = entry
                goto continue
            end

            flatten_keymaps(prefix .. key, value, res)

            ::continue::
        end
        return res
    end

    local lsp = {
        name = "LSP",
        a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
        D = {
            "<cmd>lua require('telescope.builtin').diagnostics()<cr>",
            "Document diagnostics",
        },
        w = {
            "<cmd>Telescope lsp_workspace_diagnostics<cr>",
            "Workspace Diagnostics",
        },
        f = { "<cmd>lua vim.lsp.buf.format({ async = true })<cr>", "Format" },
        i = { "<cmd>LspInfo<cr>", "Info" },
        j = {
            "<cmd>lua vim.diagnostic.goto_next()<CR>",
            "Next Diagnostic",
        },
        k = {
            "<cmd>lua vim.diagnostic.goto_prev()<cr>",
            "Prev Diagnostic",
        },
        l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
        q = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "Quickfix" },
        r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
        s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
        S = {
            "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
            "Workspace Symbols",
        },
        h = {
            "<cmd>lua vim.lsp.buf.hover()<cr>",
            "hover",
        },
        I = { "<cmd>LspInstallInfo<cr>", "Installer Info" },
    }

    -- local mappings = {
    --     --[[ ["a"] = { "<cmd>Alpha<cr>", "Alpha" }, ]]
    --     ["a"] = { "<cmd>nohlsearch<cr>", "No Highlight" },
    --     -- ["h"] = { "<cmd>nohlsearch<CR>", "No Highlight" },
    --     ["b"] = {
    --         "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
    --         "Buffers",
    --     },
    --     -- ["e"] = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
    --     ["e"] = { "<CMD>Oil<CR>", "Open Parent directory" },
    --     ["w"] = { "<cmd>w!<CR>", "Save" },
    --     ["q"] = { "<cmd>q<CR>", "Quit" },
    --     ["c"] = { "<cmd>bdelete<CR>", "Close Buffer" },
    --     ["f"] = {
    --         "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>",
    --         "Find files",
    --     },
    --     ["F"] = { "<cmd>Telescope live_grep theme=ivy<cr>", "Find Text" },
    --     ["P"] = { "<cmd>Telescope projects<cr>", "Projects" },
    --     R = {
    --         function()
    --             require("hyde.tools.autorun").start_buf_exec()
    --         end,
    --         "start live-executing buffer",
    --     },
    --     g = {
    --         name = "Git",
    --         g = { "<cmd>lua _LAZYGIT_TOGGLE()<CR>", "Lazygit" },
    --         j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
    --         k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
    --         l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
    --         p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
    --         r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
    --         R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
    --         s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
    --         a = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
    --         u = {
    --             "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
    --             "Undo Stage Hunk",
    --         },
    --         o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
    --         b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
    --         c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
    --         d = {
    --             "<cmd>Gitsigns diffthis HEAD<cr>",
    --             "Diff",
    --         },
    --     },
    --     [" "] = { "<cmd>lua vim.diagnostic.open_float()<CR>", "show diagnostics" },
    --     l = lsp,
    --     s = {
    --         name = "Search",
    --         b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
    --         c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
    --         h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
    --         M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
    --         --[[ r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" }, ]]
    --         r = { "<cmd>lua require('ssr').open()<cr>" },
    --         R = { "<cmd>Telescope registers<cr>", "Registers" },
    --         k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
    --         C = { "<cmd>Telescope commands<cr>", "Commands" },
    --         f = {
    --             "<cmd>lua require('telescope.builtin').treesitter()<cr>",
    --             "List Function names, variables, from Treesitter",
    --         },
    --     },
    --     t = {
    --         name = "Terminal",
    --         n = { "<cmd>lua _NODE_TOGGLE()<cr>", "Node" },
    --         d = { "<cmd>lua _DENO_TOGGLE()<cr>", "Deno" },
    --         l = { "<cmd>lua _LUA_TOGGLE()<cr>", "Deno" },
    --         u = { "<cmd>lua _NCDU_TOGGLE()<cr>", "NCDU" },
    --         y = { "<cmd>lua _YTOP_TOGGLE()<cr>", "Ytop" },
    --         p = { "<cmd>lua _PYTHON_TOGGLE()<cr>", "Python" },
    --         f = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
    --         t = { "<cmd>ToggleTerm direction=tab<cr>", "Tab" },
    --         h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" },
    --         v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical" },
    --         -- m = { name = "more", t = ""}
    --     },
    --     -- m = {
    --     --     function()
    --     --         require("harpoon.mark").add_file()
    --     --     end,
    --     --     "add file to harpoon",
    --     -- },
    --     -- M = {
    --     --     function()
    --     --         require("harpoon.ui").toggle_quick_menu()
    --     --     end,
    --     --     "add file",
    --     -- },
    --     d = {
    --         name = "debugger",
    --         [" "] = { "<cmd>lua require'dap'.continue()<cr>", "continue" },
    --         j = { "<cmd>lua require'dap'.step_over()<cr>", "step over" },
    --         l = { "<cmd>lua require'dap'.step_into()<cr>", "step into" },
    --         k = { "<cmd>lua require'dap'.step_out()<cr>", "step out" },
    --         b = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "toggle breakpoint" },
    --         B = {
    --             "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('breakpoint condition: ')<cr>",
    --             "set conditional breakpoint",
    --         },
    --         r = { "<cmd>lua require'dap'.repl.open()<cr>", "open repl" },
    --         h = {
    --             function()
    --                 require("dap.ui.widgets").hover()
    --             end,
    --             "Hover",
    --         },
    --         p = {
    --             function()
    --                 require("dap.ui.widgets").preview()
    --             end,
    --             "open preview",
    --         },
    --         s = {
    --             function()
    --                 require("dapui").toggle()
    --             end,
    --             "toggle dapui",
    --         },
    --     },
    --     o = {
    --         "<cmd>Portal jumplist backward<cr>",
    --         "portal jump backwards",
    --     },
    --     z = {
    --         name = "treesj",
    --         j = {
    --             function()
    --                 require("treesj").join()
    --             end,
    --             "join the current node.",
    --         },
    --         t = {
    --             function()
    --                 require("treesj").toggle()
    --             end,
    --             "toggle the current node.",
    --         },
    --         s = {
    --             function()
    --                 require("treesj").split()
    --             end,
    --             "split the current node.",
    --         },
    --     },
    --     i = {
    --         "<cmd>Portal jumplist forward<cr>",
    --         "portal jump ahead",
    --     },
    --     ["#"] = {
    --         "<cmd>e #",
    --     },
    -- }

    ---@type wk.Spec[]
    local keymaps = {
        {
            "<leader>g",
            group = "Git",
        },
        {
            "<leader>gg",
            "<cmd>lua _LAZYGIT_TOGGLE()<CR>",
            desc = "Lazygit",
        },
        {
            "<leader>gu",
            "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
            desc = "Undo Stage Hunk",
        },
        {
            "<leader>ga",
            "<cmd>lua require 'gitsigns'.stage_hunk()<cr>",
            desc = "Stage Hunk",
        },
        {
            "<leader>gp",
            "<cmd>lua require 'gitsigns'.preview_hunk()<cr>",
            desc = "Preview Hunk",
        },
        {
            "<leader>gj",
            "<cmd>lua require 'gitsigns'.next_hunk()<cr>",
            desc = "Next Hunk",
        },
        {
            "<leader>gl",
            "<cmd>lua require 'gitsigns'.blame_line()<cr>",
            desc = "Blame",
        },
        {
            "<leader>gd",
            "<cmd>Gitsigns diffthis HEAD<cr>",
            desc = "Diff",
        },
        {
            "<leader>gb",
            "<cmd>Telescope git_branches<cr>",
            desc = "Checkout branch",
        },
        {
            "<leader>go",
            "<cmd>Telescope git_status<cr>",
            desc = "Open changed file",
        },
        {
            "<leader>gs",
            "<cmd>lua require 'gitsigns'.stage_hunk()<cr>",
            desc = "Stage Hunk",
        },
        {
            "<leader>gr",
            "<cmd>lua require 'gitsigns'.reset_hunk()<cr>",
            desc = "Reset Hunk",
        },
        {
            "<leader>gR",
            "<cmd>lua require 'gitsigns'.reset_buffer()<cr>",
            desc = "Reset Buffer",
        },
        {
            "<leader>gk",
            "<cmd>lua require 'gitsigns'.prev_hunk()<cr>",
            desc = "Prev Hunk",
        },
        {
            "<leader>gc",
            "<cmd>Telescope git_commits<cr>",
            desc = "Checkout commit",
        },
        {
            "<leader>a",
            "<cmd>nohlsearch<cr>",
            desc = "No Highlight",
        },
        {
            "<leader>q",
            "<cmd>q<CR>",
            desc = "Quit",
        },
        {
            "<leader>e",
            "<CMD>Oil<CR>",
            desc = "Open Parent directory",
        },
        {
            "<leader>b",
            "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
            desc = "Buffers",
        },
        {
            "<leader>f",
            "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>",
            desc = "Find files",
        },
        {
            "<leader>t",
            group = "Terminal",
        },
        {
            "<leader>td",
            "<cmd>lua _DENO_TOGGLE()<cr>",
            desc = "Deno",
        },
        {
            "<leader>tu",
            "<cmd>lua _NCDU_TOGGLE()<cr>",
            desc = "NCDU",
        },
        {
            "<leader>tp",
            "<cmd>lua _PYTHON_TOGGLE()<cr>",
            desc = "Python",
        },
        {
            "<leader>tn",
            "<cmd>lua _NODE_TOGGLE()<cr>",
            desc = "Node",
        },
        {
            "<leader>tl",
            "<cmd>lua _LUA_TOGGLE()<cr>",
            desc = "Deno",
        },
        {
            "<leader>tf",
            "<cmd>ToggleTerm direction=float<cr>",
            desc = "Float",
        },
        {
            "<leader>tt",
            "<cmd>ToggleTerm direction=tab<cr>",
            desc = "Tab",
        },
        {
            "<leader>tv",
            "<cmd>ToggleTerm size=80 direction=vertical<cr>",
            desc = "Vertical",
        },
        {
            "<leader>th",
            "<cmd>ToggleTerm size=10 direction=horizontal<cr>",
            desc = "Horizontal",
        },
        {
            "<leader>ty",
            "<cmd>lua _YTOP_TOGGLE()<cr>",
            desc = "Ytop",
        },
        {
            "<leader>s",
            group = "Search",
        },
        {
            "<leader>sR",
            "<cmd>Telescope registers<cr>",
            desc = "Registers",
        },
        {
            "<leader>sf",
            "<cmd>lua require('telescope.builtin').treesitter()<cr>",
            desc = "List Function names, variables, from Treesitter",
        },
        {
            "<leader>sb",
            "<cmd>Telescope git_branches<cr>",
            desc = "Checkout branch",
        },
        {
            "<leader>sC",
            "<cmd>Telescope commands<cr>",
            desc = "Commands",
        },
        {
            "<leader>sk",
            "<cmd>Telescope keymaps<cr>",
            desc = "Keymaps",
        },
        { "<leader>sr", "<cmd>lua require('ssr').open()<cr>" },
        {
            "<leader>sM",
            "<cmd>Telescope man_pages<cr>",
            desc = "Man Pages",
        },
        {
            "<leader>sh",
            "<cmd>Telescope help_tags<cr>",
            desc = "Find Help",
        },
        {
            "<leader>sc",
            "<cmd>Telescope colorscheme<cr>",
            desc = "Colorscheme",
        },
        {
            "<leader>c",
            "<cmd>bdelete<CR>",
            desc = "Close Buffer",
        },
        {
            "<leader>P",
            "<cmd>Telescope projects<cr>",
            desc = "Projects",
        },
        {
            "<leader>R",
            function()
                require("hyde.tools.autorun").start_buf_exec()
            end,
            desc = "start live-executing buffer",
        },
        {
            "<leader>l",
            group = "LSP",
        },
        {
            "<leader>lI",
            "<cmd>LspInstallInfo<cr>",
            desc = "Installer Info",
        },
        -- {
        --     "<leader>la",
        --     "<cmd>lua vim.lsp.buf.code_action()<cr>",
        --     desc = "Code Action",
        -- },
        {
            "<leader>lq",
            "<cmd>lua vim.diagnostic.setloclist()<cr>",
            desc = "Quickfix",
        },
        {
            "<leader>lS",
            "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
            desc = "Workspace Symbols",
        },
        {
            "<leader>lD",
            "<cmd>lua require('telescope.builtin').diagnostics()<cr>",
            desc = "Document diagnostics",
        },
        {
            "<leader>ll",
            "<cmd>lua vim.lsp.codelens.run()<cr>",
            desc = "CodeLens Action",
        },
        {
            "<leader>lh",
            "<cmd>lua vim.lsp.buf.hover()<cr>",
            desc = "hover",
        },
        {
            "<leader>ls",
            "<cmd>Telescope lsp_document_symbols<cr>",
            desc = "Document Symbols",
        },
        {
            "<leader>lf",
            "<cmd>lua vim.lsp.buf.format({ async = true })<cr>",
            desc = "Format",
        },
        {
            "<leader>lk",
            "<cmd>lua vim.diagnostic.goto_prev()<cr>",
            desc = "Prev Diagnostic",
        },
        {
            "<leader>lr",
            "<cmd>lua vim.lsp.buf.rename()<cr>",
            desc = "Rename",
        },
        {
            "<leader>lj",
            "<cmd>lua vim.diagnostic.goto_next()<CR>",
            desc = "Next Diagnostic",
        },
        {
            "<leader>lw",
            "<cmd>Telescope lsp_workspace_diagnostics<cr>",
            desc = "Workspace Diagnostics",
        },
        {
            "<leader>li",
            "<cmd>LspInfo<cr>",
            desc = "Info",
        },
        {
            "<leader>i",
            "<cmd>Portal jumplist forward<cr>",
            desc = "portal jump ahead",
        },
        {
            "<leader>o",
            "<cmd>Portal jumplist backward<cr>",
            desc = "portal jump backwards",
        },
        {
            "<leader>d",
            group = "debugger",
        },
        {
            "<leader>d ",
            "<cmd>lua require'dap'.continue()<cr>",
            desc = "continue",
        },
        {
            "<leader>dp",
            function()
                require("dap.ui.widgets").preview()
            end,
            desc = "open preview",
        },
        {
            "<leader>dj",
            "<cmd>lua require'dap'.step_over()<cr>",
            desc = "step over",
        },
        {
            "<leader>dl",
            "<cmd>lua require'dap'.step_into()<cr>",
            desc = "step into",
        },
        {
            "<leader>dB",
            "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('breakpoint condition: ')<cr>",
            desc = "set conditional breakpoint",
        },
        {
            "<leader>db",
            "<cmd>lua require'dap'.toggle_breakpoint()<cr>",
            desc = "toggle breakpoint",
        },
        {
            "<leader>dr",
            "<cmd>lua require'dap'.repl.open()<cr>",
            desc = "open repl",
        },
        {
            "<leader>ds",
            function()
                require("dapui").toggle()
            end,
            desc = "toggle dapui",
        },
        {
            "<leader>dk",
            "<cmd>lua require'dap'.step_out()<cr>",
            desc = "step out",
        },
        {
            "<leader>dh",
            function()
                require("dap.ui.widgets").hover()
            end,
            desc = "Hover",
        },
        { "<leader>#", "<cmd>e #" },
        {
            "<leader> ",
            "<cmd>lua vim.diagnostic.open_float()<CR>",
            desc = "show diagnostics",
        },
        {
            "<leader>z",
            group = "treesj",
        },
        {
            "<leader>zt",
            function()
                require("dapui").toggle()
            end,
            desc = "toggle the current node.",
        },
        {
            "<leader>zs",
            function()
                require("dapui").split()
            end,
            desc = "split the current node.",
        },
        {
            "<leader>zj",
            function()
                require("dapui").join()
            end,
            desc = "join the current node.",
        },
        {
            "<leader>w",
            "<cmd>w!<CR>",
            desc = "Save",
        },
        {
            "<leader>F",
            "<cmd>Telescope live_grep theme=ivy<cr>",
            desc = "Find Text",
        },
    }

    for _, mapping in ipairs(keymaps) do
        mapping.mode = "n"
        mapping.noremap = true
        mapping.nowait = true
        mapping.silent = true
    end

    -- G = flatten_keymaps("<leader>", mappings)
    wk.setup(setup)
    -- which_key.register(mappings, opts("n"))
    wk.add(keymaps)

    -- local term_maps = {
    --     ["<c-w>"] = {
    --         ["<c-w>"] = "<cmd>wincmd w<cr>",
    --         ["h"] = [[<C-\><C-n><C-w>h]],
    --         ["j"] = "<cmd>wincmd j<cr>",
    --         ["k"] = [[<C-\><C-n><C-w>k]],
    --         ["l"] = "<cmd>wincmd l<cr>",
    --     },
    --     ["<esc>"] = "<C-\\><C-n>",
    -- }

    -- did not work with whichkey
    vim.cmd("tnoremap <c-w><c-w> <cmd>wincmd w<cr>")
    vim.cmd("tnoremap <c-w>h <cmd>wincmd h<cr>")
    vim.cmd("tnoremap <c-w>j <cmd>wincmd j<cr>")
    vim.cmd("tnoremap <c-w>k <cmd>wincmd k<cr>")
    vim.cmd("tnoremap <c-w>l <cmd>wincmd l<cr>")
    vim.cmd("tnoremap <esc> <C-\\><C-n>")

    -- which_key.register(term_maps, { mode = "t", prefix = "", buffer = nil, silent = true, noremap = false, nowait = true })
end

return {
    {
        "folke/which-key.nvim",
        config = function()
            direct_maps()
            config()
        end,
    },
    {
        "chrisgrieser/nvim-spider",
        lazy = true,
        config = function() end,
    },
}
