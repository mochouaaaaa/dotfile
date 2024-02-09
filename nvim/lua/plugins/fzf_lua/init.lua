local fzf_lua_config = {
	"ibhagwan/fzf-lua",
	dependencies = {
		"kyazdani42/nvim-web-devicons",
	},
	enabled = vim.g.switch_fzf_lua,
}

function fzf_lua_config.config()
	local fzf_lua = require("fzf-lua")
	fzf_lua.setup {
		"telescope",
		winopts = { preview = { default = "bat" } },
		file_icon_padding = " ",
		fzf_opts = { ["--layout"] = "reverse-list" },
	}

	vim.api.nvim_create_autocmd("VimResized", {
		pattern = "*",
		command = 'lua require("fzf-lua").redraw()',
	})

	fzf_lua.register_ui_select(function(_, items)
		-- Auto-height
		local min_h, max_h = 0.15, 0.70
		local h = (#items + 2) / vim.o.lines
		if h < min_h then
			h = min_h
		elseif h > max_h then
			h = max_h
		end

		-- Auto-width
		-- if (#items < 10000) then	-- Maybe disable auto-width on large results?
		local min_w, max_w = 0.05, 0.70
		local longest = 0
		for i, v in ipairs(items) do
			local length = #v
			if length > longest then
				longest = length
			end
		end
		-- needs minimum 7 in my case due to the extra stuff fzf adds on the left side (markers, numbers, extra padding, etc).
		local w = (longest + 9) / vim.o.columns
		if w < min_w then
			w = min_w
		elseif w > max_w then
			w = max_w
		end
		-- end

		return {
			winopts = {
				height = h,
				width = w,
				row = 0.5,
				col = 0.5,
			},
			fzf_opts = {
				["--layout"] = "reverse-list",
				["--info"] = "hidden",
			},
		}
	end)
end

fzf_lua_config.keys = require("plugins.fzf_lua.keys").keys

return {
	fzf_lua_config,
}
