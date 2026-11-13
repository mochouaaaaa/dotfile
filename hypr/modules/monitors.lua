-- Use the monitor's preferred mode instead of hard-coding a 4K mode.
-- Override this module per-host when a fixed refresh rate, scale, or position is needed.
hl.monitor {
	output = "DP-1",
	mode = "preferred",
	position = "auto",
	scale = 1,
	cm = "auto",
}

hl.config {
	xwayland = {
		force_zero_scaling = true,
	},
}
