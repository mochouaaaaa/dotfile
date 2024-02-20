local platform = require("utils.platform")()
local wezterm = require("wezterm")
local wezterm_nvim = require("utils.smart_split")
local action = wezterm.action

local mod = {
	CTRL = "CTRL",
	CTRL_S = "CTRL|SHIFT",
	SHIFT = "SHIFT",
	SUPER_S = "CMD|SHIFT",
}

if platform.is_mac then
	mod.SUPER = "CMD"
	mod.SUPER_REV = "CMD|CTRL"
elseif platform.is_win then
	mod.SUPER = "ALT"
	mod.SUPER_REV = "ALT|CTRL"
end

local keys = {

	wezterm_nvim.wezterm_nvim("move", "h", mod.SUPER),
	wezterm_nvim.wezterm_nvim("move", "j", mod.SUPER),
	wezterm_nvim.wezterm_nvim("move", "k", mod.SUPER),
	wezterm_nvim.wezterm_nvim("move", "l", mod.SUPER),

	wezterm_nvim.wezterm_nvim("resize", "h", mod.SUPER_S),
	wezterm_nvim.wezterm_nvim("resize", "j", mod.SUPER_S),
	wezterm_nvim.wezterm_nvim("resize", "k", mod.SUPER_S),
	wezterm_nvim.wezterm_nvim("resize", "l", mod.SUPER_S),

	-- copy/paste --
	{ key = "c", mods = mod.SUPER, action = action.CopyTo("Clipboard") },
	{ key = "v", mods = mod.SUPER, action = action.PasteFrom("Clipboard") },

	-- tabs --
	-- tabs: spawn+close
	{ key = "t", mods = mod.SUPER, action = action.SpawnTab("DefaultDomain") },
	-- { key = "w", mods = mod.SUPER, action = action.CloseCurrentTab { confirm = false } },

	-- send nvim
	-- _keys.key2nvim("f", mod.SUPER_S),

	-- panes --
	-- panes: split panes
	-- {
	-- 	key = [[j]],
	-- 	mods = mod.SUPER_REV,
	-- 	action = action.SplitVertical { domain = "CurrentPaneDomain" },
	-- },
	-- {
	-- { key = "k", mods = mod.SUPER_REV, action = action.ActivatePaneDirection("Up") },
	-- { key = "j", mods = mod.SUPER_REV, action = action.ActivatePaneDirection("Down") },
	-- { key = "h", mods = mod.SUPER_REV, action = action.ActivatePaneDirection("Left") },
	-- { key = "l", mods = mod.SUPER_REV, action = action.ActivatePaneDirection("Right") },
	--
}

local M = {
	disable_default_key_bindings = true,
	disable_default_mouse_bindings = false,
	enable_kitty_keyboard = true,
	enable_csi_u_key_encoding = true,

	keys = keys,
}

return M
