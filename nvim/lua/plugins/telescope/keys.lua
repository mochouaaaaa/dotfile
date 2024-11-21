local extr_args = require("util.fzf").extr_args

local _key = require("util.keymap")
local telescope = require("telescope.builtin")

return {
    {
        "/",
        function()
            telescope.current_buffer_fuzzy_find()
        end,
    },
    {
        "<leader>fg",
        "<Cmd>Telescope git_files<CR>",
        desc = "Search Git File",
    },
    {
        _key.platform_key.cmd .. "-S-f>",
        function()
            telescope.live_grep({ additional_args = extr_args })
        end,
        desc = "Grep (root dir)",
    },
    {
        _key.platform_key.cmd .. "-f>",
        function()
            telescope.find_files({
                find_command = { "rg", "--color=never", "--smart-case", "--files", unpack(extr_args) },
            })
        end,
        desc = ".* Search files cucurrent directory",
    },
    {
        "<leader>fs",
        "<Cmd>Telescope spell_suggest<CR>",
        desc = "spell suggestions about cursor word",
    },
    {
        "<leader>fb",
        function()
            telescope.buffers({ sort_mru = true, sort_lastused = true })
        end,
        desc = "find buffers",
    },
    {
        "<leader>fk",
        "<Cmd>Telescope keymaps<CR>",
        desc = "Check out keymaps[S-C-/]",
    },
}
