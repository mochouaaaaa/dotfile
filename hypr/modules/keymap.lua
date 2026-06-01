local mainMod = "SUPER"

hl.config {
	binds = {
		drag_threshold = 10,
	},
}

local function smart_resize_left()
	local win = hl.get_active_window()
	if not win or not win.at then
		return
	end

	hl.notification.create { text = tostring(win.at.x), duration = 3000 }
	hl.notification.create { text = tostring(win.at.y), duration = 3000 }

	if win.at.x > 3 then
		hl.dsp.window.resize { x = 50, y = 0, relative = true }
	else
		hl.dsp.window.resize { x = -50, y = 0, relative = true }
	end
end

global_keymaps = {

	{ mainMod .. "+ CTRL+T", hl.dsp.exec_cmd("kitty --single-instance") },
	{ mainMod .. "+ CTRL+E", hl.dsp.exec_cmd("nautilus") },

	{ mainMod .. "+ CTRL+F", hl.dsp.window.float() },
	{ mainMod .. "+ G", hl.dsp.group.toggle() },

	{ mainMod .. "+ CTRL+A", hl.dsp.exec_cmd("grimblast -n -o -e 5000 --freeze copysave area") },
	{ mainMod .. "+ CTRL+S", hl.dsp.exec_cmd("grimblast -n -o -e 5000 --freeze copysave active") },

	{ "CTRL+ALT+return", hl.dsp.window.fullscreen() },

	{ "CTRL+SHIFT+R", hl.dsp.layout("colresize +conf") },
	{ "CTRL+ALT+left", hl.dsp.window.swap { direction = "left" } },
	{ "CTRL+ALT+right", hl.dsp.window.swap { direction = "right" } },
	{ "CTRL+ALT+up", hl.dsp.window.swap { direction = "up" } },
	{ "CTRL+ALT+down", hl.dsp.window.swap { direction = "down" } },
	{ "ALT + h", hl.dsp.focus { direction = "left" } },
	{ "ALT + l", hl.dsp.focus { direction = "right" } },
	{ "ALT + k", hl.dsp.focus { direction = "up" } },
	{ "ALT + j", hl.dsp.focus { direction = "down" } },
	{ "CTRL+SHIFT+left", hl.dsp.window.resize { x = -50, y = 0, relative = true }, { repeating = true } },
	{ "CTRL+SHIFT+right", hl.dsp.window.resize { x = 50, y = 0, relative = true }, { repeating = true } },
	-- { "CTRL+SHIFT+up", hl.dsp.window.resize { x = 0, y = 30, relative = true } },
	-- { "CTRL+SHIFT+down", hl.dsp.window.resize { x = 0 } },

	-- Move/resize windows with mainMod + LMB/RMB and dragging
	{ mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true } },
	{ mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true } },
	{ mainMod .. " + mouse:272", hl.dsp.window.float(), { mouse = true, click = true } },

	-- Move/resize windows with mainMod + LMB/RMB and dragging
	{ mainMod .. " + TAB", hl.dsp.focus { workspace = "e+1" } },
	{ mainMod .. " + SHIFT+TAB", hl.dsp.focus { workspace = "e-1" } },
	{ "ALT+TAB", hl.dsp.window.cycle_next() },

	-- Laptop multimedia keys for volume and LCD brightness
	{
		"XF86AudioRaiseVolume",
		hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
		{ locked = true, repeating = true },
	},
	{
		"XF86AudioLowerVolume",
		hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
		{ locked = true, repeating = true },
	},
	{
		"XF86AudioMute",
		hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
		{ locked = true, repeating = true },
	},
	{
		"XF86AudioMicMute",
		hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
		{ locked = true, repeating = true },
	},
	{
		"XF86MonBrightnessUp",
		hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),
		{ locked = true, repeating = true },
	},
	{
		"XF86MonBrightnessDown",
		hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),
		{ locked = true, repeating = true },
	},

	-- Requires playerctl
	{ "XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true } },
	{ "XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true } },
	{ "XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true } },
	{ "XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true } },

	{
		mainMod .. " + M",
		hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"),
	},
	{ mainMod .. " + Q", hl.dsp.window.close() },
}

for _, keymaps in ipairs(global_keymaps) do
	hl.bind(table.unpack(keymaps))
end

-- local closeWindowBind = hl.bind()
-- closeWindowBind:set_enabled(true)
