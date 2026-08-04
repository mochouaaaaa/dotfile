_G.opacity = 0.78

local window_rules = {
	{
		name = "opacity",
		match = {
			fullscreen = 0,
		},
		opacity = _G.opacity,
	},
	{
		-- Hyprland-run windowrule
		name = "move-hyprland-run",
		match = { class = "hyprland-run" },

		move = "20 monitor_h-120",
		float = true,
	},
	{
		-- Fix some dragging issues with XWayland
		name = "fix-xwayland-drags",
		match = {
			class = "^$",
			title = "^$",
			xwayland = true,
			float = true,
			fullscreen = false,
			pin = false,
		},

		no_focus = true,
	},
	{ match = { float = true, xwayland = false }, center = true },
	{
		match = {
			class = "^(io.github.kukuruzka165.materialgram|org.telegram.desktop)$",
			title = "媒体查看器",
		},
		float = true,
	},
	{
		match = {
			class = "guifetch|yad|zenity|wev|org.gnome.FileRoller|file-roller|com.github.GradienceTeam.Gradience|feh|system-config-printer",
		},
		float = true,
	},
	{
		match = {
			class = "^([Ww]hatsapp-for-linux)$|^([Ff]erdium)$",
		},
		center = true,
	},

	-- =====================================================================
	-- 1. Filemanager (Thunar) 规则
	-- =====================================================================
	{ match = { class = "([Tt]hunar)", title = "^([Tt]hunar)$" }, center = true, size = { 1200, 1300 } },
	{ match = { class = "([Tt]hunar)", title = "(Confirm to replace files)" }, center = true },
	{ match = { class = "([Tt]hunar)", title = "(File Operation Progress)" }, float = true },
	{ match = { class = "([Tt]hunar)", title = "(Confirm to replace files)" }, float = true },

	-- =====================================================================
	-- 2. 常用软件与悬浮窗规则
	-- =====================================================================
	{ match = { class = "chromium-browser", title = "(雀魂麻将 - Chromium)" }, float = true },
	-- 翻译悬浮窗 (pot)
	{
		match = {
			class = "^(pot|.pot-wrapped)$",
			title = "(Translate|Translator|OCR|PopClip|Screenshot Translate|Config)",
		},
		float = true,
	},
	{
		match = { class = "(pot|.pot-wrapped)", title = "(Translator|PopClip|Screenshot Translate) " },
		move = { "cursor-0", "cursor-0" },
	},

	{ match = { class = "(org.telegram.desktop)", title = "(Media viewer)" }, float = true },
	{ match = { title = "overskride" }, float = true },
	{ match = { title = "QQ" }, float = true },
	{ match = { title = "图片查看器" }, float = true },
	{ match = { class = "(VirtualBox)" }, float = true },

	-- Firefox
	{ match = { class = "firefox", title = "(我的足迹)" }, float = true },
	{ match = { class = "firefox", title = "画中画" }, float = true },

	{ match = { class = "(xfce4-appfinder)" }, float = true },
	{ match = { class = "kitty", title = "yazi" }, float = true },
	{ match = { class = "([Zz]oom|onedriver|onedriver-launcher)$" }, float = true },
	{ match = { class = "(xdg-desktop-portal-gtk)" }, float = true },
	{ match = { class = "(codium|codium-url-handler|VSCodium)", title = "(Add Folder to Workspace)" }, float = true },
	{ match = { class = "^(eog)$" }, float = true }, -- image viewer

	-- 系统/网络组件
	{ match = { class = "^(nm-applet|nm-connection-editor|blueman-manager|.blueman-manager-wrapped)$" }, float = true },
	{ match = { class = "^([Yy]ad)$" }, float = true },
	{ match = { class = "^(wihotspot(-gui)?)$" }, float = true },
	{ match = { class = "^(evince)$" }, float = true },
	{ match = { class = "^(file-roller)$" }, float = true },
	{ match = { class = "^([Bb]aobab)$" }, float = true },
	{ match = { title = "(Kvantum Manager)" }, float = true },
	{ match = { class = "^([Qq]alculate-gtk)$" }, float = true },
	{ match = { class = "^([Bb]aobab)$" }, float = true },
	{ match = { class = "^([Ff]erdium)$" }, float = true },
	{ match = { class = "com.alibabainc.dingtalk" }, float = true },

	-- =====================================================================
	-- 3. 动态比例尺寸（Size 规则）
	-- =====================================================================
	{ match = { class = "^(xdg-desktop-portal-gtk)$" }, size = { "monitor_w * 0.7", "monitor_h * 0.7" } },
	{ match = { title = "(Kvantum Manager)" }, size = { "monitor_w * 0.6", "monitor_h * 0.7" } },
	{ match = { class = "^(qt6ct)$" }, size = { "monitor_w * 0.6", "monitor_h * 0.7" } },
	{ match = { class = "^(evince|wihotspot(-gui)?)$" }, size = { "monitor_w * 0.7", "monitor_h * 0.7" } },
	{ match = { class = "^(file-roller|org.gnome.FileRoller)$" }, size = { "monitor_w * 0.6", "monitor_h * 0.7" } },
	{ match = { class = "^([Ww]hatsapp-for-linux)$" }, size = { "monitor_w * 0.6", "monitor_h * 0.7" } },
	{ match = { class = "^([Ff]erdium)$" }, size = { "monitor_w * 0.6", "monitor_h * 0.7" } },

	-- =====================================================================
	-- 4. 屏幕共享与终端组件特殊规则
	-- =====================================================================
	{ match = { xwayland = 1 }, no_initial_focus = true },
	{ match = { class = "^(ueberzugpp.*)$" }, group = "unset" },

	-- =====================================================================
	-- 5. 通用对话框/弹窗规则 (Dialogs)
	-- =====================================================================
	{ match = { title = "(Select|Open)( a)? (File|Folder)(s)?" }, float = true },
	{ match = { title = "File (Operation|Upload)( Progress)?" }, float = true },
	{ match = { title = ".* Properties" }, float = true },
	{ match = { title = "Export Image as PNG" }, float = true },
	{ match = { title = "GIMP Crash Debug" }, float = true },
	{ match = { title = "Save As" }, float = true },
	{ match = { title = "Library" }, float = true },

	-- =====================================================================
	-- 6. 其他特定开发/专业软件
	-- =====================================================================
	-- ATLauncher
	{ match = { class = "com-atlauncher-App", title = "ATLauncher Console" }, float = true },
	-- Autodesk Fusion 360
	{ match = { class = "fusion360\\.exe", title = "Fusion360|(Marking Menu)" }, no_blur = true },
	-- JetBrains IDE 悬浮气泡焦点过滤
	{ match = { class = "^(.*jetbrains.*)$", title = "^(win[0-9]+)$" }, no_initial_focus = true },

	{
		name = "todo",
		match = {
			class = "Todoist",
		},
		workspace = "special:todo",
	},
	{
		name = "global",
		match = { class = "font-manager" },

		float = true,
		center = true,
	},
	{
		name = "mpv-took",
		match = { class = "mpv|com.github.rafostar.Clapper" },

		float = true,
		size = { "monitor_w*0.86", "monitor_h*0.86" },
	},
	{
		name = "proxy-took",
		match = { class = "sparkle", title = "Sparkle" },

		float = true,
		size = { "monitor_w*0.5", "monitor_h*0.8" },
	},
	{
		name = "imv-took",
		match = { class = "imv|equibop|swappy" },

		float = true,
		opaque = true,
	},
	{
		name = "filebrowser-took",
		match = { class = "^(org.gnome.Nautilus|thunar|pcmanfm|dolphin)$" },

		float = true,
		size = { "monitor_w*0.6", "monitor_h*0.7" },
	},
	{
		name = "gnome-settings",
		match = { class = "org.gnome.Settings|gnome-.*|org.gnome.*|io.missioncenter.MissionCenter" },

		float = true,
		size = { "monitor_w*0.7", "monitor_h*0.8" },
		center = true,
	},
	{
		name = "pulseaudio",
		match = { class = "org.pulseaudio.pavucontrol|yad-icon-browser" },

		float = true,
		size = { "monitor_w*0.6", "monitor_h*0.7" },
		center = true,
	},
	{
		name = "nwg-look",
		match = { class = "nwg-look" },

		float = true,
		size = { "50%", "60%" },
		center = true,
	},
	{
		name = "flameshot",
		match = { class = "flameshot" },

		pin = true,
		move = { 0, 0 },
		suppress_event = "fullscreen",
	},
	{
		name = "flameshot",
		match = { class = "flameshot" },

		pin = true,
		move = { 0, 0 },
		suppress_event = "fullscreen",
	},
	{
		name = "screen_sharing",
		match = { class = "xwaylandvideobridge" },

		opacity = "0.0 override",
		no_anim = true,
		no_initial_focus = true,
		max_size = { 1, 1 },
		no_blur = true,
		no_focus = true,
	},
	{
		name = "picture_in_picture",
		match = { title = "Picture(-| )in(-| )[Pp]icture" },

		float = true,
		pin = true,
		keep_aspect_ratio = true,
		move = { "100%-w-2%", "100%-w-3%" },
	},
	{
		name = "steam_app",
		match = { class = "steam_app_,[0-9]+" },

		rounding = 10,
		float = true,
		immediate = true,
		idle_inhibit = "always",
	},
	{
		name = "steam_app-list",
		match = {
			class = "steam",
			title = "Friends List",
		},
		float = true,
	},
	{
		name = "Bitwarden-rule",
		match = { class = "Bitwarden", title = "Bitwarden" },

		float = true,
		size = { "monitor_w*0.6", "monitor_h*0.7" },
		no_screen_share = true,
	},
	{
		name = "Authenticator",
		match = { class = "com.belmoussaoui.Authenticator" },
		float = true,
		no_screen_share = true,
	},
	{
		name = "xwayland-title",
		match = { xwayland = "1", title = "win[0-9]+" },

		no_dim = true,
		no_shadow = true,
		rounding = 10,
	},
	{
		name = "com-group_finity-mascot-Main",
		match = { class = "com-group_finity-mascot-Main" },

		float = true,
		no_blur = true,
		no_focus = true,
		no_shadow = true,
		border_size = 0,
	},
	{
		name = "hyprpicker",
		match = {
			namespace = "hyprpicker|selection",
		},
		animation = "fade",
	},
	{
		name = "tg",
		match = {
			class = "org.telegram.desktop|io.github.kukuruzka165.materialgram",
		},
		workspace = "special:tg",
	},
	{
		name = "wechat",
		match = {
			class = "discord|equibop|vesktop|whatsapp|qq|dingtalk",
		},
		workspace = "special:wechat",
	},
	{
		name = "matrix",
		match = {
			class = "org.gnome.Fractal|fluffychat|Element",
		},
		workspace = "special:matrix",
	},
	{
		name = "musci-spotify",
		match = {
			initial_title = "Spotify( Free)?",
		},
		workspace = "special:music",
	},
	{
		name = "music",
		match = {
			class = "feishin|Spotify|Supersonic|SPlayer",
		},
		workspace = "special:music",
	},
}

hl.bind("SUPER+CTRL+3", hl.dsp.workspace.toggle_special("wechat"))
hl.bind("SUPER+CTRL+4", hl.dsp.workspace.toggle_special("matrix"))
hl.bind("SUPER+CTRL+1", hl.dsp.workspace.toggle_special("music"))

---@diagnostic disable-next-line: param-type-mismatch
for _, rule in ipairs(window_rules) do
	hl.window_rule(rule)
end
