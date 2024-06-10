local M = {}

function M.Split(str, delimiter)
	local result = {}
	local pattern = "(.-)" .. delimiter
	local last_end = 1
	local start_pos, end_pos, capture = str:find(pattern, 1)

	while start_pos do
		if start_pos ~= 1 or capture ~= "" then
			table.insert(result, capture)
		end
		last_end = end_pos + 1
		start_pos, end_pos, capture = str:find(pattern, last_end)
	end

	if last_end <= #str then
		capture = str:sub(last_end)
		table.insert(result, capture)
	end

	return result
end

return M
