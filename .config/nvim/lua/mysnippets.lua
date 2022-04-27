--- snippets
--require'snippets'.use_suggested_mappings()

vim.api.nvim_set_keymap('i', '<C-d>', '<cmd>lua return require\'snippets\'.expand_or_advance(1)<CR>', {noremap=true, silent=true})
--vim.api.nvim_set_keymap('i', '<C-j>', '<cmd>lua return require\'snippets\'.advance_snippet(-1)<CR>', {noremap=true, silent=true})

require'snippets'.snippets = {
  lua = {
    -- Snippets can be used inside of placeholders, but the variables used in
    -- the placeholder *must* be used outside of the placeholder. This could
    -- potentially change in the future if someone convinces me it's a good
    -- idea to support it. (it was a deliberate choice)
    req = [[local ${2:$1} = require '$1']];

    -- A snippet with a placeholder using :... and multiple variables.
    ["for"] = "for ${1:i}, ${2:v} in ipairs(${3:t}) do\n$0\nend";
    -- This is equivalent to above, but looks nicer (to me) using [[]] strings.
    -- Notice $0 to indicate where the cursor should go at the end of expansion.
    ["for"] = [[
for ${1:i}, ${2:v} in ipairs(${3:t}) do
  $0
end]];
  };
  _global = {
	  tpl=[[
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

int main() {
	cin.tie(nullptr); ios::sync_with_stdio(false);
	$0

}
]]
  };
}


