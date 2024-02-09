local Util = require("lazyvim.util")

local M = {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		{
			"debugloop/telescope-undo.nvim",
			config = function()
				Util.on_load("telescope.nvim", function() require("telescope").load_extension("undo") end)
			end,
		},
		{
			"gbrlsnchs/telescope-lsp-handlers.nvim",
			config = function()
				Util.on_load("telescope.nvim", function() require("telescope").load_extension("lsp_handlers") end)
			end,
		},
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			config = function()
				Util.on_load("telescope.nvim", function() require("telescope").load_extension("fzf") end)
			end,
		},
		{
			"nvim-telescope/telescope-ui-select.nvim",
			config = function()
				Util.on_load("telescope.nvim", function() require("telescope").load_extension("ui-select") end)
			end,
		},
		{
			"nvim-telescope/telescope-dap.nvim",
			config = function()
				Util.on_load("telescope.nvim", function() require("telescope").load_extension("dap") end)
			end,
		},
		{
			"nvim-telescope/telescope-file-browser.nvim",
			config = function()
				Util.on_load("telescope.nvim", function() require("telescope").load_extension("file_browser") end)
			end,
		},
	},
}

function M.opts(_, opts)
	if not Util.has("flash.nvim") then
		return
	end
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
	opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
		mappings = { n = { s = flash }, i = { ["<c-s>"] = flash } },
	})
end

return M
