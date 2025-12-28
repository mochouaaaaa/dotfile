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
					init = function(self)
						self.fittencode = require("fittencode")
					end,
					provider = function(self)
						local symbols = {
							"🤖", -- 1: 智能/不可用？
							" ", -- 2: 暂停/建议
							" ", -- 3: AI 生成/处理中
							" ", -- 4: 警告/错误
							" ", -- 5: 工具/待处理
							" ", -- 6: 成功/完成
						}
						return "  " .. symbols[self.fittencode.get_current_status()]
						-- local emoji = { "🚫", "⏸️", "⌛️", "⚠️", "0️⃣ ", "✅" }
						-- return emoji[require("fittencode").get_current_status()]
					end,
					condition = function(self)
						if not package.loaded.fittencode then
							return false
						end

						if not condition.lsp_attached(self.bufnr) then
							return false
						end

						local status = require("fittencode").get_current_status()

						-- ⏸️ 状态（2）不显示
						return status ~= 2
						-- return package.loaded.fittencode and condition.lsp_attached()
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
