local platform = require("utils.platform")()
local wezterm = require("wezterm")
local action = wezterm.action

local mod = {
	CTRL = "CTRL",
	CTRL_S = "CTRL|SHIFT",
}

if platform.is_mac then
	mod.SUPER = "SUPER"
	mod.SUPER_REV = "SUPER|CTRL"
elseif platform.is_win then
	mod.SUPER = "ALT"
	mod.SUPER_REV = "ALT|CTRL"
end

-- if you are *NOT* lazy-loading smart-splits.nvim (recommended)
local function is_vim(pane)
	-- this is set by the plugin, and unset on ExitPre in Neovim
	return pane:get_user_vars().IS_NVIM == "true"
end

local direction_keys = {
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}

local function split_nav(resize_or_move, key)
	return {
		key = key,
		mods = resize_or_move == "resize" and mod.CTRL_S or mod.SUPER,
		action = wezterm.action_callback(function(win, pane)
			if is_vim(pane) then
				print(pane)
				-- pass the keys through to vim/nvim
				win:perform_action({
					SendKey = { key = key, mods = resize_or_move == "resize" and mod.CTRL_S or mod.SUPER },
				}, pane)
			else
				if resize_or_move == "resize" then
					win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
				else
					win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
				end
			end
		end),
	}
end

local keys = {

	-- copy/paste --
	{ key = "c", mods = mod.SUPER, action = action.CopyTo("Clipboard") },
	{ key = "v", mods = mod.SUPER, action = action.PasteFrom("Clipboard") },

	-- tabs --
	-- tabs: spawn+close
	{ key = "t", mods = mod.SUPER, action = action.SpawnTab("DefaultDomain") },
	-- { key = "w", mods = mod.SUPER, action = action.CloseCurrentTab { confirm = false } },

	-- move between split panes
	split_nav("move", "h"),
	split_nav("move", "j"),
	split_nav("move", "k"),
	split_nav("move", "l"),
	-- -- resize panes
	split_nav("resize", "h"),
	split_nav("resize", "j"),
	split_nav("resize", "k"),
	split_nav("resize", "l"),

	-- panes --
	-- panes: split panes
	{
		key = [[j]],
		mods = mod.SUPER_REV,
		action = action.SplitVertical { domain = "CurrentPaneDomain" },
	},
	{
		key = [[l]],
		mods = mod.SUPER_REV,
		action = action.SplitHorizontal { domain = "CurrentPaneDomain" },
	},
	{
		key = [[-]],
		mods = mod.SUPER_REV,
		action = action.CloseCurrentPane { confirm = true },
	},

	-- panes: navigation
	-- { key = "k", mods = mod.SUPER_REV, action = action.ActivatePaneDirection("Up") },
	-- { key = "j", mods = mod.SUPER_REV, action = action.ActivatePaneDirection("Down") },
	-- { key = "h", mods = mod.SUPER_REV, action = action.ActivatePaneDirection("Left") },
	-- { key = "l", mods = mod.SUPER_REV, action = action.ActivatePaneDirection("Right") },
	--
	-- panes: resize
	{ key = "k", mods = mod.CTRL_S, action = action.AdjustPaneSize { "Up", 1 } },
	{ key = "j", mods = mod.CTRL_S, action = action.AdjustPaneSize { "Down", 1 } },
	{ key = "h", mods = mod.CTRL_S, action = action.AdjustPaneSize { "Left", 1 } },
	{ key = "l", mods = mod.CTRL_S, action = action.AdjustPaneSize { "Right", 1 } },
}

return {
	disable_default_key_bindings = true,
	disable_default_mouse_bindings = true,
	enable_kitty_keyboard = true,
	enable_csi_u_key_encoding = false,

	keys = keys,
}
