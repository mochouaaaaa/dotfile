return {
	config = function(dap)
		dap.adapters.go = {
			type = "server",
			port = "${port}",
			executable = {
				command = "dlv",
				args = { "dap", "-l", "127.0.0.1:${port}" },
			},
		}
		-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md

		dap.configurations.go = {
			{
				type = "go",
				name = "Debug Single File",
				request = "launch",
				program = "${file}",
			},
			{
				type = "go",
				name = "Debug Cureent Project",
				request = "launch",
				program = ".",
			},
			{
				type = "go",
				name = "Debug test", -- configuration for debugging test files
				request = "launch",
				mode = "test",
				program = "${file}",
			},
			-- works with go.mod packages and sub packages
			{
				type = "go",
				name = "Debug test (go.mod)",
				request = "launch",
				mode = "test",
				program = "./${relativeFileDirname}",
			},
			{
				name = "Attach to process",
				type = "delve",
				request = "attach",
				mode = "local",
				processId = require("dap.utils").pick_process,
			},
		}
	end,
}
