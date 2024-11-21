local _key = require("util.keymap")

return {
    {
        import = "plugins.tools.extra",
    },
    {
        "theniceboy/joshuto.nvim",
        cond = not vim.g.vscode,
        enabled = false,
        config = function()
            vim.api.nvim_set_keymap("n", _key.platform_key.cmd .. "-r>", "", {
                noremap = true,
                callback = function()
                    require("joshuto").joshuto()
                end,
                desc = "joshuto file manager",
            })
        end,
    },
}
