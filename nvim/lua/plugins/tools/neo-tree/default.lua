local utils = require("util.keymap")

return {
	"nvim-neo-tree/neo-tree.nvim",
	opts = {
		auto_clean_after_session_restore = true,
		close_if_last_window = true,
		sort_case_insensitive = true,
		popup_border_style = vim.g.border.style,
		event_handlers = {
			-- {
			-- 	event = "file_opened",
			-- 	handler = function(file_path)
			-- 		require("neo-tree.sources.filesystem").reset_search(state)
			-- 	end,
			-- },
			{
				event = "neo_tree_buffer_enter",
				handler = function()
					vim.cmd("highlight! Cursor blend=100")
				end,
			},
			{
				event = "neo_tree_buffer_leave",
				handler = function()
					vim.cmd("highlight! Cursor guibg=#5f87af blend=0")
				end,
			},
		},
		filesystem = {
			use_libuv_file_watcher = true,
			window = {
				mappings = {
					["o"] = "system_open",
				},
			},
		},
		commands = {
			system_open = function(state)
				local node = state.tree:get_node()
				local path = node:get_id()
				-- macOs: open file in default application in the background.
				vim.fn.jobstart({ "open", path }, { detach = true })
				-- Linux: open file in default application
				vim.fn.jobstart({ "xdg-open", path }, { detach = true })

				-- Windows: Without removing the file from the path, it opens in code.exe instead of explorer.exe
				local p
				local lastSlashIndex = path:match("^.+()\\[^\\]*$") -- Match the last slash and everything before it
				if lastSlashIndex then
					p = path:sub(1, lastSlashIndex - 1) -- Extract substring before the last slash
				else
					p = path -- If no slash found, return original path
				end
				vim.cmd("silent !start explorer " .. p)
			end,
		},
	},
	keys = function()
		return {
			{
				utils.platform_key.cmd .. "-e>",
				"<Cmd>Neotree toggle<CR>",
				mode = "n",
			},
			{
				"<leader>eg",
				"<Cmd>Neotree git_status<CR>",
				mode = "n",
				desc = "Toggle git status in neo-tree",
			},
		}
	end,
}
