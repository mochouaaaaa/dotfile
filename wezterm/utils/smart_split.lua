local csi = require("utils.keymap_csi")
local utils = require("utils.string")
local w = require("wezterm")

local M = {}

local function is_vim(pane) return pane:get_user_vars().IS_NVIM == "true" end
local function is_tmux(pane) return pane:get_user_vars().WEZTERM_IN_TMUX == "1" end

local direction_keys = {
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}

function M.wezterm_nvim(operation, key, mods)
	return {
		key = key,
		mods = mods,
		action = w.action_callback(function(win, pane)
			-- run tmux or nvim
			if is_vim(pane) or is_tmux(pane) then
				-- pass the keys through to vim/nvim
				-- win:perform_action({ SendKey = { key = key, mods = mods } }, pane)
				local csi_keymap = csi.get_csi_sequence(key, mods)
				win:perform_action({ SendString = csi_keymap }, pane)
			else
				if operation == "resize" then
					win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
				elseif operation == "move" then
					win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
				elseif operation == "split" then
					win:perform_action({ SplitPane = { direction = direction_keys[key] } }, pane)
				elseif operation == "close_tab" then
					win:perform_action({ CloseCurrentPane = { confirm = false } }, pane)
				end
			end
		end),
	}
end

local GLOBAL_KEY = {
	CMD_Enter = "CTRL+a->z",
}

function M.SendKey2TmuxOrNvim(key, mods, action)
	return {
		key = key,
		mods = mods,
		action = w.action_callback(function(win, pane)
			local csi_keymap = csi.get_csi_sequence(key, mods)

			if is_tmux(pane) then
				local keymap = GLOBAL_KEY[(mods .. "_" .. key):gsub("|", "_")]

				-- tmux shell
				if keymap == nil then
					win:perform_action({ SendString = csi_keymap }, pane)
					return nil
				end

				local result = utils.Split(keymap, "->")

				for _, v in ipairs(result) do
					if string.find(v, "+") then
						local tmp = utils.Split(v, "+")
						csi_keymap = csi.get_csi_sequence(tmp[2], tmp[1])

						win:perform_action({ SendString = csi_keymap }, pane)
					else
						win:perform_action({ SendKey = { key = v } }, pane)
					end
				end
				return nil
			elseif action then
				win:perform_action(action, pane)
			else
				win:perform_action({ SendString = csi_keymap }, pane)
			end
			return nil
		end),
	}
end

return M
