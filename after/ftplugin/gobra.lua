local extends = vim.fn.stdpath("config") .. "/after/ftplugin/go.lua"
dofile(extends)

vim.opt_local.commentstring = "// %s"
