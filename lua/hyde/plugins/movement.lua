return {
  {
    "cbochs/portal.nvim",
    -- Optional dependencies
    dependencies = {
      "cbochs/grapple.nvim",
    },
  },
  {

    "cbochs/grapple.nvim",
    after = "which-key",
    config = function()
      local whichkey = require("which-key")
      whichkey.register({
        m = {
          function()
            require("grapple").toggle()
            -- vim.cmd("BufferLineTogglePin")
          end,

          "add buffer to tag list",
        },
        M = {
          require("grapple").toggle_tags,
          "view tag list",
        },
      }, {
        prefix = "<leader>",
      })
    end,
  },
}
