-- 判断系统类型
function is_mac() return vim.fn.has("mac") == 1 end

return {
	-- 根据系统类型映射按键
	-- @param key string
	-- cmd: command
	-- option: option
	-- @return string
	platform_key = function(key)
		local _m = {
			cmd = is_mac() and "<D" or "<A",
			option = is_mac() and "<A" or "<M",
		}
		return _m[key]
	end,
}
