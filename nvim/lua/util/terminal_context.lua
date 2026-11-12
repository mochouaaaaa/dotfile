-- Publish Neovim state through OSC 1337 for Kitty's native var: mappings.
-- This works through ordinary SSH as long as the remote PTY forwards escapes.
-- When inside tmux, wrap the OSC sequence in DCS passthrough.
local M = {}

local function send(sequence)
	if vim.env.TMUX and vim.env.TMUX ~= "" then
		sequence = "\27Ptmux;\27" .. sequence:gsub("\27", "\27\27") .. "\27\\"
	end

	if vim.api.nvim_ui_send then
		vim.api.nvim_ui_send(sequence)
	else
		io.stdout:write(sequence)
		io.stdout:flush()
	end
end

function M.enter()
	-- Base64("1") = MQ==. Kitty matches the variable by presence.
	send("\27]1337;SetUserVar=IS_NVIM=MQ==\7")
end

function M.leave()
	-- Omitting '=' unsets the Kitty user variable.
	send("\27]1337;SetUserVar=IS_NVIM\7")
end

return M
