vim.opt.expandtab = false
vim.cmd([[setlocal wrap linebreak]])
vim.cmd([[setlocal breakindent]])

local is_linux = vim.fn.has("linux") == 1

local function tex_focus_vim()
    if not is_linux then -- only linux is supported
        return
    end
    if VIM_WINDOW_ID == nil then
        return
    end

    vim.loop.sleep(200)
    vim.fn.system("xdotool windowfocus " .. VIM_WINDOW_ID)
end

if VIM_WINDOW_ID == nil and is_linux then
    VIM_WINDOW_ID = vim.fn.system("xdotool getactivewindow")
end

local function map(mode, pat, to)
    vim.api.nvim_set_keymap(mode, pat, to, { noremap = true, silent = true })
end

map("n", "<leader><cr>", "<cmd>VimtexView<CR>")

if is_linux then
    local group = vim.api.nvim_create_augroup("vimtex_event_focus", {
        clear = true,
    })

    vim.api.nvim_create_autocmd({ "User" }, {
        pattern = "VimtexEventView",
        group = group,
        callback = tex_focus_vim,
    })
end
