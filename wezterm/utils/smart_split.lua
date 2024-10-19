local csi = require("utils.keymap_csi")
local utils = require("utils.string")
local w = require("wezterm")

local M = {}

local function is_vim(pane) return pane:get_user_vars().IS_NVIM == "true" end
local function is_tmux(pane) return pane:get_user_vars().WEZTERM_IN_TMUX == "1" end
local function is_wezterm(pane) return pane:get_user_vars().IS_WEZTERM == "1" end

local direction_keys = {
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}

local GLOBAL_KEY = {
	CMD_Enter = "CTRL+a->z",
	CMD_t = "CTRL+a->c",
	CMD_1 = "CTRL+a->1",
	CMD_2 = "CTRL+a->2",
	CMD_3 = "CTRL+a->3",
	CMD_4 = "CTRL+a->4",
	CMD_5 = "CTRL+a->5",
	CMD_6 = "CTRL+a->6",

	CMD_SHIFT_k = "CTRL+a->,",
	CTRL_f = "CTRL+a->CTRL+f",
}

-- action: execute action in wezterm shell
-- nvim_run: Execute action in neovim
function M.wezterm_tmux_nvim(key, mods, action, nvim_run)
	return {
		key = key,
		mods = mods,
		action = w.action_callback(function(win, pane)
			print(pane:get_user_vars())
			local csi_keymap = csi.get_csi_sequence(key, mods)

			-- tmux
			if is_tmux(pane) then
				local keymap = GLOBAL_KEY[(mods .. "_" .. key):gsub("|", "_")]

				-- send shortcuts to tmux
				if keymap == nil then
					win:perform_action({ SendString = csi_keymap }, pane)
				else
					-- call tmux shell command
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
				end

			-- nvim
			elseif is_vim(pane) then
				if nvim_run == true then
					win:perform_action(action, pane)
				else
					win:perform_action({ SendString = csi_keymap }, pane)
				end

			-- wezterm shell
			elseif is_wezterm(pane) or action then
				win:perform_action(action, pane)
			end
		end),
	}
end

function M.SendKey2TmuxOrNvim(key, mods, action)
	local default_action = {
		key = key,
		mods = mods,
	}

	default_action.action = w.action_callback(function(win, pane)
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
		elseif is_wezterm(pane) or action then
			win:perform_action(action, pane)
		elseif is_vim(pane) then
			win:perform_action({ SendString = csi_keymap }, pane)
		end
	end)

	return default_action
end

return M
