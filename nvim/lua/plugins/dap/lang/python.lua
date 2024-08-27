local env = require("plugins.configs.virtual_env")

return {
    config = function(dap)
        dap.adapters.python = {
            type = "executable",
            -- command = env.python_env(),
            args = { "-m", "debugpy.adapter" },
            options = {
                source_filetype = "python",
            },
        }

        dap.configurations.python = {
            {
                type = "python",
                name = "Debug Single File",
                request = "launch",
                -- This configuration will launch the current file if used.
                program = "${file}",
                cwd = "${workspaceFolder}",
                pythonPath = env.python_env(),
                justMyCode = false,
                console = "integratedTerminal",
            },
            {
                type = "python",
                request = "launch",
                name = "Django Project",
                program = vim.fn.getcwd() .. "/manage.py",
                pythonPath = env.python_env(),
                args = function()
                    local args_string = vim.fn.input("arguments: ")
                    return { "runserver", args_string, "--noreload" }
                end,
                justMyCode = false,
                console = "integratedTerminal",
                django = true,
            },
        }
    end,
}
