vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- disabled default keymaps
-- package.loaded["lazyvim.config.options"] = true
package.loaded["lazyvim.config.mappings"] = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("config.icons")
require("config.init")

-- Set border style
local enable_border = true
vim.g.border = {
	enabled = enable_border,
	style = enable_border and "rounded" or { " " },
	borderchars = enable_border and { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
		or { " ", " ", " ", " ", " ", " ", " ", " " },
}

require("lazy").setup({
	spec = {
		{ "nvim-lua/plenary.nvim" },
		{
			"LazyVim/LazyVim",
			import = "lazyvim.plugins",
			opts = {
				defaults = {
					keymaps = false,
				},
				colorscheme = "catppuccin",
			},
		},

		-- custom plugins
		{ import = "plugins" },

		-- disabled
		{ "folke/tokyonight.nvim", enabled = false },
		{ "nvim-lualine/lualine.nvim", enabled = false },
		-- { "nvim-ts-autotag", enabled = false },
	},
	ui = {
		border = vim.g.border.style,
		backdrop = 100,
	},
	defaults = {
		lazy = false,
		version = false, -- 永远使用最新的 git commit 版本
		keymaps = false,
	},
	checker = { enabled = true }, -- 自动检查插件更新
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip", -- "matchit",
				-- "matchparen",
				-- "netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})
