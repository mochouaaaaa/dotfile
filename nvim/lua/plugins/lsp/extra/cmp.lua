local LuaSnip = {
	"L3MON4D3/LuaSnip",
	build = vim.fn.has("win32") == 0
			and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build\n'; make install_jsregexp"
		or nil,
	lazy = true,
	dependencies = { "rafamadriz/friendly-snippets", "saadparwaiz1/cmp_luasnip" },
	opts = {
		history = true,
		delete_check_events = "TextChanged",
		region_check_events = "CursorMoved",
	},
	config = require("plugins.configs.luasnip"),
}

local nvim_cmp = {
	"hrsh7th/nvim-cmp",
	event = { "InsertEnter", "CmdlineEnter" },
	dependencies = {
		{
			"zbirenbaum/copilot.lua",
			build = ":Copilot auth",
			cmd = "Copilot",
			event = { "InsertEnter", "LspAttach" },
			enabled = true,
			config = function()
				require("copilot").setup {
					panel = {
						enabled = false,
						auto_refresh = false,
						keymap = {
							jump_prev = "[[",
							jump_next = "]]",
							accept = "<Tab>",
							refresh = "gr",
							open = "<M-CR>",
						},
						layout = {
							position = "right",
							ratio = 0.4,
						},
					},
					filetypes = {
						yaml = false,
						markdown = false,
						help = false,
						gitcommit = false,
						gitrebase = false,
						hgcommit = false,
						svn = false,
						cvs = false,
					},
					suggestion = {
						enabled = true,
						auto_trigger = true,
						debounce = 75,
						keymap = {
							accept = false,
							next = "<A-j>",
							prev = "<A-k>",
							dismiss = false,
						},
					},
				}

				local copilot_suggestion = require("copilot.suggestion")

				vim.keymap.set("i", "<Tab>", function()
					if copilot_suggestion.is_visible() then
						copilot_suggestion.accept()
					else
						vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
						-- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, true, true), "n", true)
					end
				end, { silent = true, buffer = bufnr, desc = "copilot accept" })

				-- hide copilot suggestions when cmp menu is open
				-- to prevent odd behavior/garbled up suggestions
				local cmp_status_ok, cmp = pcall(require, "cmp")
				if cmp_status_ok then
					cmp.event:on("menu_opened", function() vim.b.copilot_suggestion_hidden = true end)

					cmp.event:on("menu_closed", function() vim.b.copilot_suggestion_hidden = false end)
				end
			end,
		},
		{
			"zbirenbaum/copilot-cmp",
			event = { "InsertEnter", "LspAttach" },
			fix_pairs = true,
			enabled = true,
			config = function() require("copilot_cmp").setup() end,
		},
		{
			"Exafunction/codeium.nvim",
			event = { "InsertEnter", "LspAttach" },
			dependencies = {
				"hrsh7th/nvim-cmp",
			},
			build = "Codeium Auth",
			config = function()
				vim.g.codeium_disable_bindings = 1
				require("codeium").setup {}
			end,
		},
		{ "hrsh7th/cmp-buffer" },
		{ "hrsh7th/cmp-nvim-lsp" },
		{ "hrsh7th/cmp-path" },
		{ "hrsh7th/cmp-cmdline", event = { "InsertEnter", "LspAttach" } },
		{ "dmitmel/cmp-cmdline-history", event = { "InsertEnter", "LspAttach" } },
	},
}

local default_source = {
	-- Copilot source
	{ name = "copilot", group_index = 2 },
	{ name = "codeium", group_index = 2, max_item_count = 5 },
	-- Other source
	{ name = "nvim_lsp", priority = 1000 },
	{ name = "luasnip", priority = 750, max_item_count = 4 },
	{ name = "buffer", priority = 500, max_item_count = 5 },
	{ name = "path", priority = 250 },
	{ name = "emoji", priority = 50 },
}

nvim_cmp.opts = function()
	local cmp = require("cmp")

	local snip_status_ok, luasnip = pcall(require, "luasnip")

	lspkind = require("plugins.configs.lspkind")

	-- backgroud-color
	vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
	-- window border
	local border_opts = {
		border = "rounded",
	}

	local has_words_before = function()
		if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
			return false
		end
		local line, col = unpack(vim.api.nvim_win_get_cursor(0))
		return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
	end

	cmp.setup.cmdline(":", {
		completion = {
			completeopt = "menu,menuone,noselect",
		},
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources {
			{ name = "path" },
			{ name = "cmdline" },
		},
	})

	cmp.setup.cmdline("/", {
		mapping = cmp.mapping.preset.cmdline(),
		completion = {
			completeopt = "menu,menuone,noselect",
		},
		sources = {
			{ name = "buffer" },
		},
	})
	cmp.setup.filetype({ "TelescopePrompt" }, {
		sources = {},
	})

	return {
		presselect = cmp.PreselectMode.None,
		mapping = {
			["<A-Space>"] = cmp.mapping.complete(),
			["<C-u>"] = cmp.mapping.scroll_docs(-4),
			["<C-d>"] = cmp.mapping.scroll_docs(4),
			["<CR>"] = cmp.mapping.confirm {},
			["<S-CR>"] = cmp.mapping.confirm {
				behavior = cmp.ConfirmBehavior.Replace,
				select = true,
			},
			["<A-e>"] = cmp.mapping {
				i = cmp.mapping.abort(),
				c = cmp.mapping.close(),
			},
			["<Tab>"] = vim.schedule_wrap(function(fallback)
				if cmp.visible() and has_words_before() then
					cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
				-- elseif has_words_before() then
				-- 	cmp.complete()
				else
					fallback()
				end
			end),
			["<S-Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				else
					fallback()
				end
			end, { "i", "s" }),
			["<A-k>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
			["<A-j>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
		},
		window = {
			completion = cmp.config.window.bordered(border_opts),
			documentation = cmp.config.window.bordered(border_opts),
		},
		experimental = {
			ghost_text = { hl_group = "Comment" },
		},
		matching = {
			disallow_fuzzy_matching = true,
			disallow_fullfuzzy_matching = true,
			disallow_partial_fuzzy_matching = false,
			disallow_partial_matching = false,
			disallow_prefix_unmatching = true,
		},
		preselect = cmp.PreselectMode.None,
		sorting = {
			comparators = {
				function()
					local ok, cop = pcall(require, "copilot_cmp")
					if ok then
						return cop.prioritize
					end
				end,
				-- require("copilot_cmp.comparators").prioritize,
				--
				cmp.config.compare.sort_text,
				cmp.config.compare.offset,
				cmp.config.compare.exact,
				cmp.config.compare.score,
				cmp.config.compare.kind,
				cmp.config.compare.length,
				cmp.config.compare.order,
				cmp.config.compare.recently_used,
			},
		},
		completion = {
			completeopt = "menu,menuone,noinsert", -- remove default noselect
		},
		formatting = {
			fields = { "kind", "abbr", "menu" },
			format = lspkind,
		},
		snippet = {
			expand = function(args)
				if snip_status_ok then
					luasnip.lsp_expand(args.body)
				end
			end,
		},
		confirm_opts = {
			behavior = cmp.ConfirmBehavior.Replace,
			select = false,
		},
		sources = default_source,
	}
end

return {
	LuaSnip,
	nvim_cmp,
}
