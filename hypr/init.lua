-- Display and session environment must be ready before applications are launched.
require("modules.monitors")
require("modules.envs")
require("modules.input")
require("modules.hyprcapture")

-- Core compositor behavior and visual configuration.
require("modules.misc")
require("modules.general")
require("modules.animations")
require("modules.group")

-- Workspaces are initialized before bindings that operate on them.
require("modules.workspace")
require("modules.keymap")

-- Register window and layer rules after the base compositor configuration.
require("modules.window-rule")
require("modules.shell")

-- Load Noctalia last: it intentionally overrides selected Hyprland bindings.
require("shell.noctalia")
