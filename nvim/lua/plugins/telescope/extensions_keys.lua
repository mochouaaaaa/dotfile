return {
	{ ":", "<cmd>Telescope cmdline<cr>", desc = "Cmdline" },
	-- git
	{
		"<leader>gc",
		"<cmd>lua require('telescope').extensions.conventional_commits.conventional_commits()<cr>",
		desc = "commits",
	},
	-- docker
	{
		"<leader>dm",
		"<Cmd>Telescope docker docker<CR>",
		desc = "manager",
	},
	{
		"<leader>di",
		"<Cmd>Telescope docker images<CR>",
		desc = "images",
	},
	{
		"<leader>dc",
		"<Cmd>Telescope docker containers<CR>",
		desc = "containers",
	},
	{
		"<leader>dn",
		"<Cmd>Telescope docker networks<CR>",
		desc = "networks",
	},
}
