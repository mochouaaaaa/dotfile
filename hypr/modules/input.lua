hl.config {
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		-- Keep XKB layout predictable; Chinese input is provided by fcitx5.
		kb_rules = "",
		repeat_rate = 40,
		repeat_delay = 200,

		sensitivity = 0,
		numlock_by_default = true,
		left_handed = false,
		follow_mouse = 1,
		mouse_refocus = 0,
		float_switch_override_focus = false,

		touchpad = {
			clickfinger_behavior = true,
			middle_button_emulation = true,
			tap_to_click = true,
			drag_lock = false,
			drag_3fg = 1,
			natural_scroll = true,
			disable_while_typing = true,
			scroll_factor = 1.15,
		},

		touchdevice = {
			enabled = true,
		},

		tablet = {
			transform = 0,
			left_handed = 0,
		},
	},

	binds = {
		workspace_back_and_forth = true,
		allow_workspace_cycles = true,
		pass_mouse_when_bound = false,
		scroll_event_delay = 0,
	},

}

-- Hyprland 0.51+ replaced workspace_swipe_* with the gesture system.
hl.gesture {
	fingers = 4,
	direction = "horizontal",
	action = "workspace",
}
