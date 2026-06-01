local function is_nvidia()
	-- 执行 lspci 命令并捕获输出
	local handle = io.popen("lspci | grep -i vga")
	if not handle then
		return false
	end

	local result = handle:read("*a")
	handle:close()

	return result:lower():find("nvidia") ~= nil
end

if is_nvidia() then
	hl.env("LIBVA_DRIVER_NAME", "nvidia")
	hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
	hl.env("GBM_BACKEND", "nvidia-drm")
else
	-- AMD 或 Intel 显卡的配置
end

local global_envs = {
	NIXOS_OZONE_WL = "1", -- for any ozone-based browser & electron apps to run on wayland

	-- Toolkit Backend
	-- "GDK_BACKEND,wayland,x11,*"
	CLUTTER_BACKEND = "wayland",
	QT_QPA_PLATFORM = "wayland",
	SDL_VIDEODRIVER = "wayland",
	ELECTRON_OZONE_PLATFORM_HINT = "wayland",

	-- environment-variables
	GDK_DPI_SCALE = "1",

	-- -- XDG Desktop Portal
	XDG_CURRENT_DESKTOP = "Hyprland",
	XDG_SESSION_TYPE = "wayland",
	XDG_SESSION_DESKTOP = "Hyprland",

	-- QT
	-- "QT_QPA_PLATFORMTHEME,qt6ct"
	-- "QT_QPA_PLATFORMTHEME,qt5ct"
	QT_QPA_PLATFORMTHEME = "gtk3",
	QT_QPA_PLATFORMTHEME_QT6 = "gtk3",
	QT_WAYLAND_DISABLE_WINDOWDECORATION = "1",
	QT_AUTO_SCREEN_SCALE_FACTOR = "1",

	-- fcitx5
	XMODIFIERS = "@im=fcitx",
	QT_IM_MODULE = "wayland",

	-- java
	_JAVA_AWT_WM_NONREPARENTING = "1",
	_JAVA_OPTIONS = "-Dsun.java2d.uiScale=2",

	-- firefox
	MOZ_ENABLE_WAYLAND = "1",
	MOZ_WEBRENDER = "1",

	-- Ozone
	OZONE_PLATFORM = "wayland",

	-- KVM
	WLR_RENDERER_ALLOW_SOFTWARE = "1",
}

for env_name, env_value in ipairs(global_envs) do
	hl.env(env_name, env_value)
end
