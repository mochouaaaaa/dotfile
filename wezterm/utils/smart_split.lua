local w = require("wezterm")
local act = w.action

local M = {}

-- if you are *NOT* lazy-loading smart-splits.nvim (recommended)
local function is_vim(pane)
	-- this is set by the plugin, and unset on ExitPre in Neovim
	return pane:get_user_vars().IS_NVIM == "true"
end

function M.is_inside_vim(pane)
	local tty = pane:get_tty_name()
	if tty == nil then
		return false
	end

	local success, _, _ = w.run_child_process {
		"sh",
		"-c",
		"ps -o state= -o comm= -t"
			.. w.shell_quote_arg(tty)
			.. " | "
			.. "grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?)(diff)?$'",
	}

	return success
end

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
			if is_vim(pane) then
				-- pass the keys through to vim/nvim
				-- win:perform_action(act.SendKey { key = key, mods = mods }, pane)
				w.log_info("Sending keys to vim: " .. key .. " " .. mods)
				win:perform_action(act.SendKey { key = "\x1bl" }, pane)
			else
				if operation == "resize" then
					win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
				elseif operation == "move" then
					win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
				end
			end
		end),
	}
end

function M.SendKey(key, mods)
	return {
		key = key,
		mods = mods,
		action = w.action_callback(
			function(win, pane) win:perform_action(act.SendKey { key = key, mods = mods }, pane) end
		),
	}
end

return M
