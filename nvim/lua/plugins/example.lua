-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the uration of LazyVim plugins
_G.lazyvim_util = require("lazyvim.util")

return {
	{
		"mrjones2014/smart-splits.nvim",
		build = "./kitty/install-kittens.bash",
		config = function()
			local smart_splits = require("smart-splits")

			smart_splits.setup({
				-- Ignored filetypes (only while resizing)
				ignored_filetypes = {
					"nofile",
					"quickfix",
					"prompt",
				},
				-- when moving cursor between splits left or right,
				-- place the cursor on the same row of the *screen*
				-- regardless of line numbers. False by default.
				-- Can be overridden via function parameter, see Usage.
				move_cursor_same_row = false,
				-- whether the cursor should follow the buffer when swapping
				-- buffers by default; it can also be controlled by passing
				-- `{ move_cursor = true }` or `{ move_cursor = false }`
				-- when calling the Lua function.
				cursor_follows_swapped_bufs = false,
				-- resize mode options
				-- resize mode options
				resize_mode = {
					-- key to exit persistent resize mode
					quit_key = "<ESC>",
					-- keys to use for moving in resize mode
					-- in order of left, down, up' right
					resize_keys = { "h", "j", "k", "l" },
					-- set to true to silence the notifications
					-- when entering/exiting persistent resize mode
					silent = false,
				},
				-- Supply a Kitty remote control password if needed,
				-- or you can also set vim.g.smart_splits_kitty_password
				-- see https://sw.kovidgoyal.net/kitty/conf/#opt-kitty.remote_control_password
				kitty_password = "kitty",
			})
			local utils = require("util.keymap")
			local cmd = utils.platform_key.cmd

			vim.keymap.set("n", "<C-S-k>", function()
				smart_splits.resize_up()
			end)
			vim.keymap.set("n", "<C-S-j>", function()
				smart_splits.resize_down()
			end)
			vim.keymap.set("n", "<C-S-h>", function()
				smart_splits.resize_left()
			end)
			vim.keymap.set("n", "<C-S-l>", function()
				smart_splits.resize_right()
			end)

			vim.keymap.set("n", cmd .. "-k>", function()
				smart_splits.move_cursor_up()
			end)
			vim.keymap.set("n", cmd .. "-j>", function()
				smart_splits.move_cursor_down()
			end)
			vim.keymap.set("n", cmd .. "-h>", function()
				smart_splits.move_cursor_left()
			end)
			vim.keymap.set("n", cmd .. "-l>", function()
				smart_splits.move_cursor_right()
			end)

			local mux = require("smart-splits.mux").get()
			if mux ~= nil then
				vim.keymap.set("n", cmd .. "-C-k>", function()
					mux.split_pane("up")
				end)
				vim.keymap.set("n", cmd .. "-C-j>", function()
					mux.split_pane("down")
				end)
				vim.keymap.set("n", cmd .. "-C-h>", function()
					mux.split_pane("left")
				end)
				vim.keymap.set("n", cmd .. "-C-l>", function()
					mux.split_pane("right")
				end)
			end
		end,
	},
}
