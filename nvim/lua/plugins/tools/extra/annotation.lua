local util = require("util.keymap")

return {
    {
        "numToStr/Comment.nvim",
        config = function()
            -- gcc和gc注释修改为D-/
            require("Comment").setup({
                toggler = {
                    line = util.platform_key.cmd .. "-/>",
                },
                opleader = {
                    line = util.platform_key.cmd .. "-/>",
                },
            })
        end,
    },
    {
        "folke/todo-comments.nvim",
        cmd = { "TodoTrouble", "TodoTelescope", "TodoQuickFix", "TodoLocList", "TodoFixFixme", "TodoFixFixmeTrouble" },
        opts = {
            signs = false,
            sign_priority = 8, -- sign priority
            -- keywords recognized as todo comments
            keywords = {
                FIX = {
                    icon = " ", -- icon used for the sign, and in search results
                    color = "error", -- can be a hex color, or a named color (see below)
                    alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
                    -- signs = false, -- configure signs for some keywords individually
                },
                TODO = { icon = " ", color = "info" },
                HACK = { icon = " ", color = "warning" },
                WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
                PERF = { icon = " ", color = "warning", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
                NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
                TEST = { icon = " ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
            },
            gui_style = {
                fg = "italic", -- The gui style to use for the fg highlight group.
                bg = "NONE", -- The gui style to use for the bg highlight group.
            },
            merge_keywords = true, -- when true, custom keywords will be merged with the defaults
            -- highlighting of the line containing the todo comment
            -- * before: highlights before the keyword (typically comment characters)
            -- * keyword: highlights of the keyword
            -- * after: highlights after the keyword (todo text)
            -- highlight sample:
            highlight = {
                before = "", -- 'fg' or 'bg' or empty
                keyword = "bg", -- 'fg', 'bg', 'wide' or empty. (wide is the same as bg, but will also highlight surrounding characters)
                after = "fg", -- 'fg' or 'bg' or empty
                pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?):?]],
                comments_only = true, -- uses treesitter to match keywords in comments only
                max_line_len = 400, -- ignore lines longer than this
                exclude = {}, -- list of file types to exclude highlighting
            },
            -- list of named colors where we try to extract the guifg from the
            -- list of highlight groups or use the hex color if hl not found as a fallback
            colors = {
                error = { "DiagnosticError" },
                warning = { "DiagnosticWarn" },
                info = { "DiagnosticInfo" },
                hint = { "DiagnosticHint" },
                default = { "Identifier" },
                test = { "Identifier" },
            },
            search = {
                command = "rg",
                args = {
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                },
                -- regex that will be used to match keywords.
                -- don't replace the (KEYWORDS) placeholder
                pattern = [[\b(KEYWORDS)(\(\w*\))*:?]],
            },
        },
        config = function(_, opts)
            require("todo-comments").setup(opts)
            vim.keymap.set("n", "<leader>ft", "<Cmd>TodoTelescope<CR>", { desc = "project all todo" })
        end,
    },
}
