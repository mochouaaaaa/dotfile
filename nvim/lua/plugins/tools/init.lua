local utils = require("config.utils")

return {
	{
		import = "plugins.tools.extra",
	},
	{
		"theniceboy/joshuto.nvim",
		cond = not vim.g.vscode,
		config = function()
			vim.api.nvim_set_keymap("n", utils.platform_key("cmd") .. "-r>", "", {
				noremap = true,
				callback = function() require("joshuto").joshuto() end,
				desc = "joshuto file manager",
			})
		end,
	},
	-- {
	-- 	"rmagatti/auto-session",
	-- 	cond = not vim.g.vscode,
	-- 	config = function()
	-- 		local cwd = vim.fn.getcwd()
	--
	-- 		local function shutdown_term()
	-- 			local terms = require("toggleterm.terminal")
	-- 			local terminals = terms.get_all()
	-- 			for _, terminal in pairs(terminals) do
	-- 				terminal:shutdown()
	-- 			end
	-- 		end
	--
	-- 		require("auto-session").setup {
	-- 			log_level = "info",
	-- 			auto_session_enabled = true,
	-- 			auto_save_enabled = true,
	-- 			auto_restore_enabled = true,
	-- 			auto_session_enable_last_session = true,
	-- 			auto_session_root_dir = cwd .. "/.session/",
	-- 			auto_session_use_git_branch = nil,
	-- 			auto_session_suppress_dirs = { "~/", "~/.config/*", "/" },
	-- 			bypass_session_save_file_types = { "alpha", "dashboard", "lazy", "mason" },
	-- 			pre_save_cmds = {
	-- 				shutdown_term,
	-- 			},
	--
	-- 			cwd_change_handling = {
	-- 				restore_upcoming_session = true, -- already the default, no need to specify like this, only here as an example
	-- 				pre_cwd_changed_hook = nil, -- already the default, no need to specify like this, only here as an example
	-- 				post_cwd_changed_hook = function() -- example refreshing the lualine status line _after_ the cwd changes
	-- 					require("lualine").refresh() -- refresh lualine so the new session name is displayed in the status bar
	-- 				end,
	-- 			},
	-- 		}
	--
	-- 		vim.keymap.set("n", "<leader>ss", "<Cmd>SessionSave<CR>", { desc = "save session" })
	--
	-- 		vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
	-- 	end,
	-- },
}
