local M = {}

M.keys = {
	{
		"<f5>",
		function()
			require("telescope").extensions.dap.configurations()
			-- require("dap").continue()
		end,
		desc = "list debug config",
	},
	{
		"<leader>db",
		function()
			require("dap").toggle_breakpoint()
		end,
		desc = "set debug point",
	},
	{
		"<leader>dbc",
		function()
			require("dap").clear_breakpoints()
		end,
		desc = "clear all points",
	},
}

return M
