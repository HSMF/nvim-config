vim.api.nvim_create_user_command("Wrap", function()
    vim.opt_local.wrap = true
    vim.opt_local.breakindent = true
    vim.opt_local.linebreak = true
end, {})

vim.api.nvim_create_user_command("NoWrap", function()
    vim.opt_local.wrap = false
    vim.opt_local.breakindent = false
    vim.opt_local.linebreak = false
end, {})

local function match_word_pattern(word)
    -- TODO: escape word
    return "%f[%w_]" .. word .. "%f[^%w_]"
end

local function is_numeric(word)
    return string.match(word, "^%d+$")
end

vim.api.nvim_create_user_command("Rename", function(opts)
    local from = opts.fargs[1]
    local to = opts.fargs[2]

    local cursor = vim.api.nvim_win_get_cursor(0)
    local lnum, _ = cursor[1], cursor[2]
    local line = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, true)[1]
    local is_safe = not (line:find(match_word_pattern(to)) ~= nil) or is_numeric(to)

    if not is_safe and not opts.bang then
        vim.notify("not safe to replace " .. from .. " -> " .. to, vim.log.levels.ERROR)
        return
    end

    local new = string.gsub(line, match_word_pattern(from), to)

    vim.api.nvim_buf_set_lines(0, lnum - 1, lnum, true, { new })
end, {
    nargs = "*",
    bang = true,
})

local function esc(x)
    return (
        x:gsub("%%", "%%%%")
            :gsub("^%^", "%%^")
            :gsub("%$$", "%%$")
            :gsub("%(", "%%(")
            :gsub("%)", "%%)")
            :gsub("%.", "%%.")
            :gsub("%[", "%%[")
            :gsub("%]", "%%]")
            :gsub("%*", "%%*")
            :gsub("%+", "%%+")
            :gsub("%-", "%%-")
            :gsub("%?", "%%?")
    )
end

vim.api.nvim_create_user_command("ShareLocation", function()
    local root = vim.fs.root(0, { ".git" })
    local file
    if root == nil then
        file = vim.fn.expand("%")
    else
        file = vim.fn.expand("%:p")
        file = string.gsub(file, "^" .. esc(root) .. "/?", "")
    end
    local line, _ = unpack(vim.api.nvim_win_get_cursor(0))
    local res = string.format("%s:%d", file, line)

    vim.fn.setreg("+", res)
end, {})
