local M = {}

function M.on_attach(client, buffer)
	vim.api.nvim_create_autocmd("BufWritePost", {
		pattern = "*/Cargo.toml",
		callback = function()
			for _, client in ipairs(vim.lsp.get_active_clients()) do
				if client.name == "rust_analyzer" then
					client.request("rust-analyzer/reloadWorkspace", nil, function() end, 0)
				end
			end
		end,
		group = vim.api.nvim_create_augroup("RustWorkspaceRefresh", { clear = true }),
	})
end

return M
