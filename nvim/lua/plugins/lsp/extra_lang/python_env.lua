local util = require("lspconfig/util")

local M = {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
        "neovim/nvim-lspconfig",
        { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
    },
    branch = "regexp", -- This is the regexp branch, use this for the new version
    -- event = "VeryLazy", -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
    event = "LspAttach",
}

function M.config()
    -- require("venv-selector").setup {
    -- 	pyenv_path = "/Volumes/Code/tools/.pyenv/versions",
    -- 	cache_dir = vim.fn.getcwd() .. "/.cache/venv-selector/",
    -- 	cache_file = vim.fn.getcwd() .. "/.cache/venv-selector/" .. "/venvs.json",
    -- }
end

M.keys = {
    -- Keymap to open VenvSelector to pick a venv.
    { "<leader>vs", "<cmd>VenvSelect<cr>" },
    -- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
    { "<leader>vc", "<cmd>VenvSelectCached<cr>" },
}

return M
