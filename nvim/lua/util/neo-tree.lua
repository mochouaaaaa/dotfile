local inputs = require("neo-tree.ui.inputs")

return {
	getTelescopeOpts = function(state, path)
		return {
			cwd = path,
			search_dirs = { path },
			attach_mappings = function(prompt_bufnr, map)
				local actions = require("telescope.actions")
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local action_state = require("telescope.actions.state")
					local selection = action_state.get_selected_entry()
					local filename = selection.filename
					if filename == nil then
						filename = selection[1]
					end
					-- any way to open the file without triggering auto-close event of neo-tree?
					require("neo-tree.sources.filesystem").navigate(state, state.path, filename)
				end)
				return true
			end,
		}
	end,
	system_open = function(state)
		local node = state.tree:get_node()
		local path = node:get_id()
		local _key = require("util.keymap")
		if _key.is_mac() then
			-- macOs: open file in default application in the background.
			vim.fn.jobstart({ "open", "-g", path }, { detach = true })
		elseif _key.is_linux() then
			-- Linux: open file in default applications
			vim.fn.jobstart({ "xdg-open", path }, { detach = true })
		end

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
	diff_files = function(state)
		local node = state.tree:get_node()
		local log = require("neo-tree.log")
		state.clipboard = state.clipboard or {}
		if diff_Node and diff_Node ~= tostring(node.id) then
			local current_Diff = node.id
			require("neo-tree.utils").open_file(state, diff_Node, open)
			vim.cmd("vert diffs " .. current_Diff)
			diff_Node = nil
			current_Diff = nil
			state.clipboard = {}
			require("neo-tree.ui.renderer").redraw(state)
		else
			local existing = state.clipboard[node.id]
			if existing and existing.action == "diff" then
				state.clipboard[node.id] = nil
				diff_Node = nil
				require("neo-tree.ui.renderer").redraw(state)
			else
				state.clipboard[node.id] = { action = "diff", node = node }
				diff_Name = state.clipboard[node.id].node.name
				diff_Node = tostring(state.clipboard[node.id].node.id)
				log.info("Diff source file " .. diff_Name)
				require("neo-tree.ui.renderer").redraw(state)
			end
		end
	end,
	trash = function(state)
		local node = state.tree:get_node()
		if node.type == "message" then
			return
		end
		local _, name = require("neo-tree.utils").split_path(node.path)
		local msg = string.format("Are you sure you want to trash '%s'?", name)
		inputs.confirm(msg, function(confirmed)
			if not confirmed then
				return
			end
			vim.api.nvim_command("silent !trash -f " .. node.path)
			require("neo-tree.sources.manager").refresh(state)
		end)
	end,
	trash_visual = function(state, selected_nodes)
		local paths_to_trash = {}
		for _, node in ipairs(selected_nodes) do
			if node.type ~= "message" then
				table.insert(paths_to_trash, node.path)
			end
		end
		local msg = "Are you sure you want to trash " .. #paths_to_trash .. " items?"
		inputs.confirm(msg, function(confirmed)
			if not confirmed then
				return
			end
			for _, path in ipairs(paths_to_trash) do
				vim.api.nvim_command("silent !trash -f " .. path)
			end
			require("neo-tree.sources.manager").refresh(state)
		end)
	end,
}
