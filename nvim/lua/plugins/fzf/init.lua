return {
	{ import = "plugins.fzf" },
	{
		"ibhagwan/fzf-lua",
		lazy = false,
		opts = {
			"hide", --"telescope",
			border = "rounded",
			fzf_colors = true,
			fzf_opts = {
				["--color"] = "bg:-1,marker:-1,pointer:4", --,bg+:1
				["--ansi"] = false,
				["--pointer"] = vim.g.icons.Telescope.Care,
			},
			hls = {
				title = "Normal",
				title_flags = "NormalFloat",
				preview_title = "NormalFloat",

				normal = "NormalFloat", -- 对应 fzf 的 bg
				border = "FloatBorder", -- 对应 fzf 的 border

				-- cursor = "Cursor",
				cursor = "IncCursor",
				-- cursor = "TermCursor",
				cursorline = "CursorLine", -- 对应 fzf 的 bg+
				-- cursorline = "Visual", -- 使用主题的选中高亮组
				cursorlinenbr = "CursorLineNr",

				search = "Search", -- 对应 fzf 的 hl
				preview_normal = "NormalFloat",
				preview_border = "FloatBorder",
			},
			lsp = {
				async = false,
			},
			file_icon_padding = " ",
			winopts = {
				preview = {
					image_previewer = "auto",
				},
			},
		},
	},
}
