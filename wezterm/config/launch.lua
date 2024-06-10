local platform = require("utils.platform")()

local options = {
	default_prog = {},
	launch_menu = {},
}

-- 判断是否在 tmux 环境中
local function is_inside_tmux() return os.getenv("TMUX") ~= nil end

if platform.is_mac then
	options.default_prog = {
		"/usr/local/bin/zsh",
		-- "-l",
	}
	options.launch_menu = {}
end

return options
