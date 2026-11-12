-- Fallback Kitty context notification for ordinary SSH sessions.
-- When the Kitty backend is active (local Kitty or kitten ssh), it owns IS_NVIM.
-- For plain ssh, KITTY_LISTEN_ON is absent, so forward OSC 1337 through the PTY.
local M = {}

local function uses_kitty_backend()
  return vim.env.KITTY_LISTEN_ON ~= nil and vim.env.KITTY_LISTEN_ON ~= ""
end

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
  if uses_kitty_backend() then
    return
  end
  send("\27]1337;SetUserVar=IS_NVIM=MQ==\7")
end

function M.leave()
  if uses_kitty_backend() then
    return
  end
  send("\27]1337;SetUserVar=IS_NVIM\7")
end

return M
