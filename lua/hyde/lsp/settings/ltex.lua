local lspconfig = require("lspconfig")
local configs = require("lspconfig/configs")
local util = require("lspconfig/util")

local language = "en-US"
local spell_dir = vim.fn.stdpath("config") .. "/spell"

local Dictionary_file = {
    [language] = spell_dir .. "/en.utf-8.add",
}
local DisabledRules_file = {
    [language] = spell_dir .. "/disable.txt",
}
local FalsePositives_file = {
    [language] = spell_dir .. "/false.txt",
}

local function read_file(file)
    local f = io.open(file, "r")
    if f == nil then
        return {}
    end

    local lines = {}

    for l in f:lines() do
        table.insert(lines, l)
    end

    return lines
end

local function get_ltex()
    local bufnr = vim.api.nvim_get_current_buf()
    local buf_clients = vim.lsp.get_clients({ bufnr = bufnr })
    for _, client in ipairs(buf_clients) do
        if client.name == "ltex" then
            return client
        end
    end
end

local function update_config(lang, key, new_list)
    local client = get_ltex()

    if not client then
        return nil
    end

    if client.config.settings.ltex[key] then
        client.config.settings.ltex[key][lang] = new_list
        client.notify("workspace/didChangeConfiguration", client.config.settings)
    else
        return vim.notify(string.format("Error when reading %s config, check it", key))
    end
end

local settings = {
    ltex = {
        enabled = { "latex", "tex", "bib", "md" },
        checkFrequency = "save",
        language = language,
        diagnosticSeverity = "information",
        setenceCacheSize = 5000,
        additionalRules = {
            enablePickyRules = true,
            motherTongue = language,
        },
        -- trace = { server = "verbose"};
        -- ['ltex-ls'] = {
        --     logLevel = "finest",
        -- },
        dictionary = {
            [language] = read_file(Dictionary_file[language]),
        },
        disabledRules = {
            [language] = read_file(DisabledRules_file[language]),
        },
        hiddenFalsePositives = {
            [language] = read_file(FalsePositives_file[language]),
        },
    },
}

lspconfig.ltex.setup({ settings = settings })

local function add_entries(path, entries)
    local file = io.open(path, "a")
    if file == nil then
        vim.notify("file " .. path .. " could not be read")
        return
    end
    for _, entry in ipairs(entries) do
        file:write(entry .. "\n")
    end
    io.close(file)
end

local function ltex_add_to_word_list(files, key)
    return function(command)
        local arg = command.arguments[1].words
        local client = get_ltex()

        if not client then
            return
        end

        for lang, entries in pairs(arg) do
            local file = files[lang]
            if file ~= nil then
                add_entries(file, entries)
                local new_file = read_file(file)
                update_config(lang, key, new_file)
            end
        end
    end
end

if vim.lsp.commands["_ltex.addToDictionary"] then
    return
end

vim.api.nvim_create_user_command("LtexReloadConfig", function()
    local client = get_ltex()
    if not client then
        return
    end

    local t = {
        dictionary = Dictionary_file,
        disabledRules = DisabledRules_file,
        hiddenFalsePositives = FalsePositives_file,
    }

    for key, files in pairs(t) do
        for lang, file in pairs(files) do
            client.config.settings.ltex[lang] = read_file(file)
        end
    end

    client.notify("workspace/didChangeConfiguration", client.config.settings)
end, {})

vim.lsp.commands["_ltex.addToDictionary"] = ltex_add_to_word_list(Dictionary_file, "dictionary")
vim.lsp.commands["_ltex.disableRules"] = ltex_add_to_word_list(DisabledRules_file, "disabledRules")
vim.lsp.commands["_ltex.hideFalsePositives"] = ltex_add_to_word_list(FalsePositives_file, "hiddenFalsePositives")
