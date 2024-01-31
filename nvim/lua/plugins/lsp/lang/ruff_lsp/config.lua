local M = {}

function M.on_attach(client, buffer)
	-- Disable hover in favor of Pyright
	client.server_capabilities.hoverProvider = false
end

M.extra = function(config) return {} end

return M
