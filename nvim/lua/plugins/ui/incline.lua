local separator_char = "-"
local unfocused = "NonText"
local focused = "Identifier"

local lazy_icons = require("lazyvim.config").icons

local diag_order = { "Error", "Warn", "Info", "Hint" }
local git_order = {
	{ key = "added", icon = lazy_icons.git.added, hl = "GitSignsAdd" },
	{ key = "changed", icon = lazy_icons.git.modified, hl = "GitSignsChange" },
	{ key = "removed", icon = lazy_icons.git.removed, hl = "GitSignsDelete" },
}

local edgy_titles = {
	["neotest-output-panel"] = "neotest",
	["neotest-summary"] = "neotest",
	noice = "noice",
	Trouble = "trouble",
	trouble = "trouble",
	OverseerList = "overseer",
	Outline = "outline",
	["copilot-chat"] = "copilot-chat",
	codecompanion = "codecompanion",
}

local function get_diagnostic_label(buf, is_focused)
	local labels = {}
	for _, severity in ipairs(diag_order) do
		local icon = lazy_icons.diagnostics[severity]
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

local function get_git_diff(buf, is_focused)
	local labels = {}
	local ok, signs = pcall(vim.api.nvim_buf_get_var, buf, "gitsigns_status_dict")
	if ok and signs then
		for _, item in ipairs(git_order) do
			local count = tonumber(signs[item.key]) or 0
			if count > 0 then
				labels[#labels + 1] = {
					item.icon .. count .. " ",
					group = is_focused and item.hl or unfocused,
				}
			end
		end
	end
	return labels
end

local function get_special_title(props)
	local buf = props.buf
	local ft = vim.bo[buf].filetype
	local group = props.focused and "FloatTitle" or "Title"

	if ft == "toggleterm" then
		local id = vim.b[buf].toggle_number or vim.fn.bufname(buf):match("#(%d+)$") or ""
		return { { "  " .. id .. " ", group = group } }
	end

	local name = edgy_titles[ft] or (ft:match("^ogpt%-") and ft)
	if name then
		if ft == "trouble" then
			local win_trouble = vim.w[props.win].trouble
			name = win_trouble and win_trouble.mode or "trouble"
		end
		return { { " " .. name .. " ", group = group } }
	end

	return nil
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
		hide = { cursorline = true },
		ignore = {
			buftypes = {},
			filetypes = { "neo-tree", "dashboard", "snacks_dashboard" },
			unlisted_buffers = false,
		},
		render = function(props)
			local devicons = require("nvim-web-devicons")

			if vim.api.nvim_win_get_config(0).relative ~= "" then
				return nil
			end

			local special = get_special_title(props)
			if special then
				return special
			end

			local buf = props.buf
			local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
			if filename == "" then
				return nil
			end

			local diagnostics = get_diagnostic_label(buf, props.focused)
			local diffs = get_git_diff(buf, props.focused)
			local modified = vim.bo[buf].modified

			local color_group = props.focused and focused or unfocused
			local has_extra = (#diagnostics > 0 or #diffs > 0)

			local ft_icon, ft_color = devicons.get_icon_color(filename)
			return {
				{ (ft_icon or "") .. " ", guifg = ft_color, guibg = "none" },
				{
					filename .. (modified and " ●" or ""),
					gui = modified and "bold,italic" or "bold",
					group = color_group,
				},
				has_extra and { " " .. separator_char .. " ", group = color_group } or "",
				diagnostics,
				diffs,
			}
		end,
	},
}
