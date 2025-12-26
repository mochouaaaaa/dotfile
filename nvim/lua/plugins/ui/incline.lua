local separator_char = "-"
local unfocused = "NonText"
local focused = "Identifier"

local lazy_icons = require("lazyvim.config").icons

-- 获取诊断标签
local function get_diagnostic_label(buf, is_focused)
	local icons = lazy_icons.diagnostics
	local labels = {}
	for severity, icon in pairs(icons) do
		local n = #vim.diagnostic.get(buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
		if n > 0 then
			labels[#labels + 1] = {
				icon .. n .. " ",
				group = is_focused and ("DiagnosticSign" .. severity) or unfocused,
			}
		end
	end
	return labels
end

-- 获取 git diff 标签
local function get_git_diff(buf, is_focused)
	local git_icons = lazy_icons.git
	local icons = { removed = git_icons.removed, changed = git_icons.modified, added = git_icons.added }
	local highlight = { removed = "GitSignsDelete", changed = "GitSignsChange", added = "GitSignsAdd" }
	local labels = {}
	local ok, signs = pcall(vim.api.nvim_buf_get_var, buf, "gitsigns_status_dict")
	if ok then
		for name, icon in pairs(icons) do
			local count = tonumber(signs[name]) or 0
			if count > 0 then
				labels[#labels + 1] = {
					icon .. count .. " ",
					group = is_focused and highlight[name] or unfocused,
				}
			end
		end
	end
	return labels
end

-- ToggleTerm 显示 ID
local function get_toggleterm_id(buf, is_focused)
	local id = " " .. vim.fn.bufname(buf):sub(-1) .. " "
	return { { id, group = is_focused and "FloatTitle" or "Title" } }
end

local function is_toggleterm(buf)
	return vim.bo[buf].filetype == "toggleterm"
end

-- Edgy 文件类型
local edgy_filetypes = {
	"neotest-output-panel",
	"neotest-summary",
	"noice",
	"Trouble",
	"OverseerList",
	"Outline",
	"ogpt-popup",
	"ogpt-parameters-window",
	"ogpt-template",
	"ogpt-sessions",
	"ogpt-system-window",
	"ogpt-window",
	"ogpt-selection",
	"ogpt-instruction",
	"ogpt-input",
	"trouble",
	"copilot-chat",
	"codecompanion",
}

local edgy_titles = {
	["neotest-output-panel"] = "neotest",
	["neotest-summary"] = "neotest",
	noice = "noice",
	Trouble = "trouble",
	OverseerList = "overseer",
	Outline = "outline",
	["ogpt-popup"] = "ogpt-popup",
	["ogpt-parameters-window"] = "ogpt-parameters-window",
	["ogpt-template"] = "ogpt-template",
	["ogpt-sessions"] = "ogpt-sessions",
	["ogpt-system-window"] = "ogpt-system-window",
	["ogpt-window"] = "ogpt-window",
	["ogpt-selection"] = "ogpt-selection",
	["ogpt-instruction"] = "ogpt-instruction",
	["ogpt-input"] = "ogpt-input",
}

local function is_edgy(buf)
	return vim.tbl_contains(edgy_filetypes, vim.bo[buf].filetype)
end

local function get_trouble_name(win)
	local win_trouble = vim.w[win].trouble
	return win_trouble and win_trouble.mode or "trouble"
end

-- 获取标题
local function get_title(props)
	local filetype = vim.bo[props.buf].filetype
	local name = edgy_titles[filetype] or filetype
	if filetype == "trouble" then
		name = get_trouble_name(props.win)
	end
	return { { " " .. name .. " ", group = props.focused and "FloatTitle" or "Title" } }
end

return {
	"b0o/incline.nvim",
	event = "VeryLazy",
	opts = {
		debounce_threshold = { rising = 50, falling = 50 },
		window = {
			zindex = 30,
			margin = {
				vertical = { top = vim.o.laststatus == 3 and 0 or 1, bottom = 0 },
				horizontal = { left = 0, right = 2 },
			},
			overlap = { borders = true, statusline = true, tabline = false, winbar = true },
		},
		hide = { cursorline = false },
		ignore = { buftypes = {}, filetypes = { "neo-tree", "dashboard" }, unlisted_buffers = false },
		render = function(props)
			if vim.api.nvim_win_get_config(0).relative ~= "" then
				return nil
			end

			local buf = props.buf
			local filename = vim.fn.fnamemodify(vim.fn.bufname(buf), ":t")
			if filename == "" then
				return nil
			end

			if is_toggleterm(buf) then
				return get_toggleterm_id(buf, props.focused)
			end
			if is_edgy(buf) then
				return get_title(props)
			end

			local filetype_icon, filetype_color = require("nvim-web-devicons").get_icon_color(filename)
			local diagnostics = get_diagnostic_label(buf, props.focused)
			local diffs = get_git_diff(buf, props.focused)

			local color_group = props.focused and focused or unfocused
			local icon = { filetype_icon, group = props.focused and nil or unfocused }
			local separator = (#diagnostics > 0 and #diffs > 0) and { separator_char .. " ", group = color_group } or ""
			local filename_separator = (#diagnostics > 0 or #diffs > 0)
					and { " " .. separator_char .. " ", group = color_group }
				or ""

			local filename_component =
				{ icon, { filetype_icon and " " or "" }, { filename, group = color }, filename_separator }

			if vim.bo[props.buf].buflisted then
				filename_component = {}
			end

			return { {}, { diagnostics }, {}, { diffs } }
			-- return { {}, { diagnostics }, { separator }, { diffs } }
		end,
	},
}
