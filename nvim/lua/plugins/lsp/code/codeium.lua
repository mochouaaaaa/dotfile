local utils = require("util.keymap")

-- quick sort list function

return {
	"Exafunction/windsurf.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"hrsh7th/nvim-cmp",
	},
	enabled = false,
	config = function()
		require("codeium").setup({
			config_path = os.getenv("XDG_DATA_HOME") .. "/nvim/codeium/config",
			bin_path = os.getenv("XDG_DATA_HOME") .. "/nvim/codeium/bin",
			detect_proxy = true,
			virtual_text = {
				enaled = true,
				filetypes = {
					python = true,
					nix = true,
					lua = true,
					go = true,
					markdown = false,
					json = false,
				},
				key_bindings = {
					next = utils.platform_key.cmd("j"),
					prev = utils.platform_key.cmd("k"),
					clear = utils.platform_key.cmd("e"),
				},
			},
			workspace_root = {
				use_lsp = true,
			},
			wrapper = {
				"steam-run",
				"/nix/store/y6hkqiyjprl5wcxixrxad6njnxn44nxg-codeium-1.46.3/bin/codeium_language_server",
			},
		})
	end,
	-- config = function()
	-- 	local utils = require("util.keymap")
	--
	-- 	vim.g.codeium_disable_bindings = 1
	-- 	vim.keymap.set("i", "<Tab>", function()
	-- 		return vim.fn["codeium#Accept"]()
	-- 	end, { expr = true, silent = true })
	-- 	vim.keymap.set("i", utils.platform_key.cmd("j"), function()
	-- 		return vim.fn["codeium#CycleCompletions"](1)
	-- 	end, { expr = true, silent = true })
	-- 	vim.keymap.set("i", utils.platform_key.cmd("k"), function()
	-- 		return vim.fn["codeium#CycleCompletions"](-1)
	-- 	end, { expr = true, silent = true })
	-- 	vim.keymap.set("i", utils.platform_key.cmd("e"), function()
	-- 		return vim.fn["codeium#Clear"]()
	-- 	end, { expr = true, silent = true })
	-- end,
}
