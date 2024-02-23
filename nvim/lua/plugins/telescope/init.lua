local function flash(prompt_bufnr)
	require("flash").jump {
		pattern = "^",
		label = { after = { 0, 0 } },
		search = {
			mode = "search",
			exclude = {
				function(win) return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults" end,
			},
		},
		action = function(match)
			local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
			picker:set_selection(match.pos[1] - 1)
		end,
	}
end

local config = function()
	local actions = require("telescope.actions")
	local utils = require("config.utils")

	require("telescope").setup {
		defaults = {
			prompt_prefix = " ",
			selection_caret = " ",
			multi_icon = " ",
			path_display = {
				"smart",
			},
			mappings = {
				i = {
					["C-j>"] = actions.cycle_history_next,
					["C-k>"] = actions.cycle_history_prev,

					["<C-c>"] = actions.close,
					--
					["<Down>"] = actions.move_selection_next,
					["<Up>"] = actions.move_selection_previous,

					["<CR>"] = actions.select_default,
					["<C-s>"] = flash,
					["<C-v>"] = actions.select_vertical,

					[utils.platform_key("cmd") .. "-k>"] = actions.preview_scrolling_up,
					[utils.platform_key("cmd") .. "-j>"] = actions.preview_scrolling_down,

					["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
				},

				n = {
					["<esc>"] = actions.close,
					["<CR>"] = actions.select_default,
					["<s>"] = flash,
					["<C-v>"] = actions.select_vertical,

					["j"] = actions.move_selection_next,
					["k"] = actions.move_selection_previous,

					["<Down>"] = actions.move_selection_next,
					["<Up>"] = actions.move_selection_previous,
					["gg"] = actions.move_to_top,
					["G"] = actions.move_to_bottom,

					[utils.platform_key("cmd") .. "-k>"] = actions.preview_scrolling_up,
					[utils.platform_key("cmd") .. "-j>"] = actions.preview_scrolling_down,

					["?"] = actions.which_key,
				},
			},
			buffer_previewer_maker = function(filepath, bufnr, opts)
				require("plenary.job")
					:new({
						command = "file",
						args = { "-b", "--mime", filepath },
						on_exit = function(j)
							if j:result()[1]:find("charset=binary", 1, true) then
								vim.schedule(function() vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" }) end)
							else
								require("telescope.previewers").buffer_previewer_maker(filepath, bufnr, opts)
							end
						end,
					})
					:sync()
			end,
		},
		pickers = {
			find_files = { previewer = false, theme = "dropdown" },
			live_grep = { theme = "ivy" },

			-- lsp_references = { theme = "ivy" },
			-- lsp_definitions = { theme = "ivy" },
			-- lsp_type_definitions = { theme = "ivy" },
			-- lsp_implementations = { theme = "ivy" },
			-- lsp_dynamic_workspace_symbols = {
			-- 	sorter = telescope.extensions.fzf.native_fzf_sorter(nil),
			-- },
		},
		extensions = {
			fzf = {
				fuzzy = true, -- false will only do exact matching
				override_generic_sorter = true, -- override the generic sorter
				override_file_sorter = true, -- override the file sorter
				case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			},
		},
	}
end

local M = {
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		import = "plugins.telescope.extra",
		config = config,
		keys = require("plugins.telescope.keys"),
	},
	{
		"prochri/telescope-all-recent.nvim",
		lazy = true,
		opts = {},
	},
	{
		import = "plugins.telescope.load_extension",
	},
}

return M
