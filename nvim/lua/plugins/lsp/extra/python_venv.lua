local M = {
	"linux-cultist/venv-selector.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
	},
	branch = "regexp", -- This is the regexp branch, use this for the new version
	ft = "python",
}

function M.config()
	local wk = require("which-key")
	wk.add({
		{ "<leader>v", desc = "virtualvenv" },
	})

	local venv_selector = require("venv-selector")

	local function shorter_name(filename)
		return filename:gsub(os.getenv("HOME"), "~"):gsub("/bin/python", "")
	end

	venv_selector.setup({
		settings = {
			options = {
				debug = true,
				picker = "fzf-lua",
				on_telescope_result_callback = shorter_name,
			},
			search = {
				pyenv = {
					command = "fd python$ " .. os.getenv("PYENV_ROOT") .. "/versions --max-depth 3 --full-path -a -L",
					on_telescope_result_callback = shorter_name,
				},
			},
		},
	})
end

M.keys = function()
	return {
		-- Keymap to open VenvSelector to pick a venv.
		{ "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Open VenvSelector" },
	}
end

return M
