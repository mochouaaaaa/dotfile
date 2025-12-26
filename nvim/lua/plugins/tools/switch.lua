return {
	"AndrewRadev/switch.vim",
	config = function()
		vim.keymap.set("n", "`", function()
			vim.cmd([[Switch]])
		end, { desc = "Switch strings" })

		vim.g.switch_custom_definitions = {
			{ ",", ";" },
			{ ":", "=" },
			-- 逻辑开关
			{ "on", "off" },
			{ "yes", "no" },
			{ "allow", "deny" },
			{ "enable", "disable" },
			{ "enabled", "disabled" },
			{ "1", "0" },
			{ "is", "is not" },
			-- { "is not", "is" },
			-- 样式/状态
			{ "left", "right" },
			{ "top", "bottom" },
			{ "up", "down" },
			{ "high", "low" },
			-- 状态
			{ "> [!TODO]", "> [!WIP]", "> [!DONE]", "> [!FAIL]" },
		}
	end,
}
