local M = {}

function M.on_attach(client, buffer)
    vim.g.syntastic_python_checkers = { "mypy" }
end

local util = require("lspconfig.util")

M.extra = function(config)
    return {
        enabled = vim.g.python_lsp == "pyright",
        single_file_support = true,
        root_dir = function(fname)
            local root_files = {
                "pyproject.toml",
                "setup.py",
                "setup.cfg",
                "requirements.txt",
                "Pipfile",
                "pyrightconfig.json",
                ".python-version",
            }
            return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname) or nil
        end,
    }
end

M.capapilities = {
    textDocument = {
        publishDiagnostics = {
            tagSupport = {
                valueSet = {
                    2,
                },
            },
        },
    },
}

return M
