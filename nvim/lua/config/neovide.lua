local function refresh()
	vim.g.neovide_refresh_rate = 60
	vim.g.neovide_refresh_rate_idle = 5
end

local BaseConfig = {}
BaseConfig.__index = BaseConfig

function BaseConfig:new()
	local _self = setmetatable({}, self)

	refresh()

	_self.config(self)
	_self.window_settings(self)
	_self.cursor(self)
	_self.background(self)
	_self.keymaps(self)

	return _self
end

function BaseConfig:config()
	vim.g.neovide_theme = "auto"
end

function BaseConfig:keymaps()
	local modes = { "n", "v", "c", "i" }

	-- System clipboard mappings
	for _, mode in ipairs(modes) do
		if mode == "c" or mode == "i" then
			vim.keymap.set(mode, "<D-v>", "<C-r>+", { silent = true })
			vim.keymap.set(mode, "<D-c>", "<C-r>+", { silent = true })
		else
			vim.keymap.set(mode, "<D-v>", ":r !xsel -b<CR>", { silent = true })
			vim.keymap.set(mode, "<D-c>", ":w !xsel -i -b<CR>", { silent = true })
		end
	end
end

function BaseConfig:cursor()
	-- vim.g.neovide_cursor_trail_size = 1.0
	-- vim.g.neovide_cursor_animation_length = 0.04
	vim.g.neovide_cursor_vfx_mode = "railgun"
	vim.g.neovide_cursor_vfx_particle_phase = 1.5 -- railgun
	vim.g.neovide_cursor_vfx_particle_curl = 1.0 -- railgun

	vim.g.neovide_cursor_vfx_opacity = 195.0 -- 200.0
	vim.g.neovide_cursor_vfx_particle_speed = 30.0 -- 10.0
	vim.g.neovide_cursor_vfx_particle_lifetime = 0.3 -- 0.5 (railgun, torpedo, pixiedust)
	vim.g.neovide_cursor_vfx_particle_density = 1.0 -- 0.7

	vim.g.neovide_cursor_animation_length = 0.04 -- Default 0.06
	vim.g.neovide_scroll_animation_length = 0.2
	vim.g.neovide_cursor_trail_length = 0.01
	vim.g.neovide_cursor_antialiasing = true
	vim.g.neovide_cursor_animate_in_insert_mode = true

	-- Railgun easing
	local Easing = require("util.neovide")
	Easing.bezier()
	local bezier = Easing.new("bezier")
	local configs = bezier:generateConfigs(5)
	bezier:setConfig(configs[1])
end

function BaseConfig:background()
	vim.g.neovide_opacity = 0.75
	vim.g.neovide_normal_opacity = 0.75
	vim.g.neovide_window_blurred = true

	vim.g.neovide_floating_shadow = false
	vim.g.neovide_floating_z_height = 10
	vim.g.neovide_light_angle_degrees = 45
	vim.g.neovide_light_radius = 0
	vim.g.neovide_floating_blur_amount_x = 2.0
	vim.g.neovide_floating_blur_amount_y = 2.0
end

function BaseConfig:window_settings()
	vim.g.neovide_remember_window_size = true
	vim.g.neovide_floating_corner_radius = 1

	vim.g.neovide_padding_top = 0
	vim.g.neovide_padding_right = 0
	vim.g.neovide_padding_left = 0
	vim.g.neovide_padding_bottom = 0
end

local DarwinConfig = setmetatable({}, { __index = BaseConfig })
DarwinConfig.__index = DarwinConfig

function DarwinConfig:keymaps()
	BaseConfig.keymaps(self)
	vim.g.neovide_input_macos_option_key_is_meta = "only_left"
end

function DarwinConfig:background()
	BaseConfig.background(self)
	vim.g.neovide_opacity = 0.75
	vim.g.neovide_window_blurred = true
	-- Helper function for transparency formatting
	local alpha = function()
		return string.format("%x", math.floor(255 * vim.g.transparency or 0.8))
	end
	-- g:neovide_opacity should be 0 if you want to unify transparency of content and title bar.
	vim.g.transparency = 0.8
	vim.g.neovide_background_color = "#1e1e2e" .. alpha()
end

function DarwinConfig:window_settings()
	BaseConfig.window_settings(self)
end

local LinuxConfig = setmetatable({}, { __index = BaseConfig })
LinuxConfig.__index = LinuxConfig

local platform = require("util.keymap")

if platform.is_mac() then
	DarwinConfig:new()
elseif platform.is_linux() then
	LinuxConfig:new()
end
