local M = {}

colors = {
	darkblue = "#152538",
	inactive = "#1B2733",
	dark_gray = "#4d5566",
	black = "#0F131A",
	white = "#BFBDB6",
	red = "#F07178",
	purple = "#D2A6FF",
	green = "#AAD94C",
	blue = "#59C2FF",
	orange = "#FFB454",
}

M.primary_mode_colors = {
	n = { fg = colors.blue },
	-- n = { fg = colors.dark_gray },
	i = { fg = colors.green },
	v = { fg = colors.orange },
	V = { fg = colors.orange },
	["\22"] = { fg = colors.orange },
	c = { fg = colors.blue },
	s = { fg = colors.purple },
	S = { fg = colors.purple },
	["\19"] = { fg = colors.purple },
	R = { fg = colors.red },
	r = { fg = colors.red },
	["!"] = { fg = colors.blue },
	t = { fg = colors.purple },
}

M.secondary_mode_colors = {
	-- n = { fg = colors.dark_gray },
	n = { fg = colors.blue },
	i = { fg = colors.green },
	v = { fg = colors.orange },
	V = { fg = colors.orange },
	["\22"] = { fg = colors.orange },
	c = { fg = colors.blue },
	s = { fg = colors.purple },
	S = { fg = colors.purple },
	["\19"] = { fg = colors.purple },
	R = { fg = colors.red },
	r = { fg = colors.red },
	["!"] = { fg = colors.blue },
	t = { fg = colors.purple },
}

function M.get_mode()
	local mode = vim.fn.mode(1) or "n"
	return mode:sub(1, 1)
end

M.primary_highlight = function()
	return M.primary_mode_colors[M.get_mode()]
end

M.secondary_highlight = function()
	return M.secondary_mode_colors[M.get_mode()]
end

M.SearchCount = {
	condition = function()
		return vim.v.hlsearch ~= 0 and vim.o.cmdheight == 0
	end,
	init = function(self)
		local ok, search = pcall(vim.fn.searchcount)
		if ok and search.total then
			self.search = search
		end
	end,
	provider = function(self)
		return self.search
				and string.format("[%d/%d] ", self.search.current, math.min(self.search.total, self.search.maxcount))
			or ""
	end,
	hl = M.secondary_highlight,
}

M.positioning = {
	provider = " %3l:%-3c ",
	hl = M.secondary_highlight,
}

------------------------
M.overseer = function()
	local Spacer = { provider = " " }
	local function rpad(child)
		return {
			condition = child.condition,
			child,
			Spacer,
		}
	end
	local function OverseerTasksForStatus(status)
		return {
			condition = function(self)
				return self.tasks[status]
			end,
			provider = function(self)
				return string.format("%s%d", self.symbols[status], #self.tasks[status])
			end,
			-- hl = function(self)
			--     return {
			--         fg = utils.get_highlight(string.format("Overseer%s", status)).fg,
			--     }
			-- end,
		}
	end
	return {
		condition = function()
			return package.loaded.overseer
		end,
		init = function(self)
			local tasks = require("overseer.task_list").list_tasks({ unique = true })
			local tasks_by_status = require("overseer.util").tbl_group_by(tasks, "status")
			self.tasks = tasks_by_status
		end,
		static = {
			symbols = {
				["CANCELED"] = vim.g.icons.Overseer.Canceled,
				["FAILURE"] = vim.g.icons.Overseer.Failure,
				["SUCCESS"] = vim.g.icons.Overseer.Success,
				["RUNNING"] = vim.g.icons.Overseer.Running,
			},
		},

		rpad(OverseerTasksForStatus("CANCELED")),
		rpad(OverseerTasksForStatus("RUNNING")),
		rpad(OverseerTasksForStatus("SUCCESS")),
		rpad(OverseerTasksForStatus("FAILURE")),
	}
end

M.navic = function()
	return {
		condition = function()
			return require("nvim-navic").is_available()
		end,
		provider = function()
			return require("nvim-navic").get_location({ highlight = true })
		end,
		update = "CursorMoved",
	}
end

M.FileIcon = {
	init = function(self)
		local filename = vim.api.nvim_buf_get_name(0) -- 获取当前缓冲区文件名
		local extension = vim.fn.fnamemodify(filename, ":e") -- 获取文件扩展名
		local devicons = require("nvim-web-devicons") -- 引入 nvim-web-devicons

		-- 获取图标和颜色
		self.icon, self.icon_color = devicons.get_icon_color(filename, extension, { default = true })
	end,
	provider = function(self)
		return self.icon and (self.icon .. " ") or "" -- 返回图标
	end,
	hl = function(self)
		return { fg = self.icon_color } -- 设置图标的前景色
	end,
}

-----------------------

return M
