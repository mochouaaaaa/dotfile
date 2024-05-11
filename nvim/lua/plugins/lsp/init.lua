return {
    {
        "smjonas/inc-rename.nvim",
        config = function()
            require("inc_rename").setup()
        end,
    },
    {
        "aznhe21/actions-preview.nvim",
        config = function()
            local hl = require("actions-preview.highlight")
            require("actions-preview").setup({
                diff = {
                    algorithm = "patience",
                    ignore_whitespace = true,
                },
                highlight_command = {
                    hl.delta("delta --no-gitconfig --side-by-side"),
                    hl.diff_so_fancy("diff-so-fancy", "less -R"),
                },
                telescope = {
                    sorting_strategy = "ascending",
                    layout_strategy = "vertical",
                    layout_config = {
                        width = 0.8,
                        height = 0.9,
                        prompt_position = "top",
                        preview_cutoff = 20,
                        preview_height = function(_, _, max_lines)
                            return max_lines - 15
                        end,
                    },
                },
            })
        end,
    },
    {
        "Wansmer/symbol-usage.nvim",
        enabled = false,
        config = function()
            local function text_format(symbol)
                local fragments = {}

                if symbol.references then
                    local usage = symbol.references <= 1 and "usage" or "usages"
                    local num = symbol.references == 0 and "no" or symbol.references
                    table.insert(fragments, ("%s %s"):format(num, usage))
                end

                if symbol.definition then
                    table.insert(fragments, symbol.definition .. " defs")
                end

                if symbol.implementation then
                    table.insert(fragments, symbol.implementation .. " impls")
                end

                return table.concat(fragments, ", ")
            end
            require("symbol-usage").setup({
                request_pending_text = "",
                implementation = { enabled = true },
                definition = { enabled = true },
                references = { enabled = true },
                text_format = text_format,
                disable = {
                    cond = {
                        function()
                            return vim.fn.expand("%:p"):find(vim.fn.getcwd())
                        end,
                        function()
                            return vim.fn.expand("%:p"):find("/site_packages/")
                        end,
                        function()
                            return vim.fn.expand("%:p"):find("/venv/")
                        end,
                    },
                },
            })
        end,
    },
    {
        "windwp/nvim-autopairs",
        dependencies = "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        config = function()
            local npairs = require("nvim-autopairs")
            local Rule = require("nvim-autopairs.rule")
            local cond = require("nvim-autopairs.conds")

            npairs.setup({
                check_ts = true,
                ts_config = {
                    lua = { "string", "source" },
                    javascript = { "string", "template_string" },
                    java = false,
                },
                fast_wrap = {
                    chars = { "{", "(", "[", "<", '"', "'", "`" },
                    pattern = [=[[%'%"%)%>%]%)%}%,]]=],
                    offset = 0,
                    end_key = "$",
                    keys = "qwertyuiopzxcvbnmasdfghjkl",
                    check_comma = true,
                    highlight = "Search",
                    highlight_grey = "Comment",
                },
                enable_check_bracket_line = true,
                disable_filetype = { "TelescopePrompt", "vim" },
            })

            -- TODO: remove this block when https://github.com/windwp/nvim-autopairs/pull/363 is merged

            npairs.add_rules({
                Rule("<", ">"):with_pair(cond.before_regex("%a+")):with_move(function(o)
                    return o.char == ">"
                end),
                Rule(" ", " "):with_pair(function(options)
                    local pair = options.line:sub(options.col - 1, options.col)
                    return vim.tbl_contains({ "()", "[]", "{}" }, pair)
                end),
                Rule("( ", " )")
                    :with_pair(function()
                        return false
                    end)
                    :with_move(function(options)
                        return options.prev_char:match(".%)") ~= nil
                    end)
                    :use_key(")"),
                Rule("{ ", " }")
                    :with_pair(function()
                        return false
                    end)
                    :with_move(function(options)
                        return options.prev_char:match(".%}") ~= nil
                    end)
                    :use_key("}"),
                Rule("[ ", " ]")
                    :with_pair(function()
                        return false
                    end)
                    :with_move(function(options)
                        return options.prev_char:match(".%]") ~= nil
                    end)
                    :use_key("]"),
            })

            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            local cmp_status_ok, cmp = pcall(require, "cmp")

            if not cmp_status_ok then
                return
            end

            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
    },
    { "folke/neodev.nvim" },
    { import = "plugins.lsp.extra" },
    { import = "plugins.lsp.extra_lang" },
}
