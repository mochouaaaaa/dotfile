local _key = require("util.keymap")

return {
    { -- This plugin
        "Zeioth/compiler.nvim",
        cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
        dependencies = { "stevearc/overseer.nvim", "nvim-telescope/telescope.nvim" },
        opts = {},
    },
    { -- The task runner we use
        "stevearc/overseer.nvim",
        -- cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
        init = function()
            vim.keymap.set("n", "<F6>", "<cmd>OverseerRun<cr>", { desc = "Run task" })
            vim.keymap.set("n", "<F7>", "<cmd>OverseerQuickAction<cr>", { desc = "Quick Action" })
        end,
        config = function()
            local overseer = require("overseer")

            overseer.setup({
                dap = false,
                templates = { "user.python", "user.python_params", "user.django", "user.go" },
                strategy = {
                    "toggleterm",
                    use_shell = true,
                    direction = "horizontal",
                    auto_scroll = true,
                    close_on_exit = false,
                    open_on_start = true,
                    hidden = false,
                },
                task_list = {
                    direction = "left",
                    bindings = {
                        [_key.platform_key.cmd .. "-h>"] = "<C-w>h",
                        [_key.platform_key.cmd .. "-j>"] = "<C-w>j",
                        [_key.platform_key.cmd .. "-k>"] = "<C-w>k",
                        [_key.platform_key.cmd .. "-l>"] = "<C-w>l",
                    },
                },
                form = {
                    border = vim.g.border.style,
                    win_opts = {
                        winblend = vim.o.pumblend,
                    },
                },
            })

            overseer.add_template_hook({
                module = "^make$",
            }, function(task_defn, util)
                util.add_component(task_defn, { "on_output_quickfix", open_on_exit = "failure" })
                util.add_component(task_defn, "on_complete_notify")
                util.add_component(task_defn, { "display_duration", detail_level = 1 })
            end)
        end,
    },
}
