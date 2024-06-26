return {
    {
        "windwp/nvim-autopairs",
        config = function()
            local ok, npairs = pcall(require, "nvim-autopairs")
            if not ok then
                return
            end

            -- local Rule = require("nvim-autopairs.rule")

            npairs.setup({
                check_ts = true,
                ts_config = {
                    lua = { "string", "source" },
                    javascript = { "string", "template_string" },
                    java = false,
                },
                disable_filetype = { "TelescopePrompt", "spectre_panel" },
                fast_wrap = {
                    map = "<C-a>",
                    chars = { "{", "[", "(", '"', "'" },
                    pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
                    offset = 0, -- Offset from pattern match
                    end_key = "$",
                    keys = "qwertzuiopyxcvbnmasdfghjkl",
                    check_comma = true,
                    highlight = "PmenuSel",
                    highlight_grey = "LineNr",
                },
            })

            -- local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            -- local cmp_status_ok, cmp = pcall(require, "cmp")
            -- if not cmp_status_ok then
            --     return
            -- end
            -- cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
        end,
    },
}
