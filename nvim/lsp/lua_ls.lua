return {
	on_attach = function(client, bufnr) end,
	settings = {
		Lua = {
			cmd = { "lua-language-server" },
			runtime = {
				version = "LuaJIT",
			},
			format = {
				enable = false,
				defaultConfig = {
					indent_style = "space",
					indent_size = 4,
					quote_style = "single",
					align_call_args = false,
					align_function_params = false,
					align_continuous_assign_statement = false,
					align_continuous_rect_table_field = false,
					align_array_table = true,
				},
			},
			diagnostics = {
				disable = { "lowercase-global", "duplicate-set-field", "unused-function", "unused-local" },
				globals = { "vim" },
			},
			workspace = {
				checkThirdParty = false,
				ignoreDir = { ".vscode", "node_modules" },
			},
			telemetry = {
				enable = false,
			},
			-- hint = {
			-- 	enable = true,
			-- 	arrayIndex = "Enable",
			-- 	setType = true,
			-- },
		},
	},
}
