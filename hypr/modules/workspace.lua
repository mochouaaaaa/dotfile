local mainMod = "SUPER"

-- Keep SUPER+1..6 available to Kitty/WezTerm window switching.
-- Workspace navigation uses SUPER+ALT+1..6 instead.
for i = 1, 6 do
	local key = i % 10
	hl.bind(mainMod .. "+ALT+" .. key, hl.dsp.focus { workspace = i })
	hl.bind(mainMod .. "+ALT+SHIFT+" .. key, hl.dsp.window.move { workspace = i })
end

hl.bind(mainMod .. "+SHIFT+U", hl.dsp.window.move { workspace = "special" })
hl.bind(mainMod .. "+U", hl.dsp.workspace.toggle_special())
hl.bind(mainMod .. "+CTRL+2", hl.dsp.workspace.toggle_special("tg"))

hl.workspace_rule { workspace = "w[tv1]s[false]", gaps_out = 4 }
hl.workspace_rule { workspace = "f[1]s[false]", gaps_out = 4 }
