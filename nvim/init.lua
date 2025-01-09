local sqlite_clib_path = os.getenv("SQLITE_CLIB_PATH")

if sqlite_clib_path then
	vim.g.sqlite_clib_path = sqlite_clib_path
end

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
