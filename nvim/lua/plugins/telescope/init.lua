local _key = require("util.keymap")

local config = function()
    local actions = require("telescope.actions")

    require("telescope").setup({
        defaults = {
            prompt_prefix = " ",
            selection_caret = " ",
            multi_icon = " ",
            path_display = {
                "truncate",
            },
            sorting_strategy = "ascending",
            layout_config = {
                horizontal = { prompt_position = "top", preview_width = 0.55 },
                vertical = { mirror = false },
                width = 0.87,
                height = 0.80,
                preview_cutoff = 120,
            },
            mappings = {
                i = {
                    [_key.platform_key.cmd .. "-j>"] = actions.move_selection_next,
                    [_key.platform_key.cmd .. "-k>"] = actions.move_selection_previous,

                    ["<CR>"] = actions.select_default,
                },

                n = {
                    q = actions.close,
                    ["<esc>"] = actions.close,
                    ["<CR>"] = actions.select_default,

                    ["j"] = actions.move_selection_next,
                    ["k"] = actions.move_selection_previous,

                    ["gg"] = actions.move_to_top,
                    ["G"] = actions.move_to_bottom,
                },
            },
            buffer_previewer_maker = function(filepath, bufnr, opts)
                require("plenary.job")
                    :new({
                        command = "file",
                        args = { "-b", "--mime", filepath },
                        on_exit = function(j)
                            if j:result()[1]:find("charset=binary", 1, true) then
                                vim.schedule(function()
                                    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
                                end)
                            else
                                require("telescope.previewers").buffer_previewer_maker(filepath, bufnr, opts)
                            end
                        end,
                    })
                    :sync()
            end,
        },
        pickers = {
            -- find_files = { previewer = false, theme = "dropdown" },
            -- live_grep = { theme = "ivy" },

            -- lsp_references = { theme = "ivy" },
            -- lsp_definitions = { theme = "ivy" },
            -- lsp_type_definitions = { theme = "ivy" },
            -- lsp_implementations = { theme = "ivy" },
            -- lsp_dynamic_workspace_symbols = {
            -- 	sorter = telescope.extensions.fzf.native_fzf_sorter(nil),
            -- },
        },
        extensions = {
            fzf = {
                fuzzy = true, -- false will only do exact matching
                override_generic_sorter = true, -- override the generic sorter
                override_file_sorter = true, -- override the file sorter
                case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            },
        },
    })
end

local M = {
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        import = "plugins.telescope.extra",
        config = config,
        keys = require("plugins.telescope.keys"),
    },
    {
        "prochri/telescope-all-recent.nvim",
        lazy = true,
        opts = {},
    },
    {
        import = "plugins.telescope.load_extension",
    },
}

return M
