return {
    enabled = false,
    config = function(utils)
        return {
            "Exafunction/codeium.vim",
            enabled = false,
            config = function()
                vim.g.codeium_disable_bindings = 1
                vim.keymap.set("i", "<Tab>", function()
                    return vim.fn["codeium#Accept"]()
                end, { expr = true, silent = true })
                vim.keymap.set("i", utils.platform_key.cmd .. "-j>", function()
                    return vim.fn["codeium#CycleCompletions"](1)
                end, { expr = true, silent = true })
                vim.keymap.set("i", utils.platform_key.cmd .. "-k>", function()
                    return vim.fn["codeium#CycleCompletions"](-1)
                end, { expr = true, silent = true })
                vim.keymap.set("i", utils.platform_key.cmd .. "-e>", function()
                    return vim.fn["codeium#Clear"]()
                end, { expr = true, silent = true })
            end,
        }
    end,
}
