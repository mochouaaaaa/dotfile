local utils = require("util.keymap")

return {
	{
		"milanglacier/minuet-ai.nvim",
		enabled = true,
		config = function()
			require("minuet").setup({
				provider = "openai_fim_compatible",
				n_completions = 1,
				context_window = 2048,
				provider_options = {
					openai_fim_compatible = {
						api_key = "TERM",
						name = "Ollama",
						end_point = "http://localhost:11434/v1/completions",
						model = "qwen2.5-coder:7b",
						optional = {
							-- max_tokens = 56,
							max_tokens = 96,
							top_p = 0.9,
						},
					},
				},
				virtualtext = {
					auto_trigger_ft = { "python", "lua", "go", "nix", "rust", "dash" },
					auto_trigger_ignore_ft = { "*" },
					keymap = {
						accept = nil,
						accept_line = nil,
						accept_n_lines = nil,
						next = utils.platform_key.cmd("j"),
						prev = utils.platform_key.cmd("k"),
						dismiss = utils.platform_key.cmd("e"),
					},
					show_on_completion_menu = true,
				},
			})

			local action = require("minuet.virtualtext").action

			local function is_visible()
				return action.is_visible()
			end

			vim.keymap.set("i", "<Tab>", function()
				if is_visible() then
					action.accept()
					return
				end
				local tab = vim.api.nvim_replace_termcodes("<Tab>", true, false, true)
				vim.api.nvim_feedkeys(tab, "n", false)
			end, { silent = true, desc = "Accept Minuet AI suggestion" })

			local key_map = {
				[utils.platform_key.cmd("j")] = action.next,
				[utils.platform_key.cmd("k")] = action.prev,
				[utils.platform_key.cmd("e")] = action.dismiss,
			}

			for key, action_func in pairs(key_map) do
				vim.keymap.set("i", key, function()
					if is_visible() then
						action_func()
						return
					end
					local raw_key = vim.api.nvim_replace_termcodes(key, true, false, true)
					vim.api.nvim_feedkeys(raw_key, "n", false)
				end, { silent = true })
			end
		end,
	},
}
