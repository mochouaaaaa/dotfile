local Terminal = require("toggleterm.terminal").Terminal

local terminal = Terminal:new({
    -- open_mapping = [[<C-\>]],
    size = function(term)
        return ({
            horizontal = vim.o.lines * 0.3,
            vertical = vim.o.columns * 0.35,
        })[term.direction]
    end,
    shade_terminals = true,
    start_in_insert = true,
    insert_mappings = true,
    autochdir = true,
    persistent = true,
    close_on_exit = true,
    auto_scroll = true,
    direction = "float", --[[ 'vertical' | 'horizontal' | 'tab' | 'float', ]]
    float_opts = {
        border = "rounded",
        winblend = 0,
        highlights = {
            border = "Normal",
            background = "Normal",
        },
    },

    -- function to run on opening the terminal
    on_open = function(term)
        vim.cmd("set mouse=")
    end,
    -- function to run on closing the terminal
    on_close = function(term)
        vim.cmd("set mouse=a")
    end,
})

function _terminal_toggle()
    terminal:toggle()
end

vim.keymap.set({ "n", "t" }, "<C-\\>", function()
    _terminal_toggle()
end, { noremap = true, silent = true, desc = "terminal" })
