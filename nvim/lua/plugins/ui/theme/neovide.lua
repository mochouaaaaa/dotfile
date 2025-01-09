local M = {}

function M.background()
	vim.g.transparency = 0.75
	local alpha = function()
		return string.format("%x", math.floor((255 * vim.g.transparency)))
	end
	vim.g.neovide_transparency = 0.75
	vim.g.neovide_normal_opacity = 0.75
	vim.g.neovide_background_color = "#1e1e2e" .. alpha()
	vim.g.neovide_window_blurred = 0.8
	vim.g.neovide_floating_blur_amount_x = 2.0
	vim.g.neovide_floating_blur_amount_y = 2.0
	vim.g.neovide_floating_shadow = true
	vim.g.neovide_floating_z_height = 10
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
	vim.g.neovide_remember_window_size = true
	-- vim.g.neovide_show_broder = true
	vim.g.neovide_input_macos_option_key_is_meta = "only_left"
	vim.g.neovide_cursor_vfx_mode = "railgun"
end

function M.init()
	M.config()
	M.keymap()
	M.background()
	M.refresh()
end

return M
