return {
	config = function(dap)
		local dap_root = require("mason-registry").get_package("node-debug2-adapter"):get_install_path()
		dap.adapters.node2 = {
			type = "executable",
			command = "node",
			args = { dap_root .. "/out/src/nodeDebug.js" },
		}
		dap.configurations.javascript = {
			{
				name = "Launch",
				type = "node2",
				request = "launch",
				program = "${file}",
				cwd = vim.fn.getcwd(),
				sourceMaps = true,
				protocol = "inspector",
				console = "integratedTerminal",
			},
			{
				name = "Attach to process",
				type = "node2",
				request = "attach",
				processId = require("dap.utils").pick_process,
			},
		}
	end,
}
