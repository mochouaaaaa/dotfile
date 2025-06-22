local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local d = ls.dynamic_node
local c = ls.choice_node
local r = ls.restore_node
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local fmt = require("luasnip.extras.fmt").fmt
local types = require("luasnip.util.types")

local function node_with_virtual_text(pos, node, text)
	local nodes
	if node.type == types.textNode then
		node.pos = 2
		nodes = { i(1), node }
	else
		node.pos = 1
		nodes = { node }
	end
	return sn(pos, nodes, {
		node_ext_opts = {
			active = {
				-- override highlight here ("GruvboxOrange").
				virt_text = { { text, "GruvboxOrange" } },
			},
		},
	})
end

local function nodes_with_virtual_text(nodes, opts)
	if opts == nil then
		opts = {}
	end
	local new_nodes = {}
	for pos, node in ipairs(nodes) do
		if opts.texts[pos] ~= nil then
			node = node_with_virtual_text(pos, node, opts.texts[pos])
		end
		table.insert(new_nodes, node)
	end
	return new_nodes
end

local function choice_text_node(pos, choices, opts)
	choices = nodes_with_virtual_text(choices, opts)
	return c(pos, choices, opts)
end

-- see latex infinite list for the idea. Allows to keep adding arguments via choice nodes.
local function py_init()
	return sn(
		nil,
		c(1, {
			t(""),
			sn(1, {
				t(", "),
				i(1),
				d(2, py_init),
			}),
		})
	)
end

-- splits the string of the comma separated argument list into the arguments
-- and returns the text-/insert- or restore-nodes
local function to_init_assign(args)
	local tab = {}
	local a = args[1][1]
	if #a == 0 then
		table.insert(tab, t({ "", "\tpass" }))
	else
		local cnt = 1
		for e in string.gmatch(a, " ?([^,]*) ?") do
			if #e > 0 then
				table.insert(tab, t({ "", "\tself." }))
				-- use a restore-node to be able to keep the possibly changed attribute name
				-- (otherwise this function would always restore the default, even if the user
				-- changed the name)
				table.insert(tab, r(cnt, tostring(cnt), i(nil, e)))
				table.insert(tab, t(" = "))
				table.insert(tab, t(e))
				cnt = cnt + 1
			end
		end
	end
	return sn(nil, tab)
end

local ct = choice_text_node

ls.add_snippets("python", {
	-- create the actual snippet
	s(
		"definit",
		fmt([[def __init__(self{}):{}]], {
			d(1, py_init),
			d(2, to_init_assign, { 1 }),
		})
	),
	s(
		"ryaml",
		fmt(
			[[
with open({}, "r") as f:
  {} = yaml.safe_load(f)
      ]],
			{ i(1, "yamlfile"), i(2, "content") }
		)
	),
	s(
		"ifmain",
		fmt(
			[[
def main():
    {}


if __name__ == "__main__":
    main()
  ]],
			{ i(1, "pass") }
		)
	),
	s(
		"year",
		t({
			'ps.add_argument("--year", choices=["16", "17", "18"])',
			'ps.add_argument("--pol", choices=["Down", "Up"])',
			"year = args.year",
			"pol = args.pol",
		})
	),
	s("cwd", t({ "cwd = get_cwd(__file__)" })),
	s(
		"rootdf",
		c(1, {
			fmt('df = ROOT.RDataFrame("{}", {})', { i(1, "DecayTree"), i(2, "file_list") }),
			fmt(
				[[
file_list = ["{}"]
df = ROOT.RDataFrame("{}", file_list)
    ]],
				{ i(1), i(2, "DecayTree") }
			),
		})
	),
	s(
		"mt",
		c(1, {
			t({
				'ps.add_argument("--ncpu", type=int, default=0)',
				"ROOT.EnableImplicitMT(args.ncpu)",
				'print(f"Enabled multithreading with {args.ncpu} CPUs...")',
			}),
			t({
				"ROOT.EnableImplicitMT()",
			}),
		})
	),
	s("TLegend", t({ "lg = ROOT.TLegend(0.7,0.7,0.9,0.9)", "lg.SetFillStyle(4000)", "lg.SetBorderSize(0)" })),
	s(
		"ROOT",
		t({
			"import ROOT",
			"ROOT.gROOT.SetBatch(True)",
		})
	),
	s(
		"cwd",
		t({
			"import os",
			"cwd = os.path.dirname(os.path.abspath(__file__))",
		})
	),
	s(
		"syspath",
		fmt(
			[[
      import sys
      sys.path.append("{}")
      ]],
			{ i(1, "..") }
		)
	),
	s(
		"osexists",
		fmt("os.path.exists({file})", {
			file = i(1),
		})
	),
	s(
		"argg",
		fmt(
			[[
      from argparse import ArgumentParser as AP
      from argparse import ArgumentDefaultsHelpFormatter as ADHF
      ps = AP(formatter_class=ADHF)
      ps.add_argument("--test", action="store_true")
      args = ps.parse_args()
      ]],
			{}
		)
	),
	s(
		"argyears",
		t({
			'ps.add_argument("--years",nargs="+",type=str,default=["16", "17", "18"],choices=["16", "17","18"])',
		})
	),
	s(
		"argpols",
		t({
			'ps.add_argument("--pols",nargs="+",type=str,default=["Down", "Up"],choices=["Down", "Up"])',
		})
	),
	s(
		"paras",
		fmt(
			[[
      import os
      import sys
      sys.path.append(os.environ["MAJORANA"])
      from paras import *
      ]],
			{}
		)
	),
})
