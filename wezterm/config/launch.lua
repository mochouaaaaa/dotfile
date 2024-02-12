local platform = require("utils.platform")()

local options = {
	default_prog = {},
	launch_menu = {},
}

if platform.is_mac then
	options.default_prog = {
		"/usr/local/bin/zsh",
		"--login",
	}
	options.launch_menu = {}
end

return options
