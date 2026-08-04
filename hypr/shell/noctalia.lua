local function get_command_path(cmd)
	local p = io.popen("command -v " .. cmd .. " 2>/dev/null")
	if not p then
		return nil
	end
	local result = p:read("*l") -- 读取第一行输出
	p:close()
	return result
end

local noctalia_path = get_command_path("noctalia")

if noctalia_path then
	require("noctalia")

	hl.config {
		decoration = {
			rounding = 14,
			blur = {
				ignore_opacity = false,
				passes = 4,
				size = 2,
				vibrancy = 0.28,
				vibrancy_darkness = 0.14,
			},
		},
	}

	local ipc = "noctalia msg "
	local mainMod = "SUPER"

	-- Core binds
	hl.bind(mainMod .. "+comma", hl.dsp.exec_cmd(ipc .. "settings-toggle"))
	hl.bind("ALT + Tab", hl.dsp.exec_cmd(ipc .. "window-switcher"))

	-- Media keys
	hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. "volume-up"))
	hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. "volume-down"))
	hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. "volume-mute"))
	hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(ipc .. "brightness-up"))
	hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(ipc .. "brightness-down"))

	hl.window_rule {
		match = { class = "dev.noctalia.Noctalia" },
		float = true,
		size = { 1080, 920 },
	}
else
	print("Noctalia is not installed.")
end
