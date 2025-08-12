local common = require("plugins.lsp.global.common")

return {
	{
		"neovim/nvim-lspconfig",
		event = "VeryLazy",
		opts = function(_, opts)
			opts.ruff = {
				init_options = {
					settings = {
						logLevel = "error",
					},
				},
			}
			opts.basedpyright = {
				on_attach = function(client, bufnr)
					common.setup(client, bufnr)
					if client.name == "ruff" then
						client.server_capabilities.hoverProvider = false
					end
				end,
				capabilities = common.make_capabilities(),
				settings = {
					basedpyright = {
						disableLanguageServices = false,
						disableOrganizeImports = false,
						completion = {
							importSupport = true,
						},
						typeCheckingMode = "standard",
						reportAttributeAccessIssue = "none",
					},
					python = {
						analysis = {
							autoSearchPaths = true,
							autoImportCompletions = true,
							diagnosticMode = "workspace",
							strictListInference = true,
							strictDictionaryInference = true,
							strictSetInference = true,
							useLibraryCodeForTypes = true,
							reportAny = "off",
							reportAssignmentType = "none",
							reportMissingTypeStubs = "off",
							reportUnusedCallResult = "off",
							reportUnknownValerType = "off",
							reportImplicitStringConcatenation = "off",
							reportAttributeAccessIssue = "none",
						},
						inlayHints = {
							functionReturnTypes = true,
							variableTypes = true,
						},
					},
				},
			}

			if vim.g.IS_NIX then
				vim.lsp.config("basedpyright", opts.basedpyright)
				vim.lsp.config("ruff", opts.ruff)
				vim.lsp.enable({ "ruff", "basedpyright" })
			end
			return opts
		end,
	},
	{
		"linux-cultist/venv-selector.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
		},
		branch = "regexp", -- This is the regexp branch, use this for the new version
		ft = "python",
		config = function()
			local wk = require("which-key")
			wk.add({
				{ "<leader>v", desc = "virtualvenv" },
			})

			local venv_selector = require("venv-selector")

			local function shorter_name(filename)
				return filename:gsub(os.getenv("HOME"), "~"):gsub("/bin/python", "")
			end

			venv_selector.setup({
				settings = {
					options = {
						debug = true,
						picker = "fzf-lua",
						on_telescope_result_callback = shorter_name,
					},
					search = {
						pyenv = {
							command = "fd python$ "
								.. os.getenv("PYENV_ROOT")
								.. "/versions --max-depth 3 --full-path -a -L",
							on_telescope_result_callback = shorter_name,
						},
					},
				},
			})
		end,
		keys = function()
			return {
				-- Keymap to open VenvSelector to pick a venv.
				{ "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Open VenvSelector" },
			}
		end,
	},
}
