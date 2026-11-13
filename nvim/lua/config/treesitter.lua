-- Tree-sitter parsers and queries are installed by Nix.
-- The parser may be unavailable for filetypes without a packaged grammar.
local group = vim.api.nvim_create_augroup("nix_treesitter_highlight", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	callback = function(args)
		pcall(vim.treesitter.start, args.buf)
	end,
})
