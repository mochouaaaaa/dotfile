local platform = require("utils.platform")()
local wezterm = require("wezterm")
local action = wezterm.action

local mod = {
	CTRL = "CTRL",
	SHIFT = "SHIFT",
}

keyCombination = {
	CTRL_S = mod.CTRL .. "|" .. mod.SHIFT,
}

for k, v in pairs(keyCombination) do
	print(k, v)
	mod[k] = v
end

if platform.is_mac then
	mod.SUPER = "CMD"
	mod.SUPER_REV = mod.SUPER .. "|" .. mod.CTRL
	mod.OPTION = "ALT"
-- elseif platform.is_win then
else
	mod.SUPER = "ALT"
	mod.SUPER_REV = mod.SUPER .. "|" .. mod.CTRL
	mod.OPTION = "META"
end

local keys = {

	-- wezterm_nvim.wezterm_nvim("move", "h", mod.SUPER),
	-- wezterm_nvim.wezterm_nvim("move", "j", mod.SUPER),
	-- wezterm_nvim.wezterm_nvim("move", "k", mod.SUPER),
	-- wezterm_nvim.wezterm_nvim("move", "l", mod.SUPER),
	--
	-- wezterm_nvim.wezterm_nvim("resize", "h", mod.CTRL_S),
	-- wezterm_nvim.wezterm_nvim("resize", "j", mod.CTRL_S),
	-- wezterm_nvim.wezterm_nvim("resize", "k", mod.CTRL_S),
	-- wezterm_nvim.wezterm_nvim("resize", "l", mod.CTRL_S),

	-- copy/paste --
	{ key = "c", mods = mod.SUPER, action = action.CopyTo("Clipboard") },
	{ key = "v", mods = mod.SUPER, action = action.PasteFrom("Clipboard") },

	-- tabs --
	-- tabs: spawn+close
	{ key = "t", mods = mod.SUPER, action = action.SpawnTab("DefaultDomain") },
	-- { key = "w", mods = mod.SUPER, action = action.CloseCurrentTab { confirm = false } },
	-- wezterm_nvim.wezterm_nvim("close_tab", "w", mod.SUPER),
	-- send nvim
}

local M = {
	disable_default_key_bindings = true,
	disable_default_mouse_bindings = false,
	enable_kitty_keyboard = true,
	enable_csi_u_key_encoding = true,

	keys = keys,
}

return M
