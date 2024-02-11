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
	"fish",
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
	"java",
	"javascript",
	"json",
	"json5",
	"jsonc",
	"kdl",
	"latex",
	"lua",
	"luap",
	"make",
	"markdown",
	"markdown_inline",
	"nix",
	"php",
	"pug",
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
		config = function()
			-- This module contains a number of default definitions
			local rainbow_delimiters = require("rainbow-delimiters")

			vim.g.rainbow_delimiters = {
				strategy = {
					[""] = rainbow_delimiters.strategy["global"],
					vim = rainbow_delimiters.strategy["local"],
				},
				query = {
					[""] = "rainbow-delimiters",
					lua = "rainbow-blocks",
					html = "rainbow-tags",
					javascript = "rainbow-delimiters-react",
				},
			}
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		lazy = { "VeryLazy" },
		cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
		init = function(plugin)
			-- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
			-- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
			-- no longer trigger the **nvim-treeitter** module to be loaded in time.
			-- Luckily, the only thins that those plugins need are the custom queries, which we make available
			-- during startup.
			require("lazy.core.loader").add_to_rtp(plugin)
			require("nvim-treesitter.query_predicates")
		end,
		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter-textobjects",
				config = function()
					-- When in diff mode, we want to use the default
					-- vim text objects c & C instead of the treesitter ones.
					local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
					local configs = require("nvim-treesitter.configs")
					for name, fn in pairs(move) do
						if name:find("goto") == 1 then
							move[name] = function(q, ...)
								if vim.wo.diff then
									local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
									for key, query in pairs(config or {}) do
										if q == query and key:find("[%]%[][cC]") then
											vim.cmd("normal! " .. key)
											return
										end
									end
								end
								return fn(q, ...)
							end
						end
					end
				end,
			},
			{
				"windwp/nvim-ts-autotag",
				lazy = true,
				opts = { enable_close_on_slash = false },
			},
		},
		config = function()
			require("nvim-treesitter.configs").setup {
				ensure_installed = ts_langs,
				auto_install = true,
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
						enable = true,
						lookahead = true,
						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
						},
						include_surrounding_whitespace = true,
					},
					lsp_interop = {
						enable = false,
						peek_definition_code = { ["gD"] = "@function.outer" },
					},
				},
			}

			require("nvim-treesitter.install").compilers = { "clang" }
			require("nvim-treesitter.install").prefer_git = true
			-- require("nvim-treesitter.install").command_extra_args = {
			-- 	curl = { "--proxy", "127.0.0.1:7890" },
			-- }
		end,
	},
}
