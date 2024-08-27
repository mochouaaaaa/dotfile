local function get_lsp_root_dir()
    local clients = vim.lsp.buf_get_clients()
    for _, client in pairs(clients) do
        if client.name == "pyright" or client.name == "basedpyright" then
            return client.config.root_dir
        end
    end
    return vim.fn.getcwd()
end

return {
    name = "Run Django development server with custom parameters",
    condition = {
        filetype = { "python" },
        cwd = get_lsp_root_dir(),
    },
    params = {
        port = {
            desc = "Port to run the server on",
            type = "string",
            default = "8000",
        },
    },
    builder = function(params)
        local cmd = { "python", "manage.py", "runserver", "0:" .. params.port }
        return { cmd = cmd, cwd = get_lsp_root_dir() }
    end,

    on_exit = function(status, output)
        if status == 0 then
            vim.notify("Django server stopped successfully")
        else
            vim.notify("Django server failed with exit code: " .. status)
        end
    end,
}
