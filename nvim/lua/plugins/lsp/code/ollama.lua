local utils = require("util.keymap")

return {
	{
		"saghen/blink.cmp",
		opts = { completion = { trigger = { prefetch_on_insert = false } } },
	},
	{
		"milanglacier/minuet-ai.nvim",
		enabled = true,
		config = function()
			require("minuet").setup({
				-- provider = "openai_fim_compatible",
				provider = "codestral",
				-- provider = "gemini",
				n_completions = 1, -- 本地单卡设 1 避免 Ollama 排队推理，延迟最低
				context_window = 4144, -- 兼顾上下文理解与 10GB 显存响应速度
				request_timeout = 3,
				throttle = 600, -- 连续打字节流（毫秒），减少无效请求
				debounce = 300, -- 停顿后再触发
				provider_options = {
					openai_fim_compatible = {
						api_key = "TERM", -- Ollama 本地无需真实 key，填任意非空环境变量名即可
						name = "Ollama",
						end_point = "http://localhost:11434/v1/completions",
						model = "qwen2.5-coder:7b",
						optional = {
							max_tokens = 160,
							top_p = 0.9,
						},
					},
					codestral = {
						model = "codestral-latest",
						end_point = "https://codestral.mistral.ai/v1/fim/completions",
						api_key = "CODESTRAL_API_KEY",
						stream = true,
						optional = {
							max_tokens = 256,
							stop = { "\n\n" },
						},
					},
					gemini = {
						model = "gemini-3.5-flash-lite", -- Recommended duet model at the moment.
						api_key = "GEMINI_API_KEY",
						end_point = "https://generativelanguage.googleapis.com/v1beta/models",
						transform = {},
						optional = {
							generationConfig = {
								maxOutputTokens = 256,
								thinkingConfig = {
									-- Disable thinking for gemini 2.5 models
									-- thinkingBudget = 0,
									-- Disable thinking for gemini 3.x models
									thinkingLevel = "minimal",
									-- Setting only one of the above options is sufficient.
								},
							},
						},
					},
				},
				virtualtext = {
					auto_trigger_ft = { "lua", "nix", "python", "rust", "typescript", "javascript", "go", "sh" },
					auto_trigger_ignore_ft = { "TelescopePrompt", "neo-tree", "lazy", "mason" },
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
