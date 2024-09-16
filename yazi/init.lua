require("full-border"):setup {
	-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
	type = ui.Border.ROUNDED,
}

require("git"):setup()
THEME.git_modified_sign = "M"
THEME.git_deleted_sign = "D"
