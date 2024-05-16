return {
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-calc",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lsp",
            "davidsierradz/cmp-conventionalcommits",
            "f3fora/cmp-spell",
            "L3MON4D3/LuaSnip",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            require("luasnip/loaders/from_vscode").lazy_load()

            local check_backspace = function()
                local col = vim.fn.col(".") - 1
                return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
            end

            local kind_icons = {
                Text = "󰉿",
                Method = "m",
                Function = "󰊕",
                Constructor = "",
                Field = "",
                Variable = "󰆧",
                Class = "󰌗",
                Interface = "",
                Module = "",
                Property = "",
                Unit = "",
                Value = "󰎠",
                Enum = "",
                Keyword = "󰌋",
                Snippet = "",
                Color = "󰏘",
                File = "󰈙",
                Reference = "",
                Folder = "󰉋",
                EnumMember = "",
                Constant = "󰇽",
                Struct = "",
                Event = "",
                Operator = "󰆕",
                TypeParameter = "󰊄",
            }
            -- https://www.nerdfonts.com/cheat-sheet

            local behavior = { behavior = cmp.SelectBehavior.Select }
            local mapping = {
                ["<C-k>"] = cmp.mapping.select_prev_item(behavior),
                ["<C-j>"] = cmp.mapping.select_next_item(behavior),
                ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c", "n" }),
                ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c", "n" }),
                ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
                ["<C-y>"] = cmp.config.disable,
                ["<C-e>"] = cmp.mapping({
                    i = cmp.mapping.abort(),
                    c = cmp.mapping.close(),
                }),
                ["<Down>"] = cmp.mapping.select_next_item(behavior),
                ["<Up>"] = cmp.mapping.select_prev_item(behavior),
                -- ["<CR>"] = cmp.mapping.confirm({ select = true }),
                ["<CR>"] = cmp.mapping.confirm({ select = false }),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item(behavior)
                        --[[ elseif luasnip.expandable() then ]]
                        --[[ 	luasnip.expand() ]]
                    elseif luasnip.expand_or_locally_jumpable() ~= nil and luasnip.expand_or_jumpable() then
                        -- returns either true or nil
                        luasnip.expand_or_jump()
                    elseif check_backspace() then
                        fallback()
                    else
                        fallback()
                    end
                end, {
                    "i",
                    "s",
                }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    --[[ if cmp.visible() then ]]
                    --[[ 	cmp.select_prev_item() ]]
                    --[[ elseif luasnip.jumpable(-1) then ]]
                    --[[ 	luasnip.jump(-1) ]]
                    --[[ else ]]
                    --[[ 	fallback() ]]
                    --[[ end ]]
                    if cmp.visible() then
                        cmp.select_prev_item(behavior)
                        --[[ elseif luasnip.expandable() then ]]
                        --[[ 	luasnip.expand() ]]
                    elseif luasnip.expand_or_locally_jumpable(-1) ~= nil and luasnip.expand_or_jumpable(-1) then
                        -- returns either true or nil
                        luasnip.expand_or_jump(-1)
                    elseif check_backspace() then
                        fallback()
                    else
                        fallback()
                    end
                end, {
                    "i",
                    "s",
                }),
            }

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = {
                    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-u>"] = cmp.mapping.scroll_docs(4),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<C-z>"] = cmp.mapping(
                        cmp.mapping.confirm({
                            behavior = cmp.ConfirmBehavior.Insert,
                            select = true,
                        }),
                        { "i", "c" }
                    ),
                    ["<CR>"] = cmp.mapping({
                        i = function(fallback)
                            if cmp.visible() and cmp.get_active_entry() then
                                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                            else
                                fallback()
                            end
                        end,
                        s = cmp.mapping.confirm({ select = true }),
                    }),
                    ["<M-z>"] = cmp.mapping(
                        cmp.mapping.confirm({
                            behavior = cmp.ConfirmBehavior.Replace,
                            select = false,
                        }),
                        { "i", "c" }
                    ),

                    ["<c-space>"] = cmp.mapping({
                        i = cmp.mapping.complete(),
                        c = function(
                            _ --[[fallback]]
                        )
                            if cmp.visible() then
                                if not cmp.confirm({ select = true }) then
                                    return
                                end
                            else
                                cmp.complete()
                            end
                        end,
                    }),

                    -- ["<tab>"] = false,
                    ["<tab>"] = cmp.mapping(function(fallback)
                        if
                            cmp.visible()
                            or (luasnip.expand_or_locally_jumpable(-1) ~= nil and luasnip.expand_or_jumpable(-1))
                        then
                            vim.api.nvim_err_writeln(
                                ""
                                    .. "<C-n>       next\n"
                                    .. "<C-p>       previous\n"
                                    .. "<C-d>       scroll down\n"
                                    .. "<C-u>       scroll up\n"
                                    .. "<C-e>       abort\n"
                                    .. "<C-z>       select\n"
                                    .. "<C-space>   suggest\n"
                                    .. ""
                            )
                            return
                        end
                        fallback()
                    end),
                },
                formatting = {
                    fields = { "kind", "abbr", "menu" },
                    format = function(entry, vim_item)
                        vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
                        vim_item.menu = ({
                            nvim_lsp = "[LSP]",
                            luasnip = "[Snippet]",
                            buffer = "[Buffer]",
                            path = "[Path]",
                            calc = "[Calc]",
                            cmp_tabnine = "[TN]",
                            crates = "[crates.io]",
                        })[entry.source.name]
                        return vim_item
                    end,
                },
                sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    -- {name = "cmp_tabnine"},
                    { name = "calc" },
                    {
                        name = "buffer",
                        -- option = { keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h[a-zA-Zöäüéàè]*\%([\-.]\w*\)*\)]] },
                        option = {
                            -- keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h[a-zA-Zöäüéàè]*\%([\-.][a-zA-Zöäüéàè]*\)*\)]],
                            keyword_pattern = [[\k\+]],
                        },
                    },
                    { name = "path" },
                    { name = "orgmode" },
                    { name = "crates" },
                    {
                        name = "spell",
                        option = {
                            enable_in_context = function()
                                return require("cmp.config.context").in_treesitter_capture("spell")
                            end,
                        },
                    },
                },
                confirm_opts = {
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = false,
                },
                window = {
                    documentation = cmp.config.window.bordered(),
                    completion = cmp.config.window.bordered(),
                },
                -- view = {
                --     entries = "native"
                -- },
                experimental = {
                    ghost_text = { hl_group = "Comment" },
                },
            })

            cmp.setup.filetype({ "sql" }, {
                sources = {
                    { name = "vim-dadbod-completion" },
                    { name = "buffer" },
                },
            })

            cmp.setup.cmdline("/", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = { { name = "buffer" } },
            })

            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    {
                        name = "cmdline",
                        option = {
                            ignore_cmds = { "Man", "!" },
                        },
                    },
                }),
            })

            -- luasnip.config.setup({ history = false, region_check_events = "InsertEnter", delete_check_events = "InsertLeave" })
            luasnip.config.set_config({
                history = true,
                enable_autosnippets = true,
                region_check_events = "InsertEnter",
                delete_check_events = "TextChanged",
                update_events = "TextChanged,TextChangedI",
                store_selection_keys = "<Tab>",
            })
        end,
    },
}
