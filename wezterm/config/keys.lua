local platform = require("utils.platform")()
local wezterm = require("wezterm")
local action = wezterm.action
local wezterm_nvim = require("utils.smart_split")

local mod = {
	CTRL = "CTRL",
	SHIFT = "SHIFT",
}

if platform.is_mac then
	mod.COMMAND = "CMD"
	mod.COMMAND_REV = mod.COMMAND .. "|" .. mod.CTRL
	mod.OPTION = "META"
else
	mod.COMMAND = "ALT"
	mod.COMMAND_REV = mod.COMMAND .. "|" .. mod.CTRL
	mod.OPTION = "NONE"
end

keyCombination = {
	CTRL_S = mod.CTRL .. "|" .. mod.SHIFT,
	COMMAND_S = mod.COMMAND .. "|" .. mod.SHIFT,
}

for k, v in pairs(keyCombination) do
	mod[k] = v
end

local keys = {

	wezterm_nvim.wezterm_nvim("move", "h", mod.COMMAND),
	wezterm_nvim.wezterm_nvim("move", "j", mod.COMMAND),
	wezterm_nvim.wezterm_nvim("move", "k", mod.COMMAND),
	wezterm_nvim.wezterm_nvim("move", "l", mod.COMMAND),

	wezterm_nvim.wezterm_nvim("resize", "h", mod.CTRL_S),
	wezterm_nvim.wezterm_nvim("resize", "j", mod.CTRL_S),
	wezterm_nvim.wezterm_nvim("resize", "k", mod.CTRL_S),
	wezterm_nvim.wezterm_nvim("resize", "l", mod.CTRL_S),

	wezterm_nvim.wezterm_nvim("split", "h", mod.COMMAND_REV),
	wezterm_nvim.wezterm_nvim("split", "j", mod.COMMAND_REV),
	wezterm_nvim.wezterm_nvim("split", "k", mod.COMMAND_REV),
	wezterm_nvim.wezterm_nvim("split", "l", mod.COMMAND_REV),

	wezterm_nvim.wezterm_nvim("close_tab", "w", mod.COMMAND),

	-- wezterm_nvim.SendKey("e", mod.Command),
	-- copy/paste --
	{ key = "c", mods = mod.COMMAND, action = action.CopyTo("Clipboard") },
	{ key = "v", mods = mod.COMMAND, action = action.PasteFrom("Clipboard") },

	-- tabs --
	-- tabs: spawn+close
	-- { key = "Enter", mods = mod.COMMAND, action = action.TogglePaneZoomState },
	wezterm_nvim.SendKey2TmuxOrNvim("Enter", mod.COMMAND, action.TogglePaneZoomState),
	{ key = "t", mods = mod.COMMAND, action = action.SpawnTab("DefaultDomain") },
	-- { key = "e", mods = mod.Command, action = action.SendKey({ key = "e", mods = "META" }) },

	-- send tmux
	wezterm_nvim.SendKey2TmuxOrNvim("s", mod.COMMAND),
	wezterm_nvim.SendKey2TmuxOrNvim("e", mod.COMMAND),
	wezterm_nvim.SendKey2TmuxOrNvim("f", mod.COMMAND),
	wezterm_nvim.SendKey2TmuxOrNvim("f", mod.COMMAND_S),
	wezterm_nvim.SendKey2TmuxOrNvim("r", mod.COMMAND),
	wezterm_nvim.SendKey2TmuxOrNvim("/", mod.COMMAND),
}

local M = {
	disable_default_key_bindings = true,
	disable_default_mouse_bindings = false,
	enable_kitty_keyboard = true,
	enable_csi_u_key_encoding = true,

	-- debug_key_events = true,
	keys = keys,
}

return M
