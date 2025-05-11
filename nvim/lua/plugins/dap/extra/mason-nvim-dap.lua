return {
	"jayp0521/mason-nvim-dap.nvim",
	enabled = not vim.g.IS_NIX,
	cmd = "DAPInstall",
	opts = {
		automatic_setup = true,
		handlers = {
			function(conf)
				require("mason-nvim-dap").default_setup(conf)
			end,
		},
	},
}
