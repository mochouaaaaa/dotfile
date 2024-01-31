local wezterm = require("wezterm")
local mux = wezterm.mux

--wezterm.on("gui-startup", function()
--	local tab, pane, window = mux.spawn_window(cmd or {})
--	window:gui_window():maximize()
--end)
--
--local function basename(s) return string.gsub(s, "(.*[/\\])(.*)", "%2") end
--
--local SOLID_LEFT_ARROW = utf8.char(0xe0ba)
--local SOLID_LEFT_MOST = utf8.char(0x2588)
--local SOLID_RIGHT_ARROW = utf8.char(0xe0bc)
--
--local SUB_IDX = {
--	"₁",
--	"₂",
--	"₃",
--	"₄",
--	"₅",
--	"₆",
--	"₇",
--	"₈",
--	"₉",
--	"₁₀",
--	"₁₁",
--	"₁₂",
--	"₁₃",
--	"₁₄",
--	"₁₅",
--	"₁₆",
--	"₁₇",
--	"₁₈",
--	"₁₉",
--	"₂₀",
--}
--
--wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
--	local edge_background = "#121212"
--	local background = "#4E4E4E"
--	local foreground = "#1C1B19"
--	local dim_foreground = "#3A3A3A"
--
--	local title_prefix = ""
--	if tab.is_active then
--		background = "#FBB829"
--		foreground = "#1C1B19"
--		title_prefix = "🥝"
--	elseif hover then
--		background = "#FF8700"
--		foreground = "#1C1B19"
--	end
--
--	local edge_foreground = background
--	local process_name = tab.active_pane.foreground_process_name
--	local exec_name = basename(process_name)
--	local title_with_icon = exec_name
--	local left_arrow = SOLID_LEFT_ARROW
--	if tab.tab_index == 0 then
--		left_arrow = SOLID_LEFT_MOST
--	end
--
--	if tab.tab_index == 0 then
--		title_with_icon = "Martins3"
--	end
--
--	local id = SUB_IDX[tab.tab_index + 1]
--	local title = " " .. title_prefix .. "" .. wezterm.truncate_right(title_with_icon, max_width - 6) .. " "
--
--	return {
--		{ Attribute = { Intensity = "Bold" } },
--		{ Background = { Color = edge_background } },
--		{ Foreground = { Color = edge_foreground } },
--		{ Text = left_arrow },
--		{ Background = { Color = background } },
--		{ Foreground = { Color = foreground } },
--		{ Text = id },
--		{ Text = title },
--		{ Foreground = { Color = dim_foreground } },
--		{ Text = " " },
--		{ Background = { Color = edge_background } },
--		{ Foreground = { Color = edge_foreground } },
--		{ Text = SOLID_RIGHT_ARROW },
--		{ Attribute = { Intensity = "Normal" } },
--	}
--end)

return {
	check_for_updates = true,

	adjust_window_size_when_changing_font_size = false,
	-- default_prog = { "/bin/sh", "-l", "-c" },
	-- default_prog = { '/bin/sh', '-l', '-c', 'zellij attach || /usr/bin/env zellij' },
	font_size = 18,
	window_background_opacity = 0.9,
	font = wezterm.font_with_fallback {
		"Monaco Nerd Font",
		{ family = "Symbols Nerd Font Mono", scale = 1 },
	},
	-- launch_menu = {
	-- 	{
	-- 		label = "M2",
	-- 		args = { "ssh", "-b", "10.0.0.1", "-t", "martins3@192.168.11.99", "zellij attach || zellij" },
	-- 	},
	-- 	{
	-- 		args = { "zsh" },
	-- 	},
	-- 	{
	-- 		label = "Arm Ubuntu Server",
	-- 		args = { "ssh", "-t", "martins3@192.168.26.81", "tmux attach || tmux" },
	-- 	},
	-- 	{
	-- 		label = "QEMU",
	-- 		args = { "ssh", "-t", "-p5556", "root@localhost", "tmux attach || tmux" },
	-- 	},
	--
	-- 	{
	-- 		label = "zellij",
	-- 		args = { "/bin/sh", "-l", "-c", "zellij attach || /usr/bin/env zellij" },
	-- 	},
	-- 	{
	-- 		label = "tmux",
	-- 		args = { "/bin/sh", "-l", "-c", "tmux attach || /usr/bin/env tmux" },
	-- 	},
	-- },

	colors = {
		foreground = "#f8f8f2",
		background = "#282a36",
		-- the foreground color of selected text
		selection_fg = "#ffffff",
		-- the background color of selected text
		selection_bg = "#44475a",
		tab_bar = {
			active_tab = { bg_color = "#f8f8f2", fg_color = "#282a36" },
			inactive_tab = {
				bg_color = "#6272a4",
				fg_color = "#282a36",
			},
		},
	},
	-- window_background_gradient = {
	-- 	orientation = "Vertical",
	-- 	interpolation = "Linear",
	-- 	blend = "Rgb",
	-- 	colors = {
	-- 		"#121212",
	-- 		"#202020",
	-- 	},
	-- },
	use_fancy_tab_bar = false,
	hide_tab_bar_if_only_one_tab = true,
	window_decorations = "RESIZE",
	show_new_tab_button_in_tab_bar = false,

	tab_max_width = 60,
	freetype_load_target = "Normal",

	enable_kitty_graphics = true,
}
