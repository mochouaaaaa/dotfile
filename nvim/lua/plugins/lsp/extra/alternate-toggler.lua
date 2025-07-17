local M = {
	"rmagatti/alternate-toggler",
	event = { "BufReadPost" },

	keys = function()
		return {
			{
				"<leader>bt",
				"<cmd>lua require('alternate-toggler').toggleAlternate()<CR>",
				desc = "bool conversion",
			},
		}
	end,

	opts = {
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
	},
}

return M
