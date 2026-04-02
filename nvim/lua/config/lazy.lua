vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- disabled default keymaps
-- package.loaded["lazyvim.config.options"] = true
-- package.loaded["lazyvim.config.mappings"] = true

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

require("config.init")

require("lazy").setup({
	spec = {
		-- { "nvim-lua/plenary.nvim" },
		{
			"LazyVim/LazyVim",
			import = "lazyvim.plugins",
			opts = {
				colorscheme = "catppuccin",
			},
		},

		-- custom plugins
		{ import = "plugins" },

		-- disabled
		{ "folke/tokyonight.nvim", enabled = false },
		{ "nvim-lualine/lualine.nvim", enabled = false },
		{ "akinsho/bufferline.nvim", enabled = false },
	},
	ui = {
		border = "rounded",
		backdrop = 100,
	},
	defaults = {
		lazy = false,
		version = false, -- 永远使用最新的 git commit 版本
		-- keymaps = false,
	},
	checker = { enabled = false }, -- 自动检查插件更新
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
