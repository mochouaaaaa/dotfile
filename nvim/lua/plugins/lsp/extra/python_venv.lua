local M = {
	"mochouaaaaa/venv-selector.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
	},
	branch = "regexp", -- This is the regexp branch, use this for the new version
	ft = "python",
	-- enabled = os.getenv("PYENV_ROOT") ~= nil,
}

function M.config()
	local venv_selector = require("venv-selector")

	local function shorter_name(filename)
		return filename:gsub(os.getenv("HOME"), "~"):gsub("/bin/python", "")
	end

	vim.defer_fn(function()
		local clients = vim.lsp.get_active_clients({ bufnr = 0 })
		for _, client in ipairs(clients) do
			if client.name == "basedpyright" then
				venv_selector.setup({
					settings = {
						options = {
							debug = true,
							on_telescope_result_callback = shorter_name,
						},
						search = {
							-- cwd = false,
							pyenv = {
								command = "fd python$ "
									.. os.getenv("PYENV_ROOT")
									.. "/versions --max-depth 3 --full-path -a -L",
								on_telescope_result_callback = shorter_name,
							},
						},
					},
				})
				return
			end
		end
		-- vim.notify("[venv-selector] Skipped: basedpyright not active")
	end, 300) -- 延迟 300ms
end

M.keys = {
	-- Keymap to open VenvSelector to pick a venv.
	{ "<leader>vs", "<cmd>VenvSelect<cr>" },
}

return M
