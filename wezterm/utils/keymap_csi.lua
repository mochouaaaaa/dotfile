local M = {}

-- 映射修饰键到 CSI 码
local mod_map = {
	SHIFT = 1,
	ALT = 2,
	CTRL = 4,
	CMD = 8,
}

-- Function: Generate CSI Sequence
function M.get_csi_sequence(key, mods)
	local mod_code = 0 -- default is 0

	for mod in string.gmatch(mods, "([^|]+)") do
		if mod_map[mod] then
			mod_code = mod_code + mod_map[mod]
		end
	end

	local csi_sequence = string.format("\x1b[%d;%du", string.byte(key), mod_code + 1)
	print(mods, key)
	print(string.format("Generated CSI sequence: \\x1b[%d;%du", string.byte(key), mod_code + 1))
	return csi_sequence
end

return M
