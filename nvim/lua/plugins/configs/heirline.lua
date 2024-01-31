local M = {}

local memory = function()
	local use = (1 - (vim.uv.get_free_memory() / vim.uv.get_total_memory())) * 100
	return (" Memory: %.2f"):format(use) .. "%%"
end

function M.setup()
	utils = require("heirline.utils")
	conditions = require("heirline.conditions")

	local function get_hl(hlgroup)
		local hl = utils.get_highlight(hlgroup)
		return setmetatable(hl, { __index = function() return "none" end })
	end

	local function setup_colors()
		return {
			bright_bg = get_hl("Folded").bg,
			bright_fg = get_hl("Folded").fg,
			red = get_hl("DiagnosticError").fg,
			dark_red = get_hl("DiffDelete").bg,
			green = get_hl("String").fg,
			blue = get_hl("Function").fg,
			gray = get_hl("NonText").fg,
			orange = get_hl("Constant").fg,
			purple = get_hl("Statement").fg,
			cyan = get_hl("Special").fg,
			diag_warn = get_hl("DiagnosticWarn").fg,
			diag_error = get_hl("DiagnosticError").fg,
			diag_hint = get_hl("DiagnosticHint").fg,
			diag_info = get_hl("DiagnosticInfo").fg,
			git_del = get_hl("diffDeleted").fg,
			git_add = get_hl("diffAdded").fg,
			git_change = get_hl("diffChanged").fg,
		}
	end

	require("heirline").load_colors(setup_colors)

	return {
		Align = { provider = "%=" },
		Space = { provider = " " },
		ViMode = {
			-- get vim current mode, this information will be required by the provider
			-- and the highlight functions, so we compute it only once per component
			-- evaluation and store it as a component attribute
			init = function(self)
				self.mode = vim.fn.mode(1) -- :h mode()
			end,
			-- Now we define some dictionaries to map the output of mode() to the
			-- corresponding string and color. We can put these into `static` to compute
			-- them at initialisation time.
			static = {
				mode_names = { -- change the strings if you like it vvvvverbose!
					n = "N",
					no = "N?",
					nov = "N?",
					noV = "N?",
					["no\22"] = "N?",
					niI = "Ni",
					niR = "Nr",
					niV = "Nv",
					nt = "Nt",
					v = "V",
					vs = "Vs",
					V = "V_",
					Vs = "Vs",
					["\22"] = "^V",
					["\22s"] = "^V",
					s = "S",
					S = "S_",
					["\19"] = "^S",
					i = "I",
					ic = "Ic",
					ix = "Ix",
					R = "R",
					Rc = "Rc",
					Rx = "Rx",
					Rv = "Rv",
					Rvc = "Rv",
					Rvx = "Rv",
					c = "C",
					cv = "Ex",
					r = "...",
					rm = "M",
					["r?"] = "?",
					["!"] = "!",
					t = "T",
				},
				mode_colors = {
					n = "red",
					i = "green",
					v = "cyan",
					V = "cyan",
					["\22"] = "cyan",
					c = "orange",
					s = "purple",
					S = "purple",
					["\19"] = "purple",
					R = "orange",
					r = "orange",
					["!"] = "red",
					t = "red",
				},
			},
			-- We can now access the value of mode() that, by now, would have been
			-- computed by `init()` and use it to index our strings dictionary.
			-- note how `static` fields become just regular attributes once the
			-- component is instantiated.
			-- To be extra meticulous, we can also add some vim statusline syntax to
			-- control the padding and make sure our string is always at least 2
			-- characters long. Plus a nice Icon.
			provider = function(self) return " %2(" .. self.mode_names[self.mode] .. "%)" end,
			-- Same goes for the highlight. Now the foreground will change according to the current mode.
			hl = function(self)
				local mode = self.mode:sub(1, 1) -- get only the first mode character
				return { fg = self.mode_colors[mode], bold = true }
			end,
			-- Re-evaluate the component only on ModeChanged event!
			-- Also allows the statusline to be re-evaluated when entering operator-pending mode
			update = {
				"ModeChanged",
				pattern = "*:*",
				callback = vim.schedule_wrap(function() vim.cmd("redrawstatus") end),
			},
		},
		GitManager = {
			Branch = {
				condition = conditions.is_git_repo,
				-- provider = function(self) return " " .. vim.b.gitsigns_status_dict.head end,
				provider = function(self) return " " .. vim.b.gitsigns_status_dict.head end,
				hl = { fg = "#fc5603", bold = true },
			},
		},
		LSPManager = {
			Navic = {
				condition = function() return require("nvim-navic").is_available() end,
				static = {
					-- create a type highlight map
					type_hl = {
						File = "Directory",
						Module = "@include",
						Namespace = "@namespace",
						Package = "@include",
						Class = "@structure",
						Method = "@method",
						Property = "@property",
						Field = "@field",
						Constructor = "@constructor",
						Enum = "@field",
						Interface = "@type",
						Function = "@function",
						Variable = "@variable",
						Constant = "@constant",
						String = "@string",
						Number = "@number",
						Boolean = "@boolean",
						Array = "@field",
						Object = "@type",
						Key = "@keyword",
						Null = "@comment",
						EnumMember = "@field",
						Struct = "@structure",
						Event = "@keyword",
						Operator = "@operator",
						TypeParameter = "@type",
					},
					-- bit operation dark magic, see below...
					enc = function(line, col, winnr) return bit.bor(bit.lshift(line, 16), bit.lshift(col, 6), winnr) end,
					-- line: 16 bit (65535); col: 10 bit (1023); winnr: 6 bit (63)
					dec = function(c)
						local line = bit.rshift(c, 16)
						local col = bit.band(bit.rshift(c, 6), 1023)
						local winnr = bit.band(c, 63)
						return line, col, winnr
					end,
				},
				init = function(self)
					local data = require("nvim-navic").get_data() or {}
					local children = {}
					-- create a child for each level
					for i, d in ipairs(data) do
						-- encode line and column numbers into a single integer
						local pos = self.enc(d.scope.start.line, d.scope.start.character, self.winnr)
						local child = {
							{
								provider = d.icon,
								hl = self.type_hl[d.type],
							},
							{
								-- escape `%`s (elixir) and buggy default separators
								provider = d.name:gsub("%%", "%%%%"):gsub("%s*->%s*", ""),
								-- highlight icon only or location name as well
								-- hl = self.type_hl[d.type],

								on_click = {
									-- pass the encoded position through minwid
									minwid = pos,
									callback = function(_, minwid)
										-- decode
										local line, col, winnr = self.dec(minwid)
										vim.api.nvim_win_set_cursor(vim.fn.win_getid(winnr), { line, col })
									end,
									name = "heirline_navic",
								},
							},
						}
						-- add a separator only if needed
						if #data > 1 and i < #data then
							table.insert(child, {
								provider = " > ",
								hl = { fg = "bright_fg" },
							})
						end
						table.insert(children, child)
					end
					-- instantiate the new child, overwriting the previous one
					self.child = self:new(children, 1)
				end,
				-- evaluate the children containing navic components
				provider = function(self) return self.child:eval() end,
				hl = { fg = "gray" },
				update = "CursorMoved",
			},
			Active = {
				condition = conditions.lsp_attached,
				update = { "LspAttach", "LspDetach" },

				-- You can keep it simple,
				-- provider = " [LSP]",

				-- Or complicate things a bit and get the servers names
				provider = function()
					local names = {}
					for i, server in pairs(vim.lsp.get_active_clients { bufnr = 0 }) do
						table.insert(names, server.name)
					end
					return "" .. table.concat(names, " ") .. ""
				end,
				hl = { fg = "green", bold = true },
			},
			DAPMessages = {
				condition = function()
					local session = require("dap").session()
					return session ~= nil
				end,
				provider = function() return " " .. require("dap").status() end,
				hl = "Debug",
				-- see Click-it! section for clickable actions
			},
			Diagnostics = {

				condition = conditions.has_diagnostics,

				static = {
					error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
					warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
					info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
					hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
				},

				init = function(self)
					self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
					self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
					self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
					self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
				end,

				update = { "DiagnosticChanged", "BufEnter" },

				{
					provider = "![",
				},
				{
					provider = function(self)
						-- 0 is just another output, we can decide to print it or not!
						return self.errors > 0 and (self.error_icon .. self.errors .. " ")
					end,
					hl = { fg = "diag_error" },
				},
				{
					provider = function(self) return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ") end,
					hl = { fg = "diag_warn" },
				},
				{
					provider = function(self) return self.info > 0 and (self.info_icon .. self.info .. " ") end,
					hl = { fg = "diag_info" },
				},
				{
					provider = function(self) return self.hints > 0 and (self.hint_icon .. self.hints) end,
					hl = { fg = "diag_hint" },
				},
				{
					provider = "]",
				},
			},
		},

		BarManager = {
			-- We're getting minimalists here!
			Ruler = {
				-- %l = current line number
				-- %L = number of lines in the buffer
				-- %c = column number
				-- %P = percentage through file of displayed window
				-- provider = "%7(%l/%3L%):%2c %P",
				provider = "%7(%l:%2c%) %P",
			},
			Scroll = {
				static = {
					sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" },
					-- Another variant, because the more choice the better.
					-- sbar = { "🭶", "🭷", "🭸", "🭹", "🭺", "🭻" },
				},
				provider = function(self)
					local curr_line = vim.api.nvim_win_get_cursor(0)[1]
					local lines = vim.api.nvim_buf_line_count(0)
					local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
					return string.rep(self.sbar[i], 2)
				end, -- hl = { fg = "blue" },
				hl = { fg = "bright_fg", bg = "bright_bg" },
			},
		},
		-- I take no credits for this! :lion:
		TabManager = {
			Picker = {
				condition = function(self) return self._show_picker end,
				init = function(self)
					local bufname = vim.api.nvim_buf_get_name(self.bufnr)
					bufname = vim.fn.fnamemodify(bufname, ":t")
					local label = bufname:sub(1, 1)
					local i = 2
					while self._picker_labels[label] do
						if i > #bufname then
							break
						end
						label = bufname:sub(i, i)
						i = i + 1
					end
					self._picker_labels[label] = self.bufnr
					self.label = label
				end,
				provider = function(self) return self.label end,
				hl = { fg = "red", bold = true },
			},
			List = function()
				local Tabpage = {
					provider = function(self) return "%" .. self.tabnr .. "T " .. self.tabpage .. " %T" end,
					hl = function(self)
						if not self.is_active then
							return "TabLine"
						else
							return "TabLineSel"
						end
					end,
				}

				local TabpageClose = {
					provider = "%999X  %X",
					hl = "TabLine",
				}
				return {
					-- only show this component if there's 2 or more tabpages
					condition = function() return #vim.api.nvim_list_tabpages() >= 2 end,
					{ provider = "%=" },
					utils.make_tablist(Tabpage),
					TabpageClose,
				}
			end,
			Offset = {
				condition = function(self)
					local win = vim.api.nvim_tabpage_list_wins(0)[1]
					local bufnr = vim.api.nvim_win_get_buf(win)
					self.winid = win

					if vim.bo[bufnr].filetype == "NvimTree" then
						self.title = "NvimTree"
						return true
						-- elseif vim.bo[bufnr].filetype == "TagBar" then
						--     ...
					end
				end,

				provider = function(self)
					local title = self.title
					local width = vim.api.nvim_win_get_width(self.winid)
					local pad = math.ceil((width - #title) / 2)
					return string.rep(" ", pad) .. title .. string.rep(" ", pad)
				end,

				hl = function(self)
					if vim.api.nvim_get_current_win() == self.winid then
						return "TablineSel"
					else
						return "Tabline"
					end
				end,
			},
		},
		TerminalManager = {
			TerminalName = {
				-- we could add a condition to check that buftype == 'terminal'
				-- or we could do that later (see #conditional-statuslines below)
				provider = function()
					local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
					return " " .. tname
				end,
				hl = { fg = "blue", bold = true },
			},
			Memory = {
				-- condition = false,
				provider = memory,
				hl = {
					fg = "#69bbae",
					-- bg = "#304263",
				},
			},
		},
		UtilManager = {
			Spell = {
				condition = function() return vim.wo.spell end,
				provider = "SPELL ",
				hl = { bold = true, fg = "orange" },
			},
			SearchCount = {
				condition = function() return vim.v.hlsearch ~= 0 and vim.o.cmdheight == 0 end,
				init = function(self)
					local ok, search = pcall(vim.fn.searchcount)
					if ok and search.total then
						self.search = search
					end
				end,
				provider = function(self)
					local search = self.search
					return string.format("󰱽 [%d/%d]", search.current, math.min(search.total, search.maxcount))
				end,
			},
			MacroRec = {
				condition = function() return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0 end,
				-- provider = " ",
				provider = "󰑋 ",
				hl = { fg = "orange", bold = true },
				utils.surround({ "[", "]" }, nil, {
					provider = function() return vim.fn.reg_recording() end,
					hl = { fg = "green", bold = true },
				}),
				update = {
					"RecordingEnter",
					"RecordingLeave",
				},
			},
			ShowCmd = function()
				vim.opt.showcmdloc = "statusline"
				return {
					condition = function() return vim.o.cmdheight == 0 end,
					provider = ":%3.5(%S%)",
				}
			end,
		},
		FileManager = {
			NameBlock = {
				-- let's first set up some attributes needed by this component and it's children
				init = function(self) self.filename = vim.api.nvim_buf_get_name(0) end,
			},
			Icon = {
				init = function(self)
					local filename = self.filename
					local extension = vim.fn.fnamemodify(filename, ":e")
					self.icon, self.icon_color =
						require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
				end,
				provider = function(self) return self.icon and (self.icon .. " ") end,
				hl = function(self) return { fg = self.icon_color } end,
			},
			Name = {
				provider = function(self)
					-- first, trim the pattern relative to the current directory. For other
					-- options, see :h filename-modifers
					local filename = vim.fn.fnamemodify(self.filename, ":.")
					if filename == "" then
						return "[No Name]"
					end
					-- now, if the filename would occupy more than 1/4th of the available
					-- space, we trim the file path to its initials
					-- See Flexible Components section below for dynamic truncation
					if not conditions.width_percent_below(#filename, 0.25) then
						filename = vim.fn.pathshorten(filename)
					end
					return filename
				end,
				hl = { fg = utils.get_highlight("Directory").fg },
			},
			Flags = {
				{
					condition = function() return vim.bo.modified end,
					provider = "[+]",
					hl = { fg = "green" },
				},
				{
					condition = function() return not vim.bo.modifiable or vim.bo.readonly end,
					provider = "",
					hl = { fg = "orange" },
				},
			},
			Modifer = {
				hl = function()
					if vim.bo.modified then
						-- use `force` because we need to override the child's hl foreground
						return { fg = "cyan", bold = true, force = true }
					end
				end,
			},
			Size = {
				provider = function()
					-- stackoverflow, compute human readable file size
					local suffix = { "b", "k", "M", "G", "T", "P", "E" }
					local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
					fsize = (fsize < 0 and 0) or fsize
					if fsize < 1024 then
						return fsize .. suffix[1]
					end
					local i = math.floor((math.log(fsize) / math.log(1024)))
					return string.format("%.2g%s", fsize / math.pow(1024, i), suffix[i + 1])
				end,
			},
			Type = {
				provider = function() return vim.bo.filetype end,
				hl = { fg = utils.get_highlight("Type").fg, bold = true },
			},
			Encoding = {
				provider = function()
					local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc -- :h 'enc'
					-- return enc ~= "utf-8" and enc:upper()
					return enc
				end,
			},
			Format = {
				provider = function()
					local fmt = vim.bo.fileformat
					-- return fmt ~= "unix" and fmt:upper()
					return fmt
				end,
			},
			LastModified = {
				-- did you know? Vim is full of functions!
				provider = function()
					local ftime = vim.fn.getftime(vim.api.nvim_buf_get_name(0))
					return (ftime > 0) and os.date("%c", ftime)
				end,
			},
			Help = {
				condition = function() return vim.bo.filetype == "help" end,
				provider = function()
					local filename = vim.api.nvim_buf_get_name(0)
					return vim.fn.fnamemodify(filename, ":t")
				end,
				hl = { fg = "blue" },
			},
		},
	}
end

return M
