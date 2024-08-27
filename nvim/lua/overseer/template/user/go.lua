return {
    name = "run go file",
    builder = function()
        local file = vim.fn.expand("%:p")
        local cmd = { "go", "run", file }
        return { cmd = cmd }
    end,
    condition = {
        filetype = { "go" },
    },
}
