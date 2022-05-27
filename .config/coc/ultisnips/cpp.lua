

return {
  s("ternary", {
    t("("), i(1, "cond"), t(" ? "), i(2, "then"), t(" : "), i(3, "else"), t(")")
  }),
  s("tpl", fmt(
    [[
/* {} */
#include<bits/stdc++.h>
using namespace std;
typedef long long ll;
typedef pair<int, int> pii;
#define mp make_pair
#define fst first
#define snd second
#define fr(i, a, b) for(int i=a; i<b; i++)
#define rep(i, begin, end) for (__typeof(end) i = (begin) - ((begin) > (end)); i != (end) - ((begin) > (end)); i += 1 - 2 * ((begin) > (end)))
template<class T = int> using V = vector<T>;
template<class T = int> using VV = V< V<T> >;

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
