return {
    name = "run python script",
    condition = {
        filetype = { "python" },
    },
    params = {
        command = {
            desc = "Enter Command Params",
            type = "string",
            default = "",
        },
    },
    builder = function(params)
        local file = vim.fn.expand("%:p")
        local cmd = { "python", file, params.command }
        return { cmd = cmd }
    end,
}
