local M = {
    "stevearc/dressing.nvim",
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
        format_item_override = {
            ["legendary.nvim"] = function(items)
                local values = require("legendary.ui.format").default_format(items)
                return string.format("%-20s • %-20s", values[2], values[3])
            end,
        },
    },
}

return M
