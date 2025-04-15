local M = {}

function M.background()
	vim.g.neovide_floating_blur_amount_x = 2.0
	vim.g.neovide_floating_blur_amount_y = 2.0
	vim.g.neovide_floating_shadow = true
	vim.g.neovide_floating_z_height = 10

	vim.g.neovide_opacity = 0.75
	vim.g.neovide_normal_opacity = 1
end

function M.window_settings()
	vim.g.neovide_padding_top = 0
	vim.g.neovide_padding_bottom = 0
	vim.g.neovide_padding_right = 0
	vim.g.neovide_padding_left = 0
	vim.g.neovide_remember_window_size = true

	vim.g.neovide_floating_corner_radius = 1

	vim.g.neovide_window_blurred = true -- mac
end

function M.refresh()
	vim.g.neovide_refresh_rate = 60
	vim.g.neovide_refresh_rate_idle = 5
end

function M.keymap()
	vim.keymap.set("n", "<D-v>", '"+p', { noremap = true, silent = true }) -- 普通模式下
	vim.keymap.set("i", "<D-v>", "<C-r>+", { noremap = true, silent = true }) -- 插入模式下
end

function M.config()
	vim.g.neovide_show_broder = false
	vim.g.neovide_input_macos_option_key_is_meta = "only_left" -- mac
	vim.g.neovide_cursor_vfx_mode = "railgun"
end

function M.init()
	M.config()
	M.keymap()
	M.background()
	M.window_settings()
	M.refresh()
end

M.init()
