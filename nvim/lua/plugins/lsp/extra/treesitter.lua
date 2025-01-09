local ts_langs = {
	-- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
	"bash",
	"c",
	"cmake",
	"comment",
	"cpp",
	"css",
	"dart",
	"diff",
	"dockerfile",
	"git_rebase",
	"gitattributes",
	"gitcommit",
	"gitignore",
	"go",
	"gomod",
	"gosum",
	"gowork",
	"graphql",
	"html",
	"ini",
	"javascript",
	"json",
	"json5",
	"jsonc",
	"latex",
	"lua",
	"luap",
	"make",
	"markdown",
	"markdown_inline",
	"php",
	"prisma",
	"python",
	"regex",
	"ruby",
	"rust",
	"scss",
	"smali",
	"sql",
	"svelte",
	"swift",
	"toml",
	"tsx",
	"typescript",
	"vim",
	"vue",
	"yaml",
	"zig",
}

return {
	-- 彩虹分隔符
	{
		"HiPhish/rainbow-delimiters.nvim",
		lazy = true,
		opts = function(_, opts)
			-- This module contains a number of default definitions

			vim.g.rainbow_delimiters = {
				strategy = {
					[""] = opts.strategy["global"],
					vim = opts.strategy["local"],
				},
				query = {
					[""] = "rainbow-delimiters",
					lua = "rainbow-blocks",
					html = "rainbow-tags",
					javascript = "rainbow-delimiters-react",
				},
				highlight = {
					"RainbowYellow",
					"RainbowLightGreen",
					"RainbowViolet",
					"RainbowBlue",
					"RainbowLightGreen",
					"RainbowCyan",
					"RainbowViolet",
				},
			}
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = ts_langs,
			auto_install = true,
			sync_install = true,
			ignore_install = {},
			modules = {},

			highlight = { enable = true, additional_vim_regex_highlighting = false },
			autotag = {
				enable = true,
			},
			indent = { enable = true },
			context_commentstring = { enable = true, enable_autocmd = false },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<CR>",
					node_incremental = "<CR>",
					scope_incremental = false,
					node_decremental = "<S-CR>",
				},
			},
			textobjects = {
				select = {
					enabled = true,
					lookahead = true,
					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						["[f"] = "@function.outer",
						["]f"] = "@function.inner",
						["[c"] = "@class.outer",
						["]c"] = "@class.inner",
					},
					include_surrounding_whitespace = true,
				},
			},
		},
	},
}
