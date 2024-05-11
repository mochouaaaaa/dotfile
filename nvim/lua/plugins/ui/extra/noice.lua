local opts = {
    -- you can enable a preset for easier configuration
    lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        progress = {
            enabled = true,
            format = "lsp_progress",
            format_done = "lsp_progress_done",
            throttle = 1000 / 30, -- frequency to update lsp progress message
            view = "mini",
        },
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
        },
    },
    presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = true, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
        command_palette = {
            views = {
                cmdline_popup = {
                    position = {
                        row = "30%",
                        col = "50%",
                    },
                    size = {
                        min_width = 60,
                        width = "auto",
                        height = "auto",
                    },
                },
            },
        },
    },
    views = {
        mini = {
            win_options = {
                winblend = 0,
            },
        },
    },
    routes = {
        {
            filter = {
                event = "notify",
                any = {
                    -- Neo-tree
                    { find = "Toggling hidden files: true" },
                    { find = "Toggling hidden files: false" },
                    { find = "Operation canceled" },

                    -- lsp hover
                    { find = "No information available" },

                    -- Telescope
                    { find = "Nothing currently selected" },
                },
            },
            opts = { skip = true },
        },
        {
            filter = {
                event = "msg_show",
                kind = { "echo" },
            },
            opts = { skip = true },
        },
        {
            filter = {
                event = "msg_show",
                kind = "",
                any = {
                    -- Save
                    { find = " bytes written" },

                    -- Redo/Undo
                    { find = " changes; before #" },
                    { find = " changes; after #" },
                    { find = "1 change; before #" },
                    { find = "1 change; after #" },

                    -- Yank
                    { find = " lines yanked" },

                    -- Move lines
                    { find = " lines moved" },
                    { find = " lines indented" },

                    -- Bulk edit
                    { find = " fewer lines" },
                    { find = " more lines" },
                    { find = "1 more line" },
                    { find = "1 line less" },

                    -- General messages
                    { find = "Already at newest change" },
                    { find = "Already at oldest change" },
                    { find = "E21: Cannot make changes, 'modifiable' is off" },
                },
            },
            opts = { skip = true },
        },
        {
            filter = {
                event = "msg_show",
                kind = "emsg",
                any = {
                    -- TODO: A bug workaround of Lspsaga's finder
                    -- { find = "E134: Cannot move a range of lines into itself" },
                },
            },
            opts = { skip = true },
        },
        {
            filter = {
                event = "lsp",
                any = {
                    { find = "formatting" },
                    { find = "Diagnosing" },
                    { find = "Diagnostics" },
                    { find = "diagnostics" },
                    { find = "code_action" },
                    { find = "cargo check" },
                    { find = "Processing full semantic tokens" },
                },
            },
            opts = { skip = true },
        },
    },
}

local set_hl = vim.api.nvim_set_hl
for hl, color in pairs({
    NoiceFormatProgressDone = {
        -- bg = '#455c6d',
        bg = "#d38aea",
    },
    NoiceFormatProgressTodo = {
        -- bg = '#d38aea',
        bg = "#455c6d",
    },
    NoiceLspProgressTitle = {
        fg = "#7ad7f3",
    },
    NoiceLspProgressClient = {
        -- link = 'MoreMsg'
        fg = "#d38aea",
    },
    NoiceLspProgressSpinner = {
        fg = "#d38aea",
    },
}) do
    set_hl(0, hl, color)
end

return {
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            { "MunifTanjim/nui.nvim", lazy = true },
        },
        enabled = false,
        opts = opts,
        config = function(_, opts)
            local noice = require("noice")
            noice.setup(opts)

            local wk = require("which-key")
            wk.register({
                ["<leader>f"] = {
                    name = "Telescope",
                    n = {
                        function()
                            noice.cmd("telescope")
                        end,
                        "opens message history",
                    },
                },
            })

            local Util = require("lazyvim.util")
            Util.on_load("telescope.nvim", function()
                require("telescope").load_extension("noice")
            end)
        end,
    },
}
