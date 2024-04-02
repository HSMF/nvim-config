return {

  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    config = function()
      local ufo = require("ufo")
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99            -- feel free to decrease the value
      vim.o.foldlevelstart = 99       -- feel free to decrease the value
      vim.o.foldenable = true

      vim.keymap.set("n", "zR", require("ufo").openAllFolds)
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      if
          pcall(ufo.setup, {
            provider_selector = function(_, _, _)
              -- function (bufnr, filetype, buftype)
              return { "treesitter", "indent" }
            end,
          })
      then
      else
        print("ufo.lua: failed to setup folds")
      end
    end,
  },
}
