local mainMod = "SUPER"

hl.config {
	binds = {
		drag_threshold = 10,
	},
}

local global_keymaps = {
	{ mainMod .. "+CTRL+T", hl.dsp.exec_cmd("kitty --single-instance --listen-on=unix:/tmp/my-socket") },
	{ mainMod .. "+CTRL+E", hl.dsp.exec_cmd("nautilus") },
	{ mainMod .. "+CTRL+F", hl.dsp.window.float() },
	{ mainMod .. "+G", hl.dsp.group.toggle() },

	{ mainMod .. "+CTRL+A", hl.dsp.exec_cmd("grimblast -n -o -e 5000 --freeze copysave area") },
	{ mainMod .. "+CTRL+S", hl.dsp.exec_cmd("grimblast -n -o -e 5000 --freeze copysave active") },

	{ "CTRL+ALT+RETURN", hl.dsp.window.fullscreen() },
	{ "CTRL+SHIFT+R", hl.dsp.layout("colresize +conf") },

	-- Compositor focus stays on ALT+HJKL so SUPER+HJKL reaches TUI apps
	-- (including TUIOS) inside Kitty/WezTerm.
	{ "ALT+H", hl.dsp.focus { direction = "left" } },
	{ "ALT+L", hl.dsp.focus { direction = "right" } },
	{ "ALT+K", hl.dsp.focus { direction = "up" } },
	{ "ALT+J", hl.dsp.focus { direction = "down" } },

	-- Compositor window resize: SUPER + SHIFT + HJKL.
	-- Use the canonical spaced key syntax from the Hyprland Lua examples.
	-- Terminal/TUI resize remains CTRL + SHIFT + HJKL.
	{ mainMod .. " + SHIFT + h", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true } },
	{ mainMod .. " + SHIFT + l", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true } },
	{ mainMod .. " + SHIFT + k", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true } },
	{ mainMod .. " + SHIFT + j", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true } },

	{ "CTRL+ALT+LEFT", hl.dsp.window.swap { direction = "left" } },
	{ "CTRL+ALT+RIGHT", hl.dsp.window.swap { direction = "right" } },
	{ "CTRL+ALT+UP", hl.dsp.window.swap { direction = "up" } },
	{ "CTRL+ALT+DOWN", hl.dsp.window.swap { direction = "down" } },

	{
		mainMod .. "+TAB",
		function()
			local layouts = { "scrolling", "dwindle", "master", "monocle" }
			local workspace = hl.get_active_workspace()
			if hl.get_active_special_workspace() then
				workspace = hl.get_active_special_workspace()
			end
			if not workspace then
				return
			end

			local next_layout = "dwindle"
			for i = 1, #layouts do
				if layouts[i] == workspace.tiled_layout then
					next_layout = layouts[(i % #layouts) + 1]
					break
				end
			end

			local ws_name = tostring(workspace.name)
			if workspace.special then
				hl.workspace_rule { workspace = ws_name, layout = next_layout }
			else
				hl.workspace_rule { workspace = "name:" .. ws_name, layout = next_layout }
			end
		end,
	},
	{ "ALT+TAB", hl.dsp.window.cycle_next() },

	-- Keep one owner for media keys. Noctalia no longer rebinds these.
	{ "XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true } },
	{ "XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true } },
	{ "XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true } },
	{ "XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true } },
	{ "XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true } },
	{ "XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true } },
	{ "XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true } },
	{ "XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true } },
	{ "XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true } },
	{ "XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true } },

	{ mainMod .. "+M", hl.dsp.exec_cmd("if command -v hyprshutdown >/dev/null 2>&1; then hyprshutdown; else hyprctl dispatch exit; fi") },
	{ mainMod .. "+Q", hl.dsp.window.close() },
	{ mainMod .. "+CTRL+Q", hl.dsp.exec_cmd("loginctl lock-session") },
}

for _, keymap in ipairs(global_keymaps) do
	hl.bind(table.unpack(keymap))
end

-- Mouse bindings are kept separate from keyboard bindings.
if hl.bind_mouse then
	hl.bind_mouse(mainMod .. "+mouse:272", hl.dsp.window.drag())
	hl.bind_mouse(mainMod .. "+mouse:273", hl.dsp.window.resize())
else
	hl.bind(mainMod .. "+mouse:272", hl.dsp.window.drag(), { mouse = true })
	hl.bind(mainMod .. "+mouse:273", hl.dsp.window.resize(), { mouse = true })
end
