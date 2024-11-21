local M = {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {
        enabled = true,
        input_after_comment = true,
        snippet_engine = "luasnip",
        languages = {
            python = {
                template = {
                    annotation_convention = "numpydoc",
                },
            },
        },
    },
}

function M.config(_, opts)
    require("neogen").setup(opts)
    vim.keymap.set("n", "<Leader>nc", function()
        require("neogen").generate({ type = "class" })
    end, { noremap = true, silent = true, desc = "class annotation" })
    vim.keymap.set("n", "<Leader>nf", function()
        require("neogen").generate({ type = "func" })
    end, { noremap = true, silent = true, desc = "function annotation" })
end

return M
