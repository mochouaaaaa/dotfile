local M = {
    "pmizio/typescript-tools.nvim",
    event = "VeryLazy",
    ft = { "*.ts", "*.tsx", "*.jsx" },
}

function M.config()
    local api = require("typescript-tools.api")
    require("typescript-tools").setup({
        handlers = {
            -- ["textDocument/publishDiagnostics"] = api.filter_diagnostics, -- Ignore 'This may be converted to an async function' diagnostics. { 6133 },
        },
        settings = {
            tsserver_file_preferences = {
                importModuleSpecifierPreference = "non-relative",
            },
        },
    })

    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = { "*.ts", "*.tsx", "*.jsx" },
        callback = function(args)
            vim.cmd("TSToolsAddMissingImports sync")
            vim.cmd("TSToolsOrganizeImports sync")
            require("conform").format({ bufnr = args.buf })
        end,
    })
end

return M
