local M = {}

M.extr_args = {
	"--hidden", -- Search hidden files that are prefixed with `.`
	"--no-ignore", -- Don’t respect .gitignore
	"-g",
	"!.git/",
	"-g",
	"!node_modules/",
	"-g",
	"!.idea/",
	"-g",
	"!pnpm-lock.yaml",
	"-g",
	"!package-lock.json",
	"-g",
	"!go.sum",
	"-g",
	"!lazy-lock.json",
	"-g",
	"!.zsh_history",
	"-g",
	"!__pycache__",
	"-g",
	"!.mypy_cache",
	"-g",
    "!.*", -- Include files and directories starting with a dot
	"-g",
    "!.DS_Store", -- Ignore MacOS .DS_Store files
    "-g",
    "!__MACOSX", -- Ignore MacOS __MACOSX directory
}

return M