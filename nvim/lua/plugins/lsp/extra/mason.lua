local M = {
    "williamboman/mason.nvim",
    cmd = {
        "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll",
        "MasonLog"
    }
}

M.opts = {
    ensure_installed = {
        "stylua", "shfmt"
        -- "flake8",
    },

    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
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
            apply_language_filter = "<C-f>"
        }
    }
}

---@param opts MasonSettings | {ensure_installed: string[]}
function M.config(_, opts)
    require("mason").setup(opts)
    local mr = require("mason-registry")
    mr:on("package:install:success", function()
        vim.defer_fn(function()
            -- trigger FileType event to possibly load this newly installed LSP server
            require("lazy.core.handler.event").trigger({
                event = "FileType",
                buf = vim.api.nvim_get_current_buf()
            })
        end, 100)
    end)
    local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
            local p = mr.get_package(tool)
            if not p:is_installed() then p:install() end
        end
    end
    if mr.refresh then
        mr.refresh(ensure_installed)
    else
        ensure_installed()
    end
end

return M
