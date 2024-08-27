return {
    name = "run python file",
    condition = {
        filetype = { "python" },
    },
    builder = function()
        local file = vim.fn.expand("%:p")
        local cmd = { "python", file }
        return { cmd = cmd }
    end,
}
