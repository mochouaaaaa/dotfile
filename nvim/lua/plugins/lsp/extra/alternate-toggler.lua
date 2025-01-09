local M = {
	"rmagatti/alternate-toggler",
	event = { "BufReadPost" },
}

function M.keys()
	return {
		{
			"<leader>bt",
			"<cmd>lua require('alternate-toggler').toggleAlternate()<CR>",
			desc = "bool conversion",
		},
	}
end

function M.opts(_, opts)
	return {
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
	}
end

return M
