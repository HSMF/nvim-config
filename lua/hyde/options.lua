local function set(where, options)
    for k, v in pairs(options) do
        where[k] = v
    end
end

local options = {
    smartindent = true,
    tabstop = 4,
    shiftwidth = 4,
    expandtab = true,
    softtabstop = 4,
    relativenumber = true,
    mouse = "a",
    number = true,
    wildmenu = true,
    wildmode = "longest:full,full",
    incsearch = true,
    list = true,
    listchars = [[tab: ―→,trail:+,nbsp:·]],
    scrolloff = 10,
    sidescrolloff = 8,
    pumheight = 10,
    showmode = false,
    timeoutlen = 500, -- ms
    fileencoding = "utf-8",
    numberwidth = 2,
    guifont = "MesloLGS Nerd Font Mono:h18",
    wrap = false,
    termguicolors = true,
    cursorline = true,
    ignorecase = true,
    smartcase = true,
    grepprg = "rg --vimgrep --smart-case --hidden",
    grepformat = "%f:%l:%c:%m",
}

local other_options = {
    swapfile = false,
}

local global_options = {
    mapleader = " ",
    maplocalleader = " ",
}

set(vim.opt, options)
set(vim.o, other_options)
set(vim.g, global_options)
