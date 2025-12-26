return {
	"akinsho/toggleterm.nvim",
	cmd = { "ToggleTerm", "ToggleTermToggleAll" },
	keys = {
		{ "<C-\\>", "<cmd>ToggleTerminal<cr>", desc = "Toggle Toggleterm" },
		-- 可选：保留官方 toggle all
		-- { "<leader>uP", "<cmd>ToggleTermToggleAll<cr>", desc = "Toggle All ToggleTerm" },
		-- 可选：强制关闭当前 terminal
		-- { "<leader>uq", "<cmd>ToggleTermShutdown<cr>", desc = "Shutdown Current ToggleTerm" },
	},
	opts = {
		-- 行为明确，不搞“状态魔法”
		auto_scroll = false,
		persist_mode = false,
		persist_size = false,

		close_on_exit = true,

		-- 交互体验
		start_in_insert = true,
		insert_mappings = true,
		terminal_mappings = true,

		-- 视觉相关
		shade_terminals = false,

		winbar = {
			enabled = false,
		},
	},
	config = function()
		-- =========================
		-- ToggleTerm main terminal
		-- =========================

		local Terminal = require("toggleterm.terminal").Terminal

		-- 主 terminal（复用）
		local main_term = Terminal:new({
			direction = "horizontal",
			close_on_exit = false,
			start_in_insert = true,
		})

		-- Toggle 主 terminal
		local function toggle_main_terminal()
			main_term:toggle()
		end

		-- 安全关闭当前 focused terminal
		local function shutdown_current_terminal()
			local terminal = require("toggleterm.terminal")
			local id = terminal.get_focused_id()
			if not id then
				return
			end

			local term = terminal.get(id)
			if not term then
				return
			end

			-- 先切回其他窗口，避免焦点丢失
			vim.cmd("wincmd p")
			term:shutdown()
		end

		-- =========================
		-- User Commands
		-- =========================

		vim.api.nvim_create_user_command("ToggleTerminal", toggle_main_terminal, {})
		vim.api.nvim_create_user_command("ToggleTermShutdown", shutdown_current_terminal, {})

		vim.keymap.set("t", "<C-\\>", [[<C-\><C-n><cmd>ToggleTerminal<CR>]], { desc = "Toggle Toggleterm" })
	end,
}
