local M = {}

M.pythonPath = function()
	return os.getenv("VIRTUAL_ENV") .. "/bin/python"
end

return M
