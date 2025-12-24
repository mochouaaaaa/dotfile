return {
	"rebelot/heirline.nvim",
	opts = function(_, opts)
		local lib = require("heirline-components.all")
		local condition = require("heirline-components.core.condition")

		local config = {
			statusline = { -- UI statusbar
				-- hl = { fg = "fg", bg = "bg" },
				lib.component.mode(),
				lib.component.git_branch(),
				lib.component.cmd_info(),

				-- center
				lib.component.fill(),
				{
					provider = function()
						local emoji = { "🚫", "⏸️", "⌛️", "⚠️", "0️⃣ ", "✅" }
						return emoji[require("fittencode").get_current_status()]
					end,
					condition = function()
						return package.loaded.fittencode and condition.lsp_attached()
					end,
				},
				lib.component.lsp({ lsp_progress = false }),
				lib.component.fill(),

				lib.component.compiler_state(),
				{
					condition = function()
						return vim.bo.filetype == "python"
					end,
					lib.component.virtual_env(),
				},
				lib.component.nav(),
				lib.component.mode({ surround = { separator = "right" } }),
			},
		}

		return vim.tbl_deep_extend("force", opts, config)
	end,
}
