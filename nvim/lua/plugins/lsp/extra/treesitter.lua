local ts_langs = {
    -- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
    "bash",
    "c",
    "cmake",
    "comment",
    "cpp",
    "css",
    "dart",
    "diff",
    "dockerfile",
    "git_rebase",
    "gitattributes",
    "gitcommit",
    "gitignore",
    "go",
    "gomod",
    "gosum",
    "gowork",
    "graphql",
    "html",
    "ini",
    "javascript",
    "json",
    "json5",
    "jsonc",
    "latex",
    "lua",
    "luap",
    "make",
    "markdown",
    "markdown_inline",
    "php",
    "prisma",
    "python",
    "regex",
    "ruby",
    "rust",
    "scss",
    "smali",
    "sql",
    "svelte",
    "swift",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vue",
    "yaml",
    "zig",
}

return {
    -- 彩虹分隔符
    {
        "HiPhish/rainbow-delimiters.nvim",
        lazy = true,
        config = function(_, opts)
            -- This module contains a number of default definitions
            local rainbow_delimiters = require("rainbow-delimiters")

            vim.g.rainbow_delimiters = {
                strategy = {
                    [""] = rainbow_delimiters.strategy["global"],
                    vim = rainbow_delimiters.strategy["local"],
                },
                query = {
                    [""] = "rainbow-delimiters",
                    lua = "rainbow-blocks",
                    html = "rainbow-tags",
                    javascript = "rainbow-delimiters-react",
                },
                highlight = {
                    "RainbowYellow",
                    "RainbowLightGreen",
                    "RainbowViolet",
                    "RainbowBlue",
                    "RainbowLightGreen",
                    "RainbowCyan",
                    "RainbowViolet",
                },
            }
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        init = function(plugin)
            -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
            -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
            -- no longer trigger the **nvim-treeitter** module to be loaded in time.
            -- Luckily, the only thins that those plugins need are the custom queries, which we make available
            -- during startup.
            require("lazy.core.loader").add_to_rtp(plugin)
            require("nvim-treesitter.query_predicates")
        end,
        config = function(_, opts)
            require("nvim-treesitter.configs").setup({
                ensure_installed = ts_langs,
                auto_install = true,
                sync_install = true,
                ignore_install = {},
                modules = {},

                highlight = { enable = true, additional_vim_regex_highlighting = false },
                autotag = {
                    enable = true,
                },
                indent = { enable = true },
                context_commentstring = { enable = true, enable_autocmd = false },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<CR>",
                        node_incremental = "<CR>",
                        scope_incremental = false,
                        node_decremental = "<S-CR>",
                    },
                },
                textobjects = {
                    select = {
                        enabled = true,
                        lookahead = true,
                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ["[f"] = "@function.outer",
                            ["]f"] = "@function.inner",
                            ["[c"] = "@class.outer",
                            ["]c"] = "@class.inner",
                        },
                        include_surrounding_whitespace = true,
                    },
                },
            })
        end,
    },
}
