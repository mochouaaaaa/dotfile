return {
	config = function(dap)
		local dap_root = require("mason-registry").get_package("codelldb"):get_install_path() .. "/extension/"
		dap.adapters.codelldb = {
			type = "server",
			port = "${port}",
			host = "127.0.0.1",
			executable = {
				command = dap_root .. "adapter/codelldb",
				args = { "--liblldb", dap_root .. "lldb/lib/liblldb.dylib", "--port", "${port}" },
			},
		}

		dap.configurations.rust = {
			{
				name = "Debug",
				type = "codelldb",
				request = "launch",
				program = "${file}",
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
			},
		}
		dap.configurations.c = dap.configurations.rust
		dap.configurations.cpp = dap.configurations.rust
	end,
}
