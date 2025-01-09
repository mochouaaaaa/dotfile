vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 0.9 版本开始自带缓存加速
vim.loader.enable()

-- disabled default keymaps
package.loaded["lazyvim.config.options"] = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

-- Set border style
local enable_border = not vim.g.neovide
vim.g.border = {
	enabled = enable_border,
	style = enable_border and "rounded" or { " " },
	borderchars = enable_border and { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
		or { " ", " ", " ", " ", " ", " ", " ", " " },
}

require("config.icons")

require("lazy").setup({
	spec = {
		{ "nvim-lua/plenary.nvim" },
		{ "folke/lazy.nvim", version = false },
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
		{ "nvim-lualine/lualine.nvim", enabled = false },
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

-- require("config.init")
