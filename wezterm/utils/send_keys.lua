local csi = require("utils.keymap_csi")
local utils = require("utils.string")
local wezterm = require("wezterm")

-- Base class for command key maps
BaseCommandKeyMap = {}
BaseCommandKeyMap.__index = BaseCommandKeyMap

-- Define special character map in Lua
BaseCommandKeyMap.SPECIAL_CHAR_MAP = {
	["+"] = "_",
	["-"] = "dash",
	["["] = "left_bracket",
	["]"] = "right_bracket",
	["("] = "left_paren",
	[")"] = "right_paren",
}

function BaseCommandKeyMap:new(mod, key, window, pane)
	local self = setmetatable({}, self)
	self.key = key
	self.mod = mod
	self.window = window
	self.pane = pane

	self.tab_num = 7

	self.reset_keymap = self:create_reset_keymap()
	self:_apply_reset_keymap()

	self:create_tab_keymap()

	-- Convert keymap to valid function name at initialization
	self.function_name = self:_convert_keymap_to_function_name()

	return self
end

function BaseCommandKeyMap:_convert_keymap_to_function_name()
	self.mod = string.gsub(self.mod, "|", "_")
	local key = self.keymap

	-- 替换特殊字符
	for special_char, replacement in pairs(self.SPECIAL_CHAR_MAP) do
		if key:find(special_char) then
			key = key:gsub(special_char, replacement)
		end
	end

	local function_name = string.lower(self.mod .. "_" .. self.key)
	return function_name
end

function BaseCommandKeyMap:_apply_reset_keymap()
	for _, key in ipairs(self.reset_keymap) do
		self[key] = self.default_keymap
	end
end

function BaseCommandKeyMap:get_csi_keymap(key, mod) return csi.get_csi_sequence(key, mod) end

--- @action wezterm.action
function BaseCommandKeyMap:send_keymap(action) self.window:perform_action(action, self.pane) end

function BaseCommandKeyMap:default_keymap()
	self:send_keymap(wezterm.action { SendString = self:get_csi_keymap(self.key, self.mod) })
end

function BaseCommandKeyMap:call_keymap()
	-- 组合出函数名
	local function_name = self:_convert_keymap_to_function_name()

	-- 查找对应的函数
	local call_func = self[function_name]

	if call_func and type(call_func) == "function" then
		print("call function: ", function_name)
		call_func(self) -- 调用找到的函数
	else
		self:default_keymap() -- 如果未找到，则调用 default_keymap
	end
end

-- Abstract methods
function BaseCommandKeyMap:create_tab_keymap()
	-- Abstract method, should be overridden by subclasses
	return {}
end
function BaseCommandKeyMap:create_reset_keymap()
	-- Abstract method, should be overridden by subclasses
	return {}
end

-- ZshCommandKeyMap class
ZshCommandKeyMap = setmetatable({}, { __index = BaseCommandKeyMap })
ZshCommandKeyMap.__index = ZshCommandKeyMap

function ZshCommandKeyMap:new(mod, key, window, pane) return BaseCommandKeyMap.new(self, mod, key, window, pane) end

function ZshCommandKeyMap:create_tab_keymap()
	for index = 1, self.tab_num - 1 do
		self["cmd_" .. index] = function() self:send_keymap(wezterm.action { ActivateTab = index - 1 }) end
	end
end

-- Common command functions
local function create_cmd_function(name, action)
	ZshCommandKeyMap["cmd_" .. name] = function(self) self:send_keymap(action) end
end

-- Directional commands
for _, direction in ipairs { "h", "j", "k", "l" } do
	ZshCommandKeyMap["cmd_" .. direction] = function(self)
		self:send_keymap(wezterm.action { ActivatePaneDirection = direction })
	end
end

-- Resize pane commands
for _, dir in ipairs { "h", "j", "k", "l" } do
	ZshCommandKeyMap["ctrl_shift_" .. dir] = function(self)
		self:send_keymap(wezterm.action { AdjustPaneSize = { dir, 3 } })
	end
end

create_cmd_function("c", wezterm.action.CopyTo("Clipboard"))
create_cmd_function("v", wezterm.action.PasteFrom("Clipboard"))
create_cmd_function("w", wezterm.action { CloseCurrentPane = { confirm = false } })
create_cmd_function("r", wezterm.action { SendString = "yazi\n" })
create_cmd_function("t", wezterm.action.SpawnTab("DefaultDomain"))
create_cmd_function("enter", wezterm.action.TogglePaneZoomState)
create_cmd_function("shift_k", wezterm.action.Search { CaseInSensitiveString = "" })
create_cmd_function(
	"left_bracket",
	wezterm.action { PaneSelect = { mode = "SwapWithActiveKeepFocus", alphabet = "123456789" } }
)
create_cmd_function(
	"right_bracket",
	wezterm.action { PaneSelect = { mode = "SwapWithActiveKeepFocus", alphabet = "123456789" } }
)

function ZshCommandKeyMap:cmd_ctrl_h() self:send_keymap(wezterm.action { SplitPane = { direction = "Left" } }) end
function ZshCommandKeyMap:cmd_ctrl_j() self:send_keymap(wezterm.action { SplitPane = { direction = "Down" } }) end
function ZshCommandKeyMap:cmd_ctrl_k() self:send_keymap(wezterm.action { SplitPane = { direction = "Up" } }) end
function ZshCommandKeyMap:cmd_ctrl_l() self:send_keymap(wezterm.action { SplitPane = { direction = "Right" } }) end
function ZshCommandKeyMap:cmd_shift_k()
	self:send_keymap(wezterm.action.PromptInputLine {
		description = "Enter new name for tab",
		action = wezterm.action_callback(function(window, pane, line)
			-- line will be `nil` if they hit escape without entering anything
			-- An empty string if they just hit enter
			-- Or the actual line of text they wrote
			if line then
				window:active_tab():set_title(line)
			end
		end),
	})
