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
	dependencies = {
		"catppuccin/nvim",
		"echasnovski/mini.bufremove",
	},
	lazy = true,
	keys = function()
		return {
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
		}
	end,
	opts = function()
		local catppuccin_palette = require("catppuccin.palettes")
		return {
			highlights = require("catppuccin.groups.integrations.bufferline").get({
				styles = { "italic", "bold" },
				custom = {
					mocha = {
						fill = { bg = catppuccin_palette.get_palette("mocha").base },
						background = { bg = catppuccin_palette.get_palette("mocha").base },
					},
					latte = {
						fill = { bg = catppuccin_palette.get_palette("latte").base },
						background = { bg = catppuccin_palette.get_palette("latte").base },
					},
				},
			}),
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
