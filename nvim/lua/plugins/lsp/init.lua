return {
	{
		"smjonas/inc-rename.nvim",
		config = function() require("inc_rename").setup() end,
	},
	{
		"aznhe21/actions-preview.nvim",
		config = function()
			local hl = require("actions-preview.highlight")
			require("actions-preview").setup {
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
						preview_height = function(_, _, max_lines) return max_lines - 15 end,
					},
				},
			}
		end,
	},
	{
		"Wansmer/symbol-usage.nvim",
		config = function()
			vim.api.nvim_create_autocmd({ "LspDetach" }, {
				callback = function(ev) vim.fn.sign_unplace("SymbolUsage") end,
			})

			vim.fn.sign_define("SymbolUsageRef", { text = "󰌹", texthl = "", linehl = "", numhl = "" })
			vim.fn.sign_define("SymbolUsageDef", { text = "󰳽", texthl = "", linehl = "", numhl = "" })
			vim.fn.sign_define("SymbolUsageImpl", { text = "", texthl = "", linehl = "", numhl = "" })

			local function signcolumn_format(symbol)
				local ns_id = vim.api.nvim_get_namespaces()["__symbol__"]
				local emark = vim.api.nvim_buf_get_extmark_by_id(0, ns_id, symbol.mark_id, { details = false })
				local buf = vim.api.nvim_get_current_buf()

				vim.fn.sign_unplace("SymbolUsage", { buffer = buf, id = symbol.mark_id }) -- not sure if it's necessary

				if #emark > 0 then
					if symbol.references then
						vim.fn.sign_place(
							symbol.mark_id,
							"SymbolUsage",
							"SymbolUsageRef",
							buf,
							{ lnum = emark[1] + 1, priority = 11 }
						)
					end

					if symbol.definition then
						vim.fn.sign_place(
							symbol.mark_id,
							"SymbolUsage",
							"SymbolUsageDef",
							buf,
							{ lnum = emark[1] + 1, priority = 11 }
						)
					end

					if symbol.implementation > 0 then
						vim.fn.sign_place(
							symbol.mark_id,
							"SymbolUsage",
							"SymbolUsageImpl",
							buf,
							{ lnum = emark[1] + 1, priority = 11 }
						)
					end
				end

				return ""
			end
			require("symbol-usage").setup {
				request_pending_text = "",
				implementation = { enabled = true },
				definition = { enabled = false },
				references = { enabled = false },
				text_format = signcolumn_format,
				vt_position = "end_of_line",
				symbol_request_pos = "end",
			}
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
