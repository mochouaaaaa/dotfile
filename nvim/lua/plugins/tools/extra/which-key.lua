return {
    "folke/which-key.nvim",
    dependencies = { "echasnovski/mini.nvim", "nvim-tree/nvim-web-devicons" },
    opts = {
        layout = {
            height = { min = 4, max = 25 }, -- min and max height of the columns
            width = { min = 20, max = 50 }, -- min and max width of the columns
            spacing = 3, -- spacing between columns
            align = "left", -- align columns left, center or right
        },
        plugins = {
            marks = true, -- shows a list of your marks on ' and `
            registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
            spelling = {
                enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
                suggestions = 20, -- how many suggestions should be shown in the list?
            },
            presets = {
                operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
                motions = true, -- adds help for motions
                text_objects = false, -- help for text objects triggered after entering an operator
                windows = true, -- default bindings on <c-w>
                nav = true, -- misc bindings to work with windows
                z = true, -- bindings for folds, spelling and others prefixed with z
                g = true, -- bindings for prefixed with g
            },
        },
        disable = {
            filetypes = {},
            buftypes = { "TelescopePrompt" },
        },
    },
    config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts)
        wk.add({
            { "<leader>b", desc = "buffer / conversion" },
            { "<leader>c", desc = "code action / cd" },
            { "<leader>d", desc = "docker / debug / dagang" },
            { "<leader>f", desc = "telescope" },
            { "<leader>g", desc = "git" },
            { "<leader>v", desc = "virtual venv" },
            { "<leader>s", desc = "search replace" },
            { "<leader>w", desc = "lsp workspace" },
            { "<leader>r", desc = "code rename" },
            { "<leader>n", desc = "annotation" },
            { "<leader>x", desc = "lsp diagnostics" },
        })
    end,
}
