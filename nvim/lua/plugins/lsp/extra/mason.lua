local M = {
    "williamboman/mason.nvim",
    cmd = {
        "Mason",
        "MasonInstall",
        "MasonUninstall",
        "MasonUninstallAll",
        "MasonLog",
    },
}

M.opts = {
    ensure_installed = {
        -- Lua
        "lua-language-server", -- language server
        "stylua", -- formatter
        "luacheck", -- linter

        -- Golang
        "gopls", -- language server
        "goimports", -- formatter
        "revive", -- linter

        -- Python
        -- "pyright",
        "basedpyright",
        "isort",
        "black",
        -- "ruff_format",

        -- Rust
        "rust-analyzer", -- language server

        -- Shell
        "bash-language-server", -- language server
        "shfmt", -- formatting

        -- FE
        "typescript-language-server", -- TypeScript language server
        "css-lsp", -- CSS language server
        "json-lsp", -- JSON language server
        "tailwindcss-language-server", -- Tailwind language server
        -- "prettier", -- formatter
        "prettierd",
        -- "eslint-lsp", -- linter
        "stylelint", -- linter
        "eslint_d",
        "prisma-language-server",

        -- XML
        "html-lsp", -- HTML language server
        "taplo", -- TOML language server
        "yaml-language-server", -- YAML language server
        "lemminx", -- XML language server

        -- Docker
        "dockerfile-language-server",
        "docker-compose-language-service",

        -- GitHub Action
        "actionlint", -- linter

        -- Misc
        "cspell", -- spell checker
        "marksman", -- Markdown language server
        "sqlls", -- SQL language server
    },

    max_concurrent_installers = 10,

    ui = {
        border = vim.g.border.style,
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
        },
        keymaps = {
            -- Keymap to expand a package
            toggle_package_expand = "<Tag>",
            -- Keymap to install the package under the current cursor position
            install_package = "i",
            -- Keymap to reinstall/update the package under the current cursor position
            update_package = "u",
            -- Keymap to check for new version for the package under the current cursor position
            check_package_version = "<Nop>",
            -- Keymap to update all installed packages
            update_all_packages = "U",
            -- Keymap to check which installed packages are outdated
            check_outdated_packages = "<Nop>",
            -- Keymap to uninstall a package
            uninstall_package = "x",
            -- Keymap to cancel a package installation
            cancel_installation = "<C-c>",
            -- Keymap to apply language filter
            apply_language_filter = "<C-f>",
        },
    },
}

M.dependencies = {
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        opts = { ensure_installed = M.opts.ensure_installed, auto_update = true },
    },
}

return M
