return {
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	{ "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
	{ -- optional completion source for require statements and module annotations
		"hrsh7th/nvim-cmp",
		opts = function(_, opts)
			opts.sources = opts.sources or {}
			table.insert(opts.sources, {
				name = "lazydev",
				group_index = 0, -- set group index to 0 to skip loading LuaLS completions
			})
		end,
	},
	{
		"smjonas/inc-rename.nvim",
		config = function()
			require("inc_rename").setup()
		end,
	},
	{
		"chrisgrieser/nvim-lsp-endhints",
		event = "LspAttach",
		config = function()
			require("lsp-endhints").setup({
				icons = {
					type = "󰜁 ",
					parameter = "󰏪 ",
					offspec = " ", -- hint kind not defined in official LSP spec
					unknown = " ", -- hint kind is nil
				},
				label = {
					padding = 1,
					marginLeft = 0,
					bracketedParameters = true,
				},
				autoEnableHints = true,
			})
		end,
	},
	{
		"aznhe21/actions-preview.nvim",
		config = function()
			local hl = require("actions-preview.highlight")
			require("actions-preview").setup({
				diff = {
					algorithm = "patience",
					ignore_whitespace = true,
				},
				highlight_command = {
					hl.delta("delta --no-gitconfig --side-by-side"),
					hl.diff_so_fancy("diff-so-fancy", "less -R"),
				},
				telescope = {
					sorting_strategy = "ascending",
					layout_strategy = "vertical",
					layout_config = {
						width = 0.8,
						height = 0.9,
						prompt_position = "top",
						preview_cutoff = 20,
						preview_height = function(_, _, max_lines)
							return max_lines - 15
						end,
					},
				},
			})
		end,
	},
	{
		"windwp/nvim-autopairs",
		dependencies = "hrsh7th/nvim-cmp",
		event = "InsertEnter",
		config = function()
			local npairs = require("nvim-autopairs")
			local Rule = require("nvim-autopairs.rule")
			local cond = require("nvim-autopairs.conds")

			npairs.setup({
				check_ts = true,
				ts_config = {
					lua = { "string", "source" },
					javascript = { "string", "template_string" },
					java = false,
				},
				fast_wrap = {
					chars = { "{", "(", "[", "<", '"', "'", "`" },
					pattern = [=[[%'%"%)%>%]%)%}%,]]=],
					offset = 0,
					end_key = "$",
					keys = "qwertyuiopzxcvbnmasdfghjkl",
					check_comma = true,
					highlight = "Search",
					highlight_grey = "Comment",
				},
				enable_check_bracket_line = true,
				disable_filetype = { "TelescopePrompt", "vim" },
			})

			-- TODO: remove this block when https://github.com/windwp/nvim-autopairs/pull/363 is merged

			npairs.add_rules({
				Rule("<", ">"):with_pair(cond.before_regex("%a+")):with_move(function(o)
					return o.char == ">"
				end),
				Rule(" ", " "):with_pair(function(options)
					local pair = options.line:sub(options.col - 1, options.col)
					return vim.tbl_contains({ "()", "[]", "{}" }, pair)
				end),
				Rule("( ", " )")
					:with_pair(function()
						return false
					end)
					:with_move(function(options)
						return options.prev_char:match(".%)") ~= nil
					end)
					:use_key(")"),
				Rule("{ ", " }")
					:with_pair(function()
						return false
					end)
					:with_move(function(options)
						return options.prev_char:match(".%}") ~= nil
					end)
					:use_key("}"),
				Rule("[ ", " ]")
					:with_pair(function()
						return false
					end)
					:with_move(function(options)
						return options.prev_char:match(".%]") ~= nil
					end)
					:use_key("]"),
			})

			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp_status_ok, cmp = pcall(require, "cmp")

			if not cmp_status_ok then
				return
			end

			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},
	{ import = "plugins.lsp.extra" },
	{ import = "plugins.lsp.extra_lang" },
}
