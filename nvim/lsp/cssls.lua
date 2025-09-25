local common = require("util.lsp")

return {
	on_attach = function(client, bufnr)
		common.setup(client, bufnr)
	end,
	capabilities = common.make_capabilities(),
	filetypes = { "css", "scss", "less", "typescriptreact", "javascriptreact" },
}
