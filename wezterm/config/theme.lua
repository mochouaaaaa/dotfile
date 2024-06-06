local wezterm = require("wezterm")

local platform = require("utils.platform")

local font = "Monaco"
local font_size = platform().is_mac and 16 or 14

return {
	term = "xterm-256color",
	animation_fps = 60,
	max_fps = 60,

	font = wezterm.font {
		family = font,
		assume_emoji_presentation = false,
		harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
	},
	use_ime = true,
	font_size = font_size,
	line_height = 1.25,
	underline_position = 5,
	strikethrough_position = 5,

	freetype_load_target = "Light",
	freetype_render_target = "HorizontalLcd",
	-- freetype_load_flags = "NO_BITMAP",

	-- theme
	color_scheme = "Catppuccin Mocha",
	use_fancy_tab_bar = false,
	hide_tab_bar_if_only_one_tab = true,
	window_decorations = "RESIZE",
	show_new_tab_button_in_tab_bar = false,
	-- transparency
	window_background_opacity = 0.75,
	-- mac blur
	macos_window_background_blur = 20,
	-- text_background_opacity = 0.75,
	adjust_window_size_when_changing_font_size = false,

	window_padding = {
		left = 20,
		right = 20,
		top = 20,
		bottom = 5,
	},
}
