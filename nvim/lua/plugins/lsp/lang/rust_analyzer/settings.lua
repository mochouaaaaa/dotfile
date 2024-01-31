return {
	["rust-analyzer"] = {
		tools = { 
			inlay_hints = {
				auto = false,
			} 
		},
		cargo = {
			allFeatures = { allFeatures = true },
			proMacro = { enabled = true },
			checkOnSave = { command = "clippy" },
		},
	},
}
