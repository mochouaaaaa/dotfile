local utils = require("util.keymap")

return {
	{
		"milanglacier/minuet-ai.nvim",
		enabled = false,
		config = function()
			require("minuet").setup({
				provider = "openai_fim_compatible",
				n_completions = 1, -- recommend for local model for resource saving
				-- I recommend beginning with a small context window size and incrementally
				-- expanding it, depending on your local computing power. A context window
				-- of 512, serves as an good starting point to estimate your computing
				-- power. Once you have a reliable estimate of your local computing power,
				-- you should adjust the context window to a larger value.
				context_window = 512,
				provider_options = {
					openai_fim_compatible = {
						-- For Windows users, TERM may not be present in environment variables.
						-- Consider using APPDATA instead.
						api_key = "TERM",
						name = "Ollama",
						end_point = "http://localhost:11434/v1/completions",
						model = "qwen2.5-coder:7b-instruct-q8_0",
						optional = {
							max_tokens = 56,
							top_p = 0.9,
						},
					},
				},
				virtualtext = {
					-- Specify the filetypes to enable automatic virtual text completion,
					-- e.g., { 'python', 'lua' }. Note that you can still invoke manual
					-- completion even if the filetype is not on your auto_trigger_ft list.
					auto_trigger_ft = { "python", "lua", "go", "nix" },
					-- specify file types where automatic virtual text completion should be
					-- disabled. This option is useful when auto-completion is enabled for
					-- all file types i.e., when auto_trigger_ft = { '*' }
					auto_trigger_ignore_ft = { "*" },
					keymap = {
						accept = nil,
						accept_line = nil,
						accept_n_lines = nil,
						-- Cycle to next completion item, or manually invoke completion
						next = utils.platform_key.cmd("j"),
						-- Cycle to prev completion item, or manually invoke completion
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
					return action.accept()
				else
					return vim.api.nvim_replace_termcodes("<Tab>", true, true, true)
				end
			end, { expr = true, silent = true, desc = "Accept Minuet AI suggestion" })

			local key_map = {
				[utils.platform_key.cmd("j")] = action.next,
				[utils.platform_key.cmd("k")] = action.prev,
				[utils.platform_key.cmd("e")] = action.dismiss,
			}

			for key, action_func in pairs(key_map) do
				vim.notify("set keymap: " .. tostring(key))
				vim.keymap.set("i", key, function()
					vim.notify(is_visible())
					if is_visible() then
						return action_func()
					else
						return vim.api.nvim_replace_termcodes(key, true, true, true)
					end
				end, { expr = true, silent = true })
			end
		end,
	},
}
