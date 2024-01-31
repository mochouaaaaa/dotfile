python_path = function()
	local cwd = vim.fn.getcwd()
	if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
		return cwd .. "/venv/bin/python"
	elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
		return cwd .. "/.venv/bin/python"
	else
		return os.getenv("VIRTUAL_ENV") .. "/bin/python"
	end
end

return {
	settings = {
		interpreter = { python_path() },

		arg = {
			filetypes = { "python" },
		},
	},
}
