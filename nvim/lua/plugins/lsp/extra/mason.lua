local M = {
	"williamboman/mason.nvim",
	cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
}

function M.config()
	require("mason").setup {
		ui = {

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
end

return M
