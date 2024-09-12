return {
    enabled = true,
    config = function(utils)
        return {
            "luozhiya/fittencode.nvim",
            config = function()
                local fitten_code = require("fittencode")
                fitten_code.setup({
                    use_default_keymaps = false,
                    keymaps = {
                        inline = {},
                    },
                    disable_specific_inline_completion = {
                        suffixes = { "TelescopePrompt", "neo-tree-popup" },
                    },
                })

                local autopairs = require("nvim-autopairs")

                vim.keymap.set("i", "<Tab>", function()
                    if fitten_code.has_suggestions() then
                        autopairs.disable()
                        fitten_code.accept_line()
                        autopairs.enable()
                    else
                        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
                    end
                end, { silent = true, desc = "fittencode accept" })

                vim.keymap.set("i", utils.platform_key.cmd .. "-e>", function()
                    if fitten_code.has_suggestions() then
                        fitten_code.dismiss_suggestions()
                    else
                        vim.api.nvim_feedkeys(
                            vim.api.nvim_replace_termcodes(utils.platform_key.cmd .. "-e>", true, false, true),
                            "n",
                            false
                        )
                    end
                end)
                vim.opt.updatetime = 200

                local function get_clipboard_content()
                    return vim.fn.getreg("+")
                end

                local function translate_clipboard_to_chinese()
                    local content = get_clipboard_content()
                    local translated = fitten_code.translate_text_into_chinese(content)
                    vim.notify(translated)
                end
                vim.keymap.set("n", "<leader>tt", function()
                    vim.notify("Translating clipboard content to Chinese...")
                end)
            end,
        }
    end,
}
