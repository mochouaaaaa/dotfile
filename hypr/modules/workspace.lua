local mainMod = "SUPER"

-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 6 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus { workspace = i })
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move { workspace = i })
end
hl.bind(mainMod .. "+SHIFT+U", hl.dsp.window.move { workspace = "special" })
hl.bind(mainMod .. "+U", hl.dsp.workspace.toggle_special())

hl.bind(mainMod .. "+CTRL+2", hl.dsp.workspace.toggle_special("tg"))

hl.workspace_rule { workspace = "w[tv1]s[false]", gaps_out = 4 }
hl.workspace_rule { workspace = "f[1]s[false]", gaps_out = 4 }
