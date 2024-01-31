return {
	{
		"windwp/nvim-autopairs",
		dependencies = "hrsh7th/nvim-cmp",
		event = "InsertEnter",
		config = function()
			local npairs = require("nvim-autopairs")
			local Rule = require("nvim-autopairs.rule")
			local cond = require("nvim-autopairs.conds")

			npairs.setup {
				check_ts = true,
				ts_config = {
					lua = { "string", "source" },
					javascript = { "string", "template_string" },
				},
				fast_wrap = {
					chars = { "{", "(", "[", "<", '"', "'", "`" },
					pattern = [=[[%'%"%)%>%]%)%}%,]]=],
					end_key = "$",
					keys = "qwertyuiopzxcvbnmasdfghjkl",
					check_comma = true,
					highlight = "Search",
					highlight_grey = "Comment",
				},
				enable_check_bracket_line = true,
				disable_filetype = { "TelescopePrompt", "vim" },
			}

			-- TODO: remove this block when https://github.com/windwp/nvim-autopairs/pull/363 is merged

			npairs.add_rules {
				Rule("<", ">"):with_pair(cond.before_regex("%a+")):with_move(function(o) return o.char == ">" end),
			}

			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp_status_ok, cmp = pcall(require, "cmp")

			if not cmp_status_ok then
				return
			end

			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},
	{ "folke/neodev.nvim" },
	{ import = "plugins.lsp.extra" },
	{ import = "plugins.lsp.extra_lang" },
}
