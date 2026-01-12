local VerificationState = {
    Stopped = 0,
    Starting = 1,
    VerificationRunning = 2,
    VerificationPrintingHelp = 3,
    VerificationReporting = 4,
    PostProcessing = 5,
    Ready = 6,
    Stopping = 7,
    Stage = 8,
    ConstructingAst = 9
}

local verification_state_handlers = {
    [VerificationState.Ready] = function(params)
        if params.verificationCompleted == 1 then
            -- local uri = vim.uri_to_bufnr(params.uri)
            vim.notify("verification state: " .. params.success, vim.log.levels.INFO)
        end
    end
}

local VerificationStateToString = {}
for key, value in pairs(VerificationState) do
    VerificationStateToString[value] = key
end

vim.api.nvim_buf_create_user_command(0, "ConnectViper", function(opts)
    local port = tonumber(opts.args)
    assert(port, "port must be number")

    VIPER_CLIENT_ID = vim.lsp.start({
        cmd = vim.lsp.rpc.connect("127.0.0.1", port),
        name = "viper",
        on_attach = require "hyde.lsp.handlers".on_attach,
        handlers = {
            StateChange = function(err, result)
                if err ~= nil then
                    vim.notify("got an error: " .. vim.json.encode(err))
                    return
                end
                if result.newState == VerificationState.ConstructingAst then
                    return
                end

                local state = VerificationStateToString[result.newState]

                local handler = verification_state_handlers[state]
                if handler ~= nil then
                    handler(result)
                end

                vim.notify(state, vim.log.levels.TRACE)
            end
        }
    })
    assert(VIPER_CLIENT_ID, "client could attach")
    vim.lsp.buf_attach_client(0, VIPER_CLIENT_ID)
end, { nargs = "?" })

if VIPER_CLIENT_ID ~= nil then
    vim.lsp.buf_attach_client(0, VIPER_CLIENT_ID)
end

vim.api.nvim_buf_create_user_command(0, "AttachViper", function()
    assert(VIPER_CLIENT_ID, "client is running")
    vim.lsp.buf_attach_client(0, VIPER_CLIENT_ID)
end, {})

vim.api.nvim_buf_create_user_command(0, "Verify", function()
    vim.lsp.buf_notify(0, "Verify", {
        uri = vim.uri_from_bufnr(0),
        manuallyTriggered = true,
        backend = "silicon",
        customArgs = "",
        content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false))
    })
end, {})
