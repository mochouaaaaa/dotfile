return {
    "rebelot/heirline.nvim",
    dependencies = {
        "Zeioth/heirline-components.nvim",
        dependencies = {
            "folke/zen-mode.nvim",
            "stevearc/aerial.nvim",
            "SmiteshP/nvim-navic",
        },
    },
    event = "UIEnter",
    opts = function()
        local coustom_lib = require("plugins.configs.heirline")
        local lib = require("heirline-components.all")
        return {
            opts = {
                disable_winbar_cb = function(args) -- We do this to avoid showing it on the greeter.
                    local is_disabled = not require("heirline-components.buffer").is_valid(args.buf)
                        or lib.condition.buffer_matches({
                            buftype = { "terminal", "prompt", "nofile", "help", "quickfix" },
                            filetype = { "NvimTree", "neo%-tree", "dashboard", "Outline", "aerial" },
                        }, args.buf)
                    return is_disabled
                end,
            },
            tabline = { -- UI upper bau
                lib.component.tabline_conditional_padding(),
                lib.component.tabline_buffers(),
                lib.component.fill({ hl = { bg = "tabline_bg" } }),
                lib.component.tabline_tabpages(),
            },
            winbar = { -- UI breadcrumbs bar
                init = function(self)
                    self.bufnr = vim.api.nvim_get_current_buf()
                end,
                fallthrough = false,
                lib.component.winbar_when_inactive(),
                {

                    {
                        provider = " ",
                    },
                    coustom_lib.navic(),
                    lib.component.fill(),
                    coustom_lib.overseer(),
                },
            },
            statuscolumn = { -- UI left column
                init = function(self)
                    self.bufnr = vim.api.nvim_get_current_buf()
                end,
                lib.component.foldcolumn(),
                lib.component.numbercolumn(),
                lib.component.signcolumn(),
            } or nil,
            statusline = { -- UI statusbar
                hl = { fg = "fg", bg = "bg" },
                lib.component.mode(),
                {
                    init = function()
                        left_components_length = 4
                    end,
                    provider = function()
                        return "   "
                    end,
                    -- hl = primary_highlight,
                },
                lib.component.git_branch(),
                lib.component.file_info(),
                lib.component.git_diff(),
                lib.component.diagnostics(),
                lib.component.fill(),
                lib.component.cmd_info(),
                lib.component.fill(),
                lib.component.lsp(),
                -- lib.component.compiler_state(),
                {
                    condition = function()
                        return vim.bo.filetype == "python"
                    end,
                    lib.component.virtual_env(),
                },
                lib.component.nav(),
                lib.component.mode({ surround = { separator = "right" } }),
            },
        }
    end,
    config = function(_, opts)
        local heirline = require("heirline")
        local heirline_components = require("heirline-components.all")

        -- Setup
        heirline_components.init.subscribe_to_events()
        heirline.load_colors(heirline_components.hl.get_colors())
        heirline.setup(opts)
    end,
}
