local util = require("lspconfig/util")

local M = {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
        "neovim/nvim-lspconfig",
    },
    branch = "regexp", -- This is the regexp branch, use this for the new version
}

function M.config()
    local venv_selector = require("venv-selector")

    local function shorter_name(filename)
        return filename:gsub(os.getenv("HOME"), "~"):gsub("/bin/python", "")
    end

    venv_selector.setup({
        settings = {
            pyenv_path = os.getenv("PYENV_ROOT") .. "/versions",
            options = {
                on_telescope_result_callback = shorter_name,
            },
            search = {
                -- cwd = false,
                pyenv = {
                    command = "fd python$ "
                        .. vim.env.HOME
                        .. "/.config/env/pyenv/versions --max-depth 3 --full-path -a -L",
                    on_telescope_result_callback = shorter_name,
                },
            },
        },
    })
end

M.keys = {
    -- Keymap to open VenvSelector to pick a venv.
    { "<leader>vs", "<cmd>VenvSelect<cr>" },
    -- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
    { "<leader>vc", "<cmd>VenvSelectCached<cr>" },
}

return M
