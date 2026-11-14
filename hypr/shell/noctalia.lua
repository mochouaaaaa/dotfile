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
	-- hl.unbind(mainMod .. "+CTRL+A")
	-- hl.bind(mainMod .. "+CTRL+A", hl.dsp.exec_cmd(ipc .. "screenshot-region"))
	-- hl.unbind("ALT+TAB")
	-- hl.bind("ALT+TAB", hl.dsp.exec_cmd(ipc .. "window-switcher"))

	hl.window_rule {
		match = { class = "dev.noctalia.Noctalia" },
		float = true,
		size = { 1080, 920 },
	}
else
	print("Noctalia is not installed.")
end
