return function(_, opts)
	local luasnip = require("luasnip")

	if opts then
		luasnip.config.set_config(opts)
	end

	vim.tbl_map(function(type) require("luasnip.loaders.from_" .. type).lazy_load() end, { "vscode", "snipmate", "lua" })
end
