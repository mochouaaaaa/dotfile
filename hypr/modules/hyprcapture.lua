-- HyprCapture plugin settings.
-- The plugin itself must be installed against the exact running Hyprland build.

if not (hl.plugin and hl.plugin.hyprcapture) then
	return
end

hl.config {
	plugin = {
		hyprcapture = {
			default_mode = "region",
			save = true,
			save_dir = "$XDG_PICTURES_DIR/Screenshots",
			record_save_dir = "$XDG_VIDEOS_DIR/hyprland",
			clipboard = true,
			notification_backend = "system",
			screenshot_notification = true,
			screenshot_mode = "hdr",
			show_hdr_control = true,
			remember_settings = true,
			hdr_clipboard_format = "sdr",
		},
	},
}
