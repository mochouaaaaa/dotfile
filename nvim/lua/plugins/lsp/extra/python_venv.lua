local M = {
	"mochouaaaaa/venv-selector.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
	},
	branch = "regexp", -- This is the regexp branch, use this for the new version
	event = { "BufReadPost", "BufNewFile" },
	ft = "python",
	-- enabled = os.getenv("PYENV_ROOT") ~= nil,
}

function M.config()
	local venv_selector = require("venv-selector")

	local function shorter_name(filename)
		return filename:gsub(os.getenv("HOME"), "~"):gsub("/bin/python", "")
	end

	venv_selector.setup({
		settings = {
			options = {
				debug = true,
				on_telescope_result_callback = shorter_name,
			},
			search = {
				-- cwd = false,
				pyenv = {
					command = "fd python$ " .. os.getenv("PYENV_ROOT") .. "/versions --max-depth 3 --full-path -a -L",
					on_telescope_result_callback = shorter_name,
				},
			},
		},
	})
end

M.keys = {
	-- Keymap to open VenvSelector to pick a venv.
	{ "<leader>vs", "<cmd>VenvSelect<cr>" },
}

return M
