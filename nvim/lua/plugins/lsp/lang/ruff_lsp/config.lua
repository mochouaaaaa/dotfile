local M = {}

local env = require("plugins.configs.virtual_env")

function M.on_attach(client, buffer)
	-- Disable hover in favor of Pyright
	client.server_capabilities.hoverProvider = false
end

M.extra = function(config)
	return {
		init_options = {
			settings = {
				-- interpreter = { env.python_path() },

				args = {
					filetypes = { "python" },
				},
				codeAction = {
					disableRuleComment = {
						enable = false,
					},
				},
			},
		},
	}
end

return M
