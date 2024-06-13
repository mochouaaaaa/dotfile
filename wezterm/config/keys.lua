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
	wezterm_nvim.wezterm_tmux_nvim("f", mod.CTRL),

	wezterm_nvim.wezterm_tmux_nvim("h", mod.COMMAND, action { ActivatePaneDirection = "Left" }),
	wezterm_nvim.wezterm_tmux_nvim("j", mod.COMMAND, action { ActivatePaneDirection = "Down" }),
	wezterm_nvim.wezterm_tmux_nvim("k", mod.COMMAND, action { ActivatePaneDirection = "Up" }),
	wezterm_nvim.wezterm_tmux_nvim("l", mod.COMMAND, action { ActivatePaneDirection = "Right" }),

	wezterm_nvim.wezterm_tmux_nvim("h", mod.CTRL_S, action { AdjustPaneSize = { "Left", 3 } }),
	wezterm_nvim.wezterm_tmux_nvim("j", mod.CTRL_S, action { AdjustPaneSize = { "Down", 3 } }),
	wezterm_nvim.wezterm_tmux_nvim("k", mod.CTRL_S, action { AdjustPaneSize = { "Up", 3 } }),
	wezterm_nvim.wezterm_tmux_nvim("l", mod.CTRL_S, action { AdjustPaneSize = { "Right", 3 } }),

	wezterm_nvim.wezterm_tmux_nvim("h", mod.COMMAND_REV, action { SplitPane = { direction = "Left" } }),
	wezterm_nvim.wezterm_tmux_nvim("j", mod.COMMAND_REV, action { SplitPane = { direction = "Down" } }),
	wezterm_nvim.wezterm_tmux_nvim("k", mod.COMMAND_REV, action { SplitPane = { direction = "Up" } }),
	wezterm_nvim.wezterm_tmux_nvim("l", mod.COMMAND_REV, action { SplitPane = { direction = "Right" } }),

	wezterm_nvim.wezterm_tmux_nvim("w", mod.COMMAND, action { CloseCurrentPane = { confirm = false } }),

	-- wezterm_nvim.SendKey("e", mod.Command),
	-- copy/paste --
	{ key = "c", mods = mod.COMMAND, action = action.CopyTo("Clipboard") },
	{ key = "v", mods = mod.COMMAND, action = action.PasteFrom("Clipboard") },

	-- tabs --
	-- tabs: spawn+close
	-- { key = "Enter", mods = mod.COMMAND, action = action.TogglePaneZoomState },
	wezterm_nvim.wezterm_tmux_nvim("Enter", mod.COMMAND, action.TogglePaneZoomState, true),
	wezterm_nvim.wezterm_tmux_nvim("t", mod.COMMAND, action.SpawnTab("DefaultDomain"), true),
	wezterm_nvim.wezterm_tmux_nvim("[", mod.COMMAND, action.ActivateTabRelative(1), true),
	wezterm_nvim.wezterm_tmux_nvim("]", mod.COMMAND, action.ActivateTabRelative(-1), true),
	wezterm_nvim.wezterm_tmux_nvim(
		"[",
		mod.COMMAND .. "|ALT",
		action { PaneSelect = { mode = "SwapWithActiveKeepFocus", alphabet = "123456789" } },
		true
	),
	wezterm_nvim.wezterm_tmux_nvim(
		"]",
		mod.COMMAND .. "|ALT",
		action { PaneSelect = { mode = "SwapWithActiveKeepFocus", alphabet = "123456789" } },
		true
	),

	wezterm_nvim.wezterm_tmux_nvim("1", mod.COMMAND, action { ActivateTab = 0 }, true),
	wezterm_nvim.wezterm_tmux_nvim("2", mod.COMMAND, action { ActivateTab = 1 }, true),
	wezterm_nvim.wezterm_tmux_nvim("3", mod.COMMAND, action { ActivateTab = 2 }, true),
	wezterm_nvim.wezterm_tmux_nvim("4", mod.COMMAND, action { ActivateTab = 3 }, true),
	wezterm_nvim.wezterm_tmux_nvim("5", mod.COMMAND, action { ActivateTab = 4 }, true),
	wezterm_nvim.wezterm_tmux_nvim("6", mod.COMMAND, action { ActivateTab = 5 }, true),

	-- tabs: rename
	wezterm_nvim.wezterm_tmux_nvim(
		"k",
		mod.COMMAND_S,
		action.PromptInputLine {
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:active_tab():set_title(line)
				end
			end),
		},
		true
	),

	-- send tmux
	wezterm_nvim.wezterm_tmux_nvim("s", mod.COMMAND),
	wezterm_nvim.wezterm_tmux_nvim("e", mod.COMMAND),
	wezterm_nvim.wezterm_tmux_nvim("f", mod.COMMAND, action { PaneSelect = { alphabet = "123456789" } }),
	wezterm_nvim.wezterm_tmux_nvim("f", mod.COMMAND_S, action.Search { CaseInSensitiveString = "" }),
	wezterm_nvim.wezterm_tmux_nvim("r", mod.COMMAND, action { SendString = "joshuto\n" }),
	wezterm_nvim.wezterm_tmux_nvim("/", mod.COMMAND),
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
