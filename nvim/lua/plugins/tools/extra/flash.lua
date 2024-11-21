local M = {
    "folke/flash.nvim",
    event = "VeryLazy",
}

local api, fn = vim.api, vim.fn

M.opts = {
    jump = { autojump = false },
    modes = {
        search = {
            enabled = false,
            highlight = {
                backdrop = true,
            },
        },
    },
    prompt = { enabled = false },
}

M.keys = {
    {
        "s",
        mode = { "n", "x", "o" },
        function()
            require("flash").jump({
                search = {
                    multi_window = false,
                    mode = function(str)
                        return "\\<" .. str
                    end,
                },
            })
        end,
        -- function()
        --     require("flash").jump({
        --         -- search = {
        --         -- 	mode = function(str) return "\\<" .. str end,
        --         -- },
        --         pattern = ".",
        --         search = {
        --             mode = function(pattern)
        --                 -- remove leading dot
        --                 if pattern:sub(1, 1) == "." then
        --                     pattern = pattern:sub(2)
        --                 end
        --                 return ([[%s\w*\>]]):format(pattern), ([[%s]]):format(pattern)
        --             end,
        --         },
        --     })
        -- end,
        desc = "flash jump",
    },
    {
        "S",
        mode = { "n", "x", "o" },
        function()
            require("flash").treesitter()
        end,
        desc = "flash jump treesitter",
    },
}

function M.config(_, opts)
    require("flash").setup(opts)
    local set_hl = api.nvim_set_hl
    set_hl(0, "FlashLabel", {
        bg = "#ff007c",
        fg = "#c8d3f5",
    })
    set_hl(0, "FlashMatch", {
        bg = "#5377da",
        fg = "#b6c5f0",
    })
end

return M
