local function is_pinned(buf)
	for _, e in ipairs(require("bufferline").get_elements().elements or {}) do
		if e.id == buf.bufnr then
			return require("bufferline.groups")._is_pinned(e)
		end
	end

	return false
end

local _key = require("util.keymap")

return {
	"akinsho/bufferline.nvim",
	event = "BufRead",
	dependencies = {
		"echasnovski/mini.bufremove",
	},
	keys = {
		{
			_key.platform_key.cmd .. "-w>",
			function()
				local bd = require("mini.bufremove").delete
				if vim.bo.modified then
					local choice =
						vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
					if choice == 1 then -- Yes
						vim.cmd.write()
						bd(0)
					elseif choice == 2 then -- No
						bd(0, true)
					end
				else
					bd(0)
				end
			end,
			desc = "Close Buffer",
		},
		{
			"<leader>bD",
			function()
				require("mini.bufremove").delete(0, true)
			end,
			desc = "Delete Buffer (Force)",
		},
		{ "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "close all other visible buffers" },
		-- 左右切换
		{ "<S-h>", "<Cmd>BufferLineCyclePrev<CR>", desc = "swap right buffer" },
		{ "<S-l>", "<Cmd>BufferLineCycleNext<CR>", desc = "swap left buffer" },
		{ "<A-1>", "<cmd>BufferLineGoToBuffer 1<cr>", desc = "Buffer 1" },
		{ "<A-2>", "<cmd>BufferLineGoToBuffer 2<cr>", desc = "Buffer 2" },
		{ "<A-3>", "<cmd>BufferLineGoToBuffer 3<cr>", desc = "Buffer 3" },
		{ "<A-4>", "<cmd>BufferLineGoToBuffer 4<cr>", desc = "Buffer 4" },
		{ "<A-5>", "<cmd>BufferLineGoToBuffer 5<cr>", desc = "Buffer 5" },
		{ "<A-6>", "<cmd>BufferLineGoToBuffer 6<cr>", desc = "Buffer 6" },
		{ "<A-7>", "<cmd>BufferLineGoToBuffer 7<cr>", desc = "Buffer 7" },
		{ "<A-8>", "<cmd>BufferLineGoToBuffer 8<cr>", desc = "Buffer 8" },
		{ "<A-9>", "<cmd>BufferLineGoToBuffer 9<cr>", desc = "Buffer 9" },
	},
	opts = function()
		return {
			-- highlights = require("catppuccin.groups.integrations.bufferline").get(),
			highlights = {
				buffer_visible = {
					bg = vim.api.nvim_get_hl(0, { name = "BufferLineBufferVisible", link = false }).bg,
				},
				buffer_selected = {
					bg = vim.api.nvim_get_hl(0, { name = "BufferLineBufferSelected", link = false }).bg,
				},
				background = {
					bg = vim.api.nvim_get_hl(0, { name = "BufferLineBackground", link = false }).bg
						or vim.api.nvim_get_hl(0, { name = "Normal", link = false }).bg,
				},
			},
			options = {
				themable = true,

				show_buffer_close_icons = false,
				show_close_icon = false,
				show_tab_indicators = true,
				always_show_bufferline = true,
				buffer_close_icon = "",
				close_icon = "",

				close_command = function(n)
					require("mini.bufremove").delete(n, false)
				end,
				right_mouse_command = function(n)
					require("mini.bufremove").delete(n, false)
				end,

				modified_icon = "",
				truncate_names = false,
				name_formatter = function(buf)
					local short_name = vim.fn.fnamemodify(buf.name, ":t:r")
					return is_pinned(buf) and "" or short_name
				end,
				tab_size = 0,
				separator_style = { "", "" },
				indicator = {
					icon = "",
					style = "none",
				},
				offsets = {},
				diagnostics = false,
				diagnostics_update_in_insert = false,
				diagnostics_indicator = nil,
				groups = {
					items = {
						require("bufferline.groups").builtin.pinned:with({ icon = "󱂺" }),
					},
				},
				hover = { enabled = false },
			},
		}
	end,
}
