local function is_nvidia()
	-- lspci may report NVIDIA as a 3D controller on hybrid-GPU systems.
	local handle = io.popen("lspci 2>/dev/null")
	if not handle then
		return false
	end

	local result = handle:read("*a") or ""
	handle:close()
	return result:lower():match("nvidia") ~= nil
end

if is_nvidia() then
	hl.env("LIBVA_DRIVER_NAME", "nvidia")
	hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
	hl.env("GBM_BACKEND", "nvidia-drm")
end

local global_envs = {
	NIXOS_OZONE_WL = "1",

	-- Prefer Wayland while retaining X11 fallback where supported.
	CLUTTER_BACKEND = "wayland",
	QT_QPA_PLATFORM = "wayland;xcb",
	ELECTRON_OZONE_PLATFORM_HINT = "auto",
	MOZ_ENABLE_WAYLAND = "1",

	GDK_DPI_SCALE = "1",

	XDG_CURRENT_DESKTOP = "Hyprland",
	XDG_SESSION_TYPE = "wayland",
	XDG_SESSION_DESKTOP = "Hyprland",

	QT_QPA_PLATFORMTHEME = "gtk3",
	QT_WAYLAND_DISABLE_WINDOWDECORATION = "1",

	-- fcitx5
	XMODIFIERS = "@im=fcitx",
	GTK_IM_MODULE = "fcitx",
	QT_IM_MODULE = "wayland",

	-- Java applications under wlroots/Wayland
	_JAVA_AWT_WM_NONREPARENTING = "1",
}

-- global_envs is a string-keyed map; ipairs() would silently skip it.
for env_name, env_value in pairs(global_envs) do
	hl.env(env_name, env_value)
end
