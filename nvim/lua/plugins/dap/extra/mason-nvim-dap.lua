return {
	"jayp0521/mason-nvim-dap.nvim",
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
