local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

ls.add_snippets("go", {
	s(
		{
			trig = "go",
			name = "Go Routing",
			dscr = "生成标准匿名异步函数",
		},
		fmt(
			[[
go func({}) {{
    {}
}}({})
]],
			{ i(1), i(0), i(2) }
		)
	),
	s(
		{
			trig = "select",
			name = "select chanel",
			dscr = "生成标准队列查询模版",
		},
		fmt(
			[[
select {{
case {} := <-{}:
    {}
case <-time.After({}):
    {}
}}
]],
			{ i(1, "val"), i(2, "ch"), i(3, "break"), i(4, "1 * time.Second"), i(0) }
		)
	),

	-- === 常用工具片段 ===
	-- Append 元素
	s(
		{
			trig = "append",
			name = "append args",
			dscr = "生成标准的Append函数",
		},
		fmt([[{} = append({}, {})]], {
			i(1, "list"), -- 第 1 个节点：变量名，默认值设为 list
			rep(1), -- 重复第 1 个节点的内容
			i(0), -- 最后光标跳转的位置
		})
	),

	-- Check Map Key (ok idiom)
	s(
		{
			trig = "ifok",
			name = "if ok ?",
			dscr = "生成标准的if ok 模版",
		},
		fmt(
			[[
if {}, ok := {}[{}]; ok {{
    {}
}}
]],
			{ i(1, "val"), i(2, "m"), i(3, "key"), i(0) }
		)
	),

	-- Context 带超时 (Context 是 Go 的灵魂)
	s(
		"ctx",
		fmt(
			[[
ctx, cancel := context.WithTimeout(context.Background(), {})
defer cancel()
{}
]],
			{ i(1, "5 * time.Second"), i(0) }
		)
	),

	-- Main 函数模板
	s(
		{
			trig = "main",
			name = "Go Main Function",
			dscr = "生成标准的 Go 语言入口主函数 main()",
		},
		fmt(
			[[
func main() {{
    {}
}}
]],
			{ i(0) }
		)
	),

	-- 1. 基础错误检查
	s(
		"ifre",
		{
			trig = "ifre",
			name = "ifre",
			dscr = "生成基础错误检查",
		},
		fmt(
			[[
if err != nil {{
    return {}
}}
]],
			{ i(1) }
		)
	),

	-- 2. 带有格式化的错误包装
	s(
		{
			trig = "ifree",
			name = "ifree",
			dscr = "生成格式化的错误包装",
		},
		fmt(
			[[
if err != nil {{
    return fmt.Errorf("{}: %w", err)
}}
]],
			{ i(1, "failed to") }
		)
	),

	-- 3. 结构体定义
	s(
		{
			trig = "ty",
			name = "ty",
			dscr = "生成标准的struct模版",
		},
		fmt(
			[[
type {} struct {{
    {}
}}
]],
			{ i(1, "Name"), i(0) }
		)
	),

	s(
		{
			trig = "ti",
			name = "ti",
			dscr = "生成标准的intelface模版",
		},
		fmt(
			[[
type {} interface {{
    {}
}}
            ]],
			{ i(1, "Name"), i(0) }
		)
	),

	-- 4. 标准函数
	s(
		{
			trig = "func",
			name = "func",
			dscr = "生成标准的func函数",
		},
		fmt(
			[[
func {}({}) {} {{
    {}
}}
]],
			{ i(1, "name"), i(2), i(3), i(0) }
		)
	),

	s({
		trig = "fmp",
		name = "fmp",
		dscr = "生成标准的标准输出函数",
	}, fmt([[fmt.Println({})]], { i(1) })),

	s({
		trig = "json",
		name = "json",
		dscr = "生成标准的json tag",
	}, fmt([[ `json:"{}"`]], { i(1) })),
	-- JSON 序列化处理 (常见于 API)
	s(
		"jsonencode",
		fmt(
			[[
if err := json.NewEncoder({}).Encode({}); err != nil {{
    return err
}}
]],
			{ i(1, "w"), i(2, "data") }
		)
	),
})
