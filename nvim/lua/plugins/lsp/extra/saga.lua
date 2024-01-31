local saga = {
	"nvimdev/lspsaga.nvim",
	event = "LspAttach",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
}

function saga.config()
	require("lspsaga").setup {
		ui = {
			kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
			border = "rounded",
		},
		diagnostic = {
			-- Uses <C-f> and <C-b> to preview code action.
			on_insert = true,
			on_insert_follow = true,
			-- insert_winblend = 100,
			-- 在诊断跳转窗口中显示代码操作
			show_code_action = true,
			show_source = true,
			show_layout = "float",
			-- 启用数字快捷方式以快速执行代码操作
			jump_num_shortcut = true,
			-- max_width = 0.7,
			-- max_height = 0.6,
			-- max_show_width = 0.9,
			-- max_show_height = 0.6,
			-- 诊断跳转窗口文本突出显示遵循诊断类型
			text_hl_follow = true,
			-- 诊断跳转窗口边框跟随诊断类型
			border_follow = true,
			-- extend_relatedInformation = false,
			-- 仅显示当前行上的诊断虚拟文本
			diagnostic_only_current = false,
			keys = {
				exec_action = "o",
				quit = "q",
				go_action = "g",
				expand_or_jump = "<CR>",
				quit_in_show = { "q", "<ESC>" },
			},
		},
		hover = {
			open_link = "gx",
			open_cmd = "!chrome",
		},
		definition = {
			keys = {
				edit = "o",
				vsplit = "|",
				split = "_",
				tabe = "t",
				quit = "q",
				close = "<Esc>",
			},
		},
		code_action = {
			extend_gitsigns = true,
			num_shortcut = true,
			show_server_name = true,
			keys = {
				quit = "q",
				exec = { "<CR>", "o" },
			},
		},
		lightbulb = {
			enable = true,
			enable_in_insert = true,
			sign = true,
			sign_priority = 40,
			virtual_text = true,
		},
		rename = {
			quit = "q",
			exec = "<CR>",
			mark = "m",
			confirm = "<CR>",
			in_select = true,
		},
		-- outline = {
		-- 	win_position = "right",
		-- 	win_with = "",
		-- 	-- win_width = 30,
		-- 	show_detail = false,
		-- 	auto_preview = true,
		-- 	auto_refresh = true,
		-- 	auto_close = true,
		-- 	custom_sort = nil,
		-- 	close_after_jump = false,
		-- 	keys = {
		-- 		jump = "o",
		-- 		toggle_or_jump = "o",
		-- 		expand_collaspe = "u",
		-- 		quit = "q",
		-- 	},
		-- },
		-- :Lspsaga incoming_calls 以及 :Lspsaga outgoing_calls
		-- callhierarchy = {
		-- 	show_detail = true,
		-- 	layout = "float",
		-- 	keys = {
		-- 		edit = "o",
		-- 		vsplit = "|",
		-- 		split = "_",
		-- 		tabe = "t",
		-- 		jump = "j",
		-- 		quit = "q",
		-- 		expand_collaspe = "u",
		-- 	},
		-- },
		implement = {
			enable = true,
			sign = true,
			virtual_text = true,
			priority = 100,
		},
		-- conflict with lualine plugin when enable is true
		symbol_in_winbar = {
			enable = false,
			separator = " ",
			hide_keyword = true,
			show_file = true,
			folder_level = 2,
		},
	}

	local wk = require("which-key")
	wk.register {
		["<leader>c"] = {
			name = "Code Manager",
			-- a = { "<CMD>Lspsaga code_action<CR>", "Code Action Diagnostic" },
			["["] = { "<CMD>Lspsaga diagnostic_jump_next<CR>", "Jump Next Code Action Diagnostic" },
			["]"] = { "<CMD>Lspsaga diagnostic_jump_prev<CR>", "Jump Prev Code Action Diagnostic" },
		},
	}
end

local outline = {

	"hedyhli/outline.nvim",
	lazy = true,
	cmd = { "Outline", "OutlineOpen" },
	keys = { -- Example mapping to toggle outline
		{ "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
	},
	opts = {
		-- Your setup opts here
		symbols = {
			filter = {
				default = {
					"String",
					"Variable",
					exclude = true,
				},
				python = { "Function", "Class", "Method" },
			},
		},
	},
}

function outline.config(_, opts) require("outline").setup(opts) end

outline.keys = {
	{
		"<leader>dg",
		"<cmd>Outline<CR>",
		mode = { "n" },
		desc = "大纲",
	},
	{
		"go",
		"<cmd>OutlineFollow<CR>",
		mode = { "n" },
		desc = "jump to outline",
	},
}

return {
	saga,
	outline,
}
