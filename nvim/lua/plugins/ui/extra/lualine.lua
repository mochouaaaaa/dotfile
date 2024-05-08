local function memory_use()
    local use = (1 - (vim.uv.get_free_memory() / vim.uv.get_total_memory())) * 100
    return (" Memory: %.2f"):format(use) .. " %%"
end

local function diff_source()
    local gitsigns = vim.b.gitsigns_status_dict
    if gitsigns then
        return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed,
        }
    end
end

return {
    "nvim-lualine/lualine.nvim",
    cond = vim.g.vscode,
    event = { "VeryLazy" },
    dependencies = {
        -- { "AndreM222/copilot-lualine", lazy = true },
        { "nvim-tree/nvim-web-devicons", lazy = true },
        { "meuter/lualine-so-fancy.nvim", lazy = true },
        { "SmiteshP/nvim-navic", lazy = true },
        { "linux-cultist/venv-selector.nvim", lazy = true },
    },
    enabled = true,
    config = function()
        local navic = require("nvim-navic")
        navic.setup({ highlight = true })
        local winbar = {
            lualine_a = {
                {
                    function()
                        return navic.get_location()
                    end,
                    cond = function()
                        return navic.is_available()
                    end,
                    color = {
                        bg = "",
                    },
                },
            },
            lualine_b = {},
            lualine_x = {
                {
                    memory_use,
                    color = {
                        fg = "#69bbae",
                        bg = "#304263",
                    },
                    separator = { left = "" },
                },
            },
            lualine_y = {},
            lualine_z = {
                {
                    "fancy_lsp_servers",
                    color = {
                        fg = "#1e1e2e",
                        bg = "#986FEC",
                    },
                    separator = { right = "" },
                    left_padding = 2,
                },
            },
        }

        local sections = {
            lualine_a = {
                {
                    "fancy_mode",
                    separator = { left = "" },
                },
            },
            lualine_b = {
                {
                    "b:gitsigns_head",
                    icon = "",
                    color = {
                        fg = "#69bbae",
                        bg = "#1e1e2e",
                    },
                },
                {
                    "fancy_diff",
                    source = diff_source,
                    separator = { right = "" },
                },
            },

            lualine_c = {
                { "fancy_cwd", substitute_home = true },
                {
                    "venv-selector",
                    cond = function()
                        return vim.bo.filetype == "python"
                    end,
                },
            },
            lualine_x = {
                -- {
                --     "copilot",
                --     show_colors = true,
                --     show_loading = true,
                --     separator = { right = "" },
                -- },
                {
                    "filetype",
                    colored = true, -- Displays filetype icon in color if set to true
                    icon_only = false, -- Display only an icon for filetype
                }, -- Display filetype icon on the right hand side },
            },
            lualine_z = {
                { "fancy_location", separator = { right = "" }, left_padding = 2 },
            },
        }

        table.insert(sections.lualine_x, 1, require("lazyvim.util").lualine.cmp_source("codeium"))

        local opts = {
            options = {
                component_separators = "",
                theme = "catppuccin",
                section_separators = {
                    right = "",
                    left = "",
                },
                always_divide_middle = true,
                globalstatus = true,
                refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000,
                },
                ignore_focus = {
                    "dapui_watches",
                    "dapui_stacks",
                    "dapui_breakpoints",
                    "dapui_scopes",
                    "dapui_console",
                    "dap-repl",
                },
                disabled_filetypes = {
                    statusline = {
                        "alpha",
                        "toggleterm",
                        "lspsagaoutline",
                    },
                    winbar = {
                        "NvimTree",
                        "neo-tree",
                        "nvim-lsp",
                        "dashboard",
                        "Outline",
                        "aerial",

                        "alpha",
                        "help",
                        "lspsagaoutline",
                        "Trouble",
                        "toggleterm",
                        "dap-repl",
                        "dapui_console",
                        "dapui_watches",
                        "dapui_stacks",
                        "dapui_breakpoints",
                        "dapui_scopes",
                    },
                },
            },
            sections = sections,
            winbar = winbar,
            extensions = { "lazy", "neo-tree" },
        }
        require("lualine").setup(opts)
    end,
}
