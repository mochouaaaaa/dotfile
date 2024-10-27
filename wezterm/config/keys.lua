local keymap = require("utils.send_keys")

local keys = {
	-- copy/paste
	keymap.create_key_binding("CMD", "c"),
	keymap.create_key_binding("CMD", "v"),

	-- custom
	keymap.create_key_binding("CMD", "w"),
	keymap.create_key_binding("CMD", "r"),
	keymap.create_key_binding("CMD|SHIFT", "f"),
	keymap.create_key_binding("CMD", "f"),
	keymap.create_key_binding("CMD", "t"),
	-- move
	keymap.create_key_binding("CMD", "h"),
	keymap.create_key_binding("CMD", "j"),
	keymap.create_key_binding("CMD", "k"),
	keymap.create_key_binding("CMD", "l"),
	-- resize
	keymap.create_key_binding("CTRL|SHIFT", "h"),
	keymap.create_key_binding("CTRL|SHIFT", "j"),
	keymap.create_key_binding("CTRL|SHIFT", "k"),
	keymap.create_key_binding("CTRL|SHIFT", "l"),
	-- split
	keymap.create_key_binding("CMD|CTRL", "h"),
	keymap.create_key_binding("CMD|CTRL", "j"),
	keymap.create_key_binding("CMD|CTRL", "k"),
	keymap.create_key_binding("CMD|CTRL", "l"),

	-- tab
	keymap.create_key_binding("CMD", "1"),
	keymap.create_key_binding("CMD", "2"),
	keymap.create_key_binding("CMD", "3"),
	keymap.create_key_binding("CMD", "4"),
	keymap.create_key_binding("CMD", "5"),
	keymap.create_key_binding("CMD", "6"),
	keymap.create_key_binding("CMD|SHIFT", "k"),
	keymap.create_key_binding("CMD", "Enter"),
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
