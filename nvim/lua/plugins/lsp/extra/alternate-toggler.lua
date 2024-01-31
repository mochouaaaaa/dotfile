local M = {
	"rmagatti/alternate-toggler",
	event = { "BufReadPost" },
}

function M.config()
	require("alternate-toggler").setup({
		alternates = {
			["=="] = "!=",
			["true"] = "false",
			["True"] = "False",
			["TRUE"] = "FALSE",
			["Yes"] = "No",
			["YES"] = "NO",
			["1"] = "0",
			["<"] = ">",
			["("] = ")",
			["["] = "]",
			["{"] = "}",
			['"'] = "'",
			['""'] = "''",
			["+"] = "-",
			["==="] = "!==",
		},
	})

	vim.keymap.set(
		"n",
		"<leader>bt",
		"<cmd>lua require('alternate-toggler').toggleAlternate()<CR>",
		{ desc = "bool conversion" }
	)
end

return M
