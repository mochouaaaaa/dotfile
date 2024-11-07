local M = {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
        vim.ui.select = function(...)
            require("lazy").load({ plugins = { "dressing.nvim" } })
            return vim.ui.select(...)
        end
        vim.ui.input = function(...)
            require("lazy").load({ plugins = { "dressing.nvim" } })
            return vim.ui.input(...)
        end
    end,
}

M.opts = {
    input = {
        border = vim.g.border.style,
        insert_only = false,
        win_options = { winblend = 0 },
        mappings = {
            n = {
                ["<Esc>"] = "Close",
                ["<CR>"] = "Confirm",
            },
            i = {
                ["<CR>"] = "Confirm",
                ["<C-u>"] = "HistoryPrev",
                ["<C-e>"] = "HistoryNext",
            },
        },
    },
    select = {
        builtin = {
            border = vim.g.border.style,
        },
        telescope = {
            borderchars = vim.g.border.borderchars,
        },
    },
}

return M
