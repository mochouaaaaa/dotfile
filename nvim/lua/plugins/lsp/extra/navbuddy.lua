local border_style = "rounded"

return {
	"SmiteshP/nvim-navbuddy",
	dependencies = {
		"SmiteshP/nvim-navic",
	},
	keys = {
		{
			"<leader>sl",
			function()
				require("nvim-navbuddy").open()
			end,
			desc = "Navbuddy",
		},
	},
	opts = {
		window = {
			size = { width = "80%", height = "80%" },
			position = { row = "98%", col = "50%" },
			sections = {
				left = {
					border = {
						style = border_style,
					},
				},
				mid = {
					border = {
						style = border_style,
					},
				},
				right = {
					border = border_style,
					preview = "leaf", -- "leaf", "always" or "never"
				},
			},
		},
		lsp = { auto_attach = true },
	},
	config = function(_, opts)
		local links = {
			NavbuddyArray = "@punctuation",
			NavbuddyBoolean = "@boolean",
			NavbuddyClass = "@lsp.type.class",
			NavbuddyConstant = "@constant",
			NavbuddyConstructor = "@constructor",
			NavbuddyEnum = "@lsp.type.enum",
			NavbuddyEnumMember = "@lsp.type.enumMember",
			NavbuddyEvent = "@field",
			NavbuddyField = "@field",
			NavbuddyFunction = "@function",
			NavbuddyInterface = "@lsp.type.interface",
			NavbuddyKey = "@keyword",
			NavbuddyMethod = "@method",
			NavbuddyModule = "@module",
			NavbuddyNamespace = "@namespace",
			NavbuddyNull = "@constant",
			NavbuddyNumber = "@number",
			NavbuddyObject = "@lsp.type.class",
			NavbuddyOperator = "@operator",
			NavbuddyPackage = "@namespace",
			NavbuddyProperty = "@parameter",
			NavbuddyString = "@string",
			NavbuddyStruct = "@lsp.type.struct",
			NavbuddyTypeParameter = "@lsp.type.typeParameter",
			NavbuddyVariable = "@variable",
		}

		local function apply_hl()
			for from, to in pairs(links) do
				vim.api.nvim_set_hl(0, from, { link = to })
			end
		end

		apply_hl()

		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = apply_hl,
		})
	end,
}
