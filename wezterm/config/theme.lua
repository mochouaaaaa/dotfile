local wezterm = require("wezterm")

local platform = require("utils.platform")

local font_size = platform().is_mac and 16 or 16

local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Catppuccin Mocha"
	else
		return "Catppuccin Latte"
	end
end

local function get_color(name)
	local scheme = wezterm.color.get_builtin_schemes()[scheme_for_appearance(wezterm.gui.get_appearance())]
	return scheme[name]
end

return {
	term = "xterm-256color",
	animation_fps = 60,
	max_fps = 60,

	-- font = wezterm.font {
	-- 	family = font,
	-- 	assume_emoji_presentation = false,
	-- 	harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
	-- },
	-- 设置主字体为 Monaco
	font = wezterm.font_with_fallback {
		"Monaco Nerd Font",
		"Symbols Nerd Font Mono",
		"Fira Code",
		"JetBrainsMono Nerd Font Mono",
	},
	-- 启用连体字体特性
	harfbuzz_features = { "calt=1", "clig=1", "liga=1" },
	-- 设置图标字体为 JetBrainsMono Nerd Font

	use_ime = true,
	font_size = font_size,
	line_height = 1.1,
	underline_position = 0,
	strikethrough_position = 2,

	freetype_load_target = "Normal",
	freetype_render_target = "HorizontalLcd",
	-- freetype_load_flags = "NO_BITMAP",

	-- theme
	color_scheme = scheme_for_appearance(wezterm.gui.get_appearance()),
	use_fancy_tab_bar = false,
	hide_tab_bar_if_only_one_tab = true,
	window_decorations = "NONE",
	show_new_tab_button_in_tab_bar = false,
	-- transparency
	window_background_opacity = 0.75,
	-- mac blur
	macos_window_background_blur = 20,
	-- text_background_opacity = 0.75,
	adjust_window_size_when_changing_font_size = false,

	force_reverse_video_cursor = true,
	window_frame = {
		-- 控制顶部和内容的距离
		border_left_width = "0.0cell",
		border_right_width = "0.0cell",
		border_bottom_height = "0.0cell",
		border_top_height = "0.5cell",
		border_left_color = get_color("background"),
		border_right_color = get_color("background"),
		border_bottom_color = get_color("background"),
		border_top_color = get_color("background"),
	},
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
}
