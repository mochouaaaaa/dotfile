local M = {
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && yarn install",
        lazy = true,
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
        config = function()
            local wk = require("which-key")
            wk.add({
                { "<leader>m", group = "Markdown" },
                { "<leader>ms", "<Cmd>MarkdownPreview<CR>", desc = "markdown server start" },
                { "<leader>mt", "<Cmd>MarkdownPreviewStop<CR>", desc = "markdown server stop" },
                { "<leader>ml", "<Cmd>MarkdownPreviewToggle<CR>", desc = "markdown server toggle" },
            })
        end,
    },
    -----------------------------
    {
        "lukas-reineke/headlines.nvim",
        lazy = true,
        ft = { "markdown", "md", "norg" },
        config = function()
            require("headlines").setup({})
        end,
    },
}

return M