end

-- NvimCommandKeyMap class
NvimCommandKeyMap = setmetatable({}, { __index = ZshCommandKeyMap })
NvimCommandKeyMap.__index = NvimCommandKeyMap

function NvimCommandKeyMap:new(mod, key, window, pane) return ZshCommandKeyMap.new(self, mod, key, window, pane) end

function NvimCommandKeyMap:create_reset_keymap() return { "cmd_f", "cmd_r", "cmd_shift_f", "cmd_s", "cmd_w", "cmd_e" } end

-- TmuxCommandKeyMap class
TmuxCommandKeyMap = setmetatable({}, { __index = BaseCommandKeyMap })
TmuxCommandKeyMap.__index = TmuxCommandKeyMap

function TmuxCommandKeyMap:new(mod, key, window, pane) return BaseCommandKeyMap.new(self, mod, key, window, pane) end

function TmuxCommandKeyMap:create_reset_keymap() return { "cmd_f", "cmd_r", "cmd_shift_f", "cmd_s", "cmd_w", "cmd_e" } end

function TmuxCommandKeyMap:create_tab_keymap()
	for index = 1, self.tab_num - 1 do
		self["cmd_" .. index] = function() self:send_keymap("ctrl+a->" .. index) end
	end
end

-- 定义常用Tmux命令
local function create_tmux_cmd_function(name, keymap)
	TmuxCommandKeyMap["cmd_" .. name] = function(self) self:send_keymap(keymap) end
end

create_tmux_cmd_function("t", "ctrl+a->c") -- 创建新标签页
create_tmux_cmd_function("f", "ctrl+a->q") -- 关闭标签页
create_tmux_cmd_function("enter", "ctrl+a->z") -- 全屏切换
create_tmux_cmd_function("shift_k", "ctrl+a->,") -- 重命名标签页

-- 方向命令
for _, dir in ipairs { "h", "j", "k", "l" } do
	TmuxCommandKeyMap["cmd_ctrl_" .. dir] = function(self) self:send_keymap("ctrl+a->" .. dir) end
end

-- Pane大小调整
for _, dir in ipairs { "h", "j", "k", "l" } do
	TmuxCommandKeyMap["ctrl_shift_" .. dir] = function(self) self:send_keymap(self:get_csi_keymap(dir, "ctrl|shift")) end
end

function TmuxCommandKeyMap:send_keymap(keymap)
	if keymap and type(keymap) == "string" then
		-- 分割键映射
		local result = utils.Split(keymap, "->")

		-- 遍历每个键
		for _, v in ipairs(result) do
			if string.find(v, "+") then
				-- 如果包含 '+'，则拆分 mod 和 key
				local tmp = utils.Split(v, "+")
				if tmp[1] and tmp[2] then
					local csi_keymap = csi.get_csi_sequence(tmp[2], tmp[1])
					-- 发送 CSI 序列
					self.window:perform_action({ SendString = csi_keymap }, self.pane)
				end
			else
				-- 直接发送键
				self.window:perform_action({ SendKey = { key = v } }, self.pane)
			end
		end
	else
		-- 如果没有 keymap，使用基类的发送方式
		BaseCommandKeyMap.send_keymap(self, keymap)
	end
end

-- YaziCommandKeyMap class
YaziCommandKeyMap = setmetatable({}, { __index = ZshCommandKeyMap })
YaziCommandKeyMap.__index = YaziCommandKeyMap

function YaziCommandKeyMap:new(mod, key, window, pane) return ZshCommandKeyMap.new(self, mod, key, window, pane) end

function YaziCommandKeyMap:create_reset_keymap() return { "cmd_shift_f" } end
function YaziCommandKeyMap:cmd_f() BaseCommandKeyMap.default_keymap(self) end

-- handle_result 函数
function handle_result(mod, key, window)
	local pane = window:active_pane()
	local process_name = string.match(pane:get_foreground_process_name(), "[^/]+$")

	local class_map = {
		zsh = ZshCommandKeyMap,
		nvim = NvimCommandKeyMap,
		tmux = TmuxCommandKeyMap,
		yazi = YaziCommandKeyMap,
	}

	print("process_name: " .. process_name)
	local command_class = class_map[process_name]

	if not command_class then
		print("Unsupported command action: ")
		return
	end

	-- 检查 window 和 pane 是否有值
	if not window then
		print("Error: window is nil")
		return
	end

	if not pane then
		print("Error: pane is nil")
		return
	end

	local command_instance = command_class:new(mod, key, window, pane)

	-- 调用对应的快捷键映射函数
	command_instance:call_keymap()
end

-- 动态创建快捷键绑定
function create_key_binding(mods, key)
	return {
		key = key,
		mods = mods,
		action = wezterm.action_callback(
			function(window, pane) wezterm.emit("trigger-action", window, pane, mods, key) end
		),
	}
end

-- 监听 trigger-action 事件
wezterm.on("trigger-action", function(window, pane, mod, key) handle_result(mod, key, window) end)

return {
	create_key_binding = create_key_binding,
}
