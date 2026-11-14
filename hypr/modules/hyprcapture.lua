-- HyprCapture plugin settings.
-- The plugin itself must be installed against the exact running Hyprland build.
hl.config {
	plugin = {
		hyprcapture = {
			default_mode = "region",
			save = true,
			save_dir = "$XDG_PICTURES_DIR/Screenshots",
			record_save_dir = "$XDG_VIDEOS_DIR/hyprland",
		},
	},
}
