local utils = require("config.utils")

return {
    {
        import = "plugins.tools.extra",
    },
    {
        "theniceboy/joshuto.nvim",
        cond = not vim.g.vscode,
        enabled = false,
        config = function()
            vim.api.nvim_set_keymap("n", utils.platform_key.cmd .. "-r>", "", {
                noremap = true,
                callback = function()
                    require("joshuto").joshuto()
                end,
                desc = "joshuto file manager",
            })
        end,
    },
    {
        "mikavilpas/yazi.nvim",
        event = "VeryLazy",
        config = function()
            vim.keymap.set("n", utils.platform_key.cmd .. "-r>", function()
                require("yazi").yazi()
            end)
        end,
    },
}
