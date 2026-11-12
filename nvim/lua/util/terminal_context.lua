-- Publish Neovim's current state to Kitty/WezTerm-compatible terminals.
-- OSC 1337 SetUserVar is forwarded through tmux when allow-passthrough is on.
local M = {}

local function set_nvim(active)
	local sequence
	if active then
		-- Base64("true") = dHJ1ZQ==
		sequence = "\27]1337;SetUserVar=IS_NVIM=dHJ1ZQ==\7"
	else
		-- No '=' means unset the terminal user variable.
		sequence = "\27]1337;SetUserVar=IS_NVIM\7"
	end

	if vim.env.TMUX and vim.env.TMUX ~= "" then
		sequence = "\27Ptmux;\27" .. sequence:gsub("\27", "\27\27") .. "\27\\"
	end

	io.stdout:write(sequence)
	io.stdout:flush()
end

function M.enter()
	set_nvim(true)
end

function M.leave()
	set_nvim(false)
end

return M
