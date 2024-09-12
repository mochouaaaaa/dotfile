_G.__cached_neo_tree_selector = nil
_G.__get_selector = function()
    return _G.__cached_neo_tree_selector
end

local bufferline = {
    "akinsho/bufferline.nvim",
    dependencies = { "echasnovski/mini.bufremove", "nvim-tree/nvim-web-devicons" },
    opts = function()
        return {
            highlights = require("catppuccin.groups.integrations.bufferline").get(),
            options = {
                always_show_bufferline = true,
                show_duplicate_prefix = true, -- whether to show duplicate buffer prefix
                -- numbers = function(opts)
                -- return string.format("%s·%s", opts.lower(opts.ordinal), opts.raise(opts.id))
                -- end,
                enforce_regular_tabs = true,
                offsets = {
                    filetype = "neo-tree",
                    raw = " %{%v:lua.__get_selector()%} ",
                    highlight = { sep = { link = "WinSeparator" } },
                    -- text = "File Explorer",
                    -- text_align = "left",
                    separator = "┃",
                },
            },
        }
    end,
}

local utils = require("config.utils")

bufferline.keys = {
    {
        utils.platform_key.cmd .. "-w>",
        function()
            local bd = require("mini.bufremove").delete
            if vim.bo.modified then
                local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
                if choice == 1 then -- Yes
                    vim.cmd.write()
                    bd(0)
                elseif choice == 2 then -- No
                    bd(0, true)
                end
            else
                bd(0)
            end
        end,
        desc = "Close Buffer",
    },
     -- stylua: ignore
    { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
    { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "close all other visible buffers" },
    -- 左右切换
    { "<S-h>", "<Cmd>BufferLineCyclePrev<CR>", desc = "swap right buffer" },
    { "<S-l>", "<Cmd>BufferLineCycleNext<CR>", desc = "swap left buffer" },
    { "<S-left>", "<Cmd>BufferLineCyclePrev<CR>" },
    { "<S-right>", "<Cmd>BufferLineCycleNext<CR>" },
}

return {
    bufferline,
}
