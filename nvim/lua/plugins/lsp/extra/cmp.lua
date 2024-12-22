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
	config = require("util.luasnip"),
}

local _key = require("util.keymap")

local nvim_cmp = {
	"hrsh7th/nvim-cmp",
	event = { "InsertEnter", "CmdlineEnter" },
	dependencies = {
		{ "hrsh7th/cmp-buffer" },
		{ "hrsh7th/cmp-nvim-lsp" },
		{ "hrsh7th/cmp-path" },
	},
}

local require_file = vim.fn.globpath(vim.fn.stdpath("config") .. "/lua/util/code", "*.lua", false, true)
for _, file in ipairs(require_file) do
	local module_name = file:match("(/util/.*)%.lua$")
	local module = require(module_name)
	if module.enabled then
		table.insert(nvim_cmp.dependencies, module.config(_key))
	end
end

local default_source = {
	-- Other source
	{ name = "nvim_lsp", priority = 1000, keyword_length = 1 },
	{ name = "luasnip", keyword_length = 2 },
	{ name = "buffer", priority = 500, keyword_length = 3 },
	{ name = "path", priority = 250 },
}

nvim_cmp.opts = function()
	local cmp = require("cmp")

	local snip_status_ok, luasnip = pcall(require, "luasnip")

	lspkind = require("util.lspkind").lspkind

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
		enabled = function()
			return not require("util.code.fittencode").has_suggestions()
		end,
		presselect = cmp.PreselectMode.None,
		mapping = {
			["<A-Space>"] = cmp.mapping.complete(),
			["<C-u>"] = cmp.mapping.scroll_docs(-4),
			["<C-d>"] = cmp.mapping.scroll_docs(4),
			["<CR>"] = cmp.mapping.confirm({}),
			["<S-CR>"] = cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Replace,
				select = true,
			}),
			[_key.platform_key.cmd .. "-e>"] = cmp.mapping({
				i = cmp.mapping.abort(),
				c = cmp.mapping.close(),
			}),
			["<Tab>"] = vim.schedule_wrap(function(fallback)
				if cmp.visible() and has_words_before() then
					cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
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
			[_key.platform_key.cmd .. "-k>"] = cmp.mapping.select_prev_item({
				behavior = cmp.SelectBehavior.Select,
			}),
			[_key.platform_key.cmd .. "-j>"] = cmp.mapping.select_next_item({
				behavior = cmp.SelectBehavior.Select,
			}),
		},
		window = {
			completion = cmp.config.window.bordered(vim.g.border.style),
			documentation = cmp.config.window.bordered(vim.g.border.style),
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
