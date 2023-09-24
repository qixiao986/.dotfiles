local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key

return {
  s("ternary", {
    t("("), i(1, "cond"), t(" ? "), i(2, "then"), t(" : "), i(3, "else"), t(")")
  }),
  s("tpl", fmt(
    [[
/* {} */
#include<bits/stdc++.h>
#include<iostream>
using namespace std;
typedef long long ll;
typedef pair<int, int> pii;
#define mp make_pair
#define fst first
#define snd second
#define fr(i, a, b) for(int i=a; i<b; i++)
#define rep(i, begin, end) for (__typeof(end) i = (begin) - ((begin) > (end)); i != (end) - ((begin) > (end)); i += 1 - 2 * ((begin) > (end)))

{}
    ]],
    { t(os.date("%Y-%m-%d %X")),
      c(1, {
        sn(nil, fmt([[
int main() {{
	cin.tie(nullptr); ios::sync_with_stdio(false);
  {}
}}
        ]], {i(1)})
        ),
        sn(nil, fmt([[
void main2() {{
  {}
}}

int main() {{
	cin.tie(nullptr); ios::sync_with_stdio(false);
	int T;
	cin>>T;
	for(int i=1; i<=T; i++) {{
		cout<<"Case #"<<i<<": ";
		main2();
	}}

}}
        ]], {i(1)})
        ),
      })
    })
  ),
}, {
	parse("autotrig", "autotriggered, if enabled")
}
