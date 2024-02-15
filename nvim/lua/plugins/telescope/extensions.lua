local actions = require("telescope._extensions.conventional_commits.actions")

return {
	lazy = {},
	helpgrep = {
		ignore_paths = {
			vim.fn.stdpath("state") .. "/lazy/readme",
		},
	},
	project = {
		theme = "catppuccin",
		hidden_files = false,
	},
	-- telescope-undo.nvim
	undo = {
		side_by_side = true,
		layout_strategy = "vertical",
		mappings = {
			i = {
				["<D-y>"] = require("telescope-undo.actions").yank_additions,
				["<cr>"] = require("telescope-undo.actions").restore,
			},
			n = {
				["y"] = require("telescope-undo.actions").yank_additions,
				["<cr>"] = require("telescope-undo.actions").restore,
			},
		},
	},
	-- telescope-media-files.nvim
	media_files = {
		filetypes = { "png", "webp", "jpg", "jpeg" },
		find_cmd = "rg", -- find command (defaults to `fd`)
	},
	-- telescope-cc.nvim
	conventional_commits = {
		action = actions.prompt,
		theme = "dropdown",
		include_body_and_footer = true, -- Add prompts for commit body and footer
	},
	-- telescope-docker.nvim
	docker = {
		theme = "ivy",
		binary = "docker", -- in case you want to use podman or something
		compose_binary = "docker compose",
		buildx_binary = "docker buildx",
		machine_binary = "docker-machine",
		log_level = vim.log.levels.INFO,
		init_term = "tabnew", -- "vsplit new", "split new", ...
	},
}
