local platform = require("utils.platform")()

local options = {
	default_prog = {},
	launch_menu = {},
}

-- 判断是否在 tmux 环境中
local function is_inside_tmux() return os.getenv("TMUX") ~= nil end

local function get_shell()
	local default_shell = os.getenv("SHELL")
	if default_shell and string.find(default_shell, "zsh") then
		return default_shell
	end
	return "zsh"
end

if platform.is_mac then
	options.default_prog = {
		get_shell(),
	}
	options.launch_menu = {}
end

return options
