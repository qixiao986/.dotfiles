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
local myfmt = ls.extend_decorator.apply(fmt, { delimiters = "@$" })
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

  s("fenwick", myfmt([[
template <class T> struct fenwick_tree {
public:
  fenwick_tree() : _n(0) {}
  explicit fenwick_tree(int n) : _n(n), data(n) {}

  void add(int p, T x) {
    assert(0 <= p && p < _n);
    p++;
    while (p <= _n) {
      data[p - 1] += T(x);
      p += p & -p;
    }
  }

  T sum(int l, int r) {
    assert(0 <= l && l <= r && r <= _n);
    return sum(r) - sum(l);
  }

private:
  int _n;
  std::vector<T> data;

  T sum(int r) {
    T s = 0;
    while (r > 0) {
      s += data[r - 1];
      r -= r & -r;
    }
    return s;
  }
};
  ]], {})),

  s("Point", myfmt([[
struct Point {
  int x, y;
  void read() {cin >> x >> y;}
  Point operator+(const Point &b) const { return Point{x + b.x, y + b.y}; }
  Point operator-(const Point &b) const { return Point{x - b.x, y - b.y}; }
  ll operator*(const Point &b) const { return (ll)x * b.y - (ll)y * b.x; }
  bool operator<(const Point &b) const { return x == b.x ? y < b.y : x < b.x; }
  void operator+=(const Point &b) {
    x += b.x;
    y += b.y;
  }
  void operator-=(const Point &b) {
    x -= b.x;
    y -= b.y;
  }
  void operator*=(const int k) {
    x *= k;
    y *= k;
  }

  ll cross(const Point &b, const Point &c) const {
    return (b - *this) * (c - *this); // =0 coline  (>0 oc left ob) (<0 oc right ob)
  }
  friend ostream& operator << (ostream& o, Point p){ o << "Point:" << p.x << ", " << p.y; return o;}
};
  ]], {})),

  s("ycomb", myfmt([[
template<class Fun>
class y_combinator_result {
	Fun fun_;
public:
	template<class T>
	explicit y_combinator_result(T &&fun): fun_(std::forward<T>(fun)) {}

	template<class ...Args>
	decltype(auto) operator()(Args &&...args) {
		return fun_(std::ref(*this), std::forward<Args>(args)...);
	}
};

template<class Fun>
decltype(auto) y_combinator(Fun &&fun) {
	return y_combinator_result<std::decay_t<Fun>>(std::forward<Fun>(fun));
}
  ]], {})),

  --s("", myfmt([[]], {})),
  s("dsu", myfmt([[
struct DSU {
  std::vector<int> f, siz;
  int cc, mx;

  DSU() {}
  DSU(int n) { init(n); }

  void init(int n) {
    f.resize(n);
    std::iota(f.begin(), f.end(), 0);
    siz.assign(n, 1);
    cc=n;
    mx=1;
  }

  int find(int x) {
    while (x != f[x]) {
      x = f[x] = f[f[x] ];
    }
    return x;
  }

  bool same(int x, int y) { return find(x) == find(y); }

  bool merge(int x, int y) {
    x = find(x);
    y = find(y);
    if (x == y) {
      return false;
    }
    siz[x] += siz[y];
    f[y] = x;
    cc--;
    mx=max(mx, siz[x]);
    return true;
  }

  int size(int x) { return siz[find(x)]; }
};

  ]], {})),

  s("fastio", myfmt([[
static struct FastInput {
  static constexpr int BUF_SIZE = 1 << 20;
  char buf[BUF_SIZE];
  size_t chars_read = 0;
  size_t buf_pos = 0;
  FILE *in = stdin;
  char cur = 0;

  inline char get_char() {
    if (buf_pos >= chars_read) {
      chars_read = fread(buf, 1, BUF_SIZE, in);
      buf_pos = 0;
      buf[0] = (chars_read == 0 ? -1 : buf[0]);
    }
    return cur = buf[buf_pos++];
  }

  inline void tie(int) {}

  inline explicit operator bool() { return cur != -1; }

  inline static bool is_blank(char c) { return c <= ' '; }

  inline bool skip_blanks() {
    while (is_blank(cur) && cur != -1) {
      get_char();
    }
    return cur != -1;
  }

  inline FastInput &operator>>(char &c) {
    skip_blanks();
    c = cur;
    return *this;
  }

  inline FastInput &operator>>(string &s) {
    if (skip_blanks()) {
      s.clear();
      do {
        s += cur;
      } while (!is_blank(get_char()));
    }
    return *this;
  }

  template <typename T> inline FastInput &read_integer(T &n) {
    // unsafe, doesn't check that characters are actually digits
    n = 0;
    if (skip_blanks()) {
      int sign = +1;
      if (cur == '-') {
        sign = -1;
        get_char();
      }
      do {
        n += n + (n << 3) + cur - '0';
      } while (!is_blank(get_char()));
      n *= sign;
    }
    return *this;
  }

  template <typename T>
  inline typename enable_if<is_integral<T>::value, FastInput &>::type
  operator>>(T &n) {
    return read_integer(n);
  }

#if !defined(_WIN32) || defined(_WIN64)
  inline FastInput &operator>>(__int128 &n) { return read_integer(n); }
#endif

  template <typename T>
  inline typename enable_if<is_floating_point<T>::value, FastInput &>::type
  operator>>(T &n) {
    // not sure if really fast, for compatibility only
    n = 0;
    if (skip_blanks()) {
      string s;
      (*this) >> s;
      sscanf(s.c_str(), "%lf", &n);
    }
    return *this;
  }
} fast_input;
#define cin fast_input

static struct FastOutput {
  static constexpr int BUF_SIZE = 1 << 20;
  char buf[BUF_SIZE];
  size_t buf_pos = 0;
  static constexpr int TMP_SIZE = 1 << 20;
  char tmp[TMP_SIZE];
  FILE *out = stdout;

  inline void put_char(char c) {
    buf[buf_pos++] = c;
    if (buf_pos == BUF_SIZE) {
      fwrite(buf, 1, buf_pos, out);
      buf_pos = 0;
    }
  }

  ~FastOutput() { fwrite(buf, 1, buf_pos, out); }

  inline FastOutput &operator<<(char c) {
    put_char(c);
    return *this;
  }

  inline FastOutput &operator<<(const char *s) {
    while (*s) {
      put_char(*s++);
    }
    return *this;
  }

  inline FastOutput &operator<<(const string &s) {
    for (int i = 0; i < (int)s.size(); i++) {
      put_char(s[i]);
    }
    return *this;
  }

  template <typename T> inline char *integer_to_string(T n) {
    // beware of TMP_SIZE
    char *p = tmp + TMP_SIZE - 1;
    if (n == 0) {
      *--p = '0';
    } else {
      bool is_negative = false;
      if (n < 0) {
        is_negative = true;
        n = -n;
      }
      while (n > 0) {
        *--p = (char)('0' + n % 10);
        n /= 10;
      }
      if (is_negative) {
        *--p = '-';
      }
    }
    return p;
  }

  template <typename T>
  inline typename enable_if<is_integral<T>::value, char *>::type
  stringify(T n) {
    return integer_to_string(n);
  }

#if !defined(_WIN32) || defined(_WIN64)
  inline char *stringify(__int128 n) { return integer_to_string(n); }
#endif

  template <typename T>
  inline typename enable_if<is_floating_point<T>::value, char *>::type
  stringify(T n) {
    sprintf(tmp, "%.17f", n);
    return tmp;
  }

  template <typename T> inline FastOutput &operator<<(const T &n) {
    auto p = stringify(n);
    for (; *p != 0; p++) {
      put_char(*p);
    }
    return *this;
  }
} fast_output;

#define cout fast_output

  ]], {})),


  s("modint", myfmt([[
template <int MOD_> struct modnum {
	static constexpr int MOD = MOD_;
	static_assert(MOD_ > 0, "MOD must be positive");

private:
	using ll = long long;

	int v;

	static int minv(int a, int m) {
		a %= m;
		assert(a);
		return a == 1 ? 1 : int(m - ll(minv(m, a)) * ll(m) / a);
	}

public:

	modnum() : v(0) {}
	modnum(ll v_) : v(int(v_ % MOD)) { if (v < 0) v += MOD; }
	explicit operator int() const { return v; }
	friend std::ostream& operator << (std::ostream& out, const modnum& n) { return out << int(n); }
	friend std::istream& operator >> (std::istream& in, modnum& n) { ll v_; in >> v_; n = modnum(v_); return in; }

	friend bool operator == (const modnum& a, const modnum& b) { return a.v == b.v; }
	friend bool operator != (const modnum& a, const modnum& b) { return a.v != b.v; }

	modnum inv() const {
		modnum res;
		res.v = minv(v, MOD);
		return res;
	}
	friend modnum inv(const modnum& m) { return m.inv(); }
	modnum neg() const {
		modnum res;
		res.v = v ? MOD-v : 0;
		return res;
	}
	friend modnum neg(const modnum& m) { return m.neg(); }

	modnum operator- () const {
		return neg();
	}
	modnum operator+ () const {
		return modnum(*this);
	}

	modnum& operator ++ () {
		v ++;
		if (v == MOD) v = 0;
		return *this;
	}
	modnum& operator -- () {
		if (v == 0) v = MOD;
		v --;
		return *this;
	}
	modnum& operator += (const modnum& o) {
		v += o.v;
		if (v >= MOD) v -= MOD;
		return *this;
	}
	modnum& operator -= (const modnum& o) {
		v -= o.v;
		if (v < 0) v += MOD;
		return *this;
	}
	modnum& operator *= (const modnum& o) {
		v = int(ll(v) * ll(o.v) % MOD);
		return *this;
	}
	modnum& operator /= (const modnum& o) {
		return *this *= o.inv();
	}

	friend modnum operator ++ (modnum& a, int) { modnum r = a; ++a; return r; }
	friend modnum operator -- (modnum& a, int) { modnum r = a; --a; return r; }
	friend modnum operator + (const modnum& a, const modnum& b) { return modnum(a) += b; }
	friend modnum operator - (const modnum& a, const modnum& b) { return modnum(a) -= b; }
	friend modnum operator * (const modnum& a, const modnum& b) { return modnum(a) *= b; }
	friend modnum operator / (const modnum& a, const modnum& b) { return modnum(a) /= b; }
};

template <typename T> T pow(T a, long long b) {
	assert(b >= 0);
	T r = 1; while (b) { if (b & 1) r *= a; b >>= 1; a *= a; } return r;
}

//const int mod = 1e9+7;
const int mod = 998244353;
using num = modnum<mod>;

vector<num> fact, ifact;

void init(){
	int N = 1100000;
	fact.resize(N);
	fact[0] = 1;
	for(int i = 1; i < N; i++) fact[i] = i * fact[i-1];
	ifact.resize(N);
	ifact.back() = 1 / fact.back();
	for(int i = N - 1; i > 0; i--) ifact[i-1] = i * ifact[i];
}

num ncr(int n, int k){
	if(k < 0 || k > n) return 0;
	return fact[n] * ifact[k] * ifact[n-k];
}
  ]], {})),
  s("tpl", fmt(
    [[
/* {} */
#include<bits/stdc++.h>
#include<iostream>
using namespace std;
typedef long double ld;
typedef long long ll;
typedef pair<int, int> pii;
typedef pair<ll, ll> pll;
#define mp make_pair
#define pb push_back
#define eb emplace_back
#define ar array
#define fi first
#define se second
#define rep(i, begin, end) for (__typeof(end) i = (begin) - ((begin) > (end)); i != (end) - ((begin) > (end)); i += 1 - 2 * ((begin) > (end)))
#define L(i, j, k) for(int i = (j); i <= (k); ++i)
#define R(i, j, k) for(int i = (j); i >= (k); --i)
#define all(x) x.begin(), x.end()
#define len(x) int(x.size())
#define MIN(v) *min_element(all(v))
#define MAX(v) *max_element(all(v))
#define LB(c, x) distance((c).begin(), lower_bound(all(c), (x)))
#define UB(c, x) distance((c).begin(), upper_bound(all(c), (x)))
#define UNIQUE(x) sort(all(x)), x.erase(unique(all(x)), x.end()), x.shrink_to_fit()

template<typename A> void chmin(A& l, const A& r){{ if(r < l) l = r; }}
template<typename A> void chmax(A& l, const A& r){{ if(l < r) l = r; }}
template<typename T, std::size_t N> istream& operator >> (istream& is, array<T, N> &arr){{ rep(i, 0, N) is >> arr[i]; return is;}}
template<typename T> istream& operator >> (istream& i, vector<T> &vec){{for(auto &x: vec) i >> x; return i;}}

template <class T>
using V = vector<T>;
template <class T>
using VV = vector<V<T>>;
template<class T> using PQ = priority_queue<T, vector<T>, greater<T>>;


#ifdef LOCAL
#include <atcoder/debug.h>
#else
#define debug(...) 42
#define debug_assert(...) 42
#endif

{}
    ]],
    { t(os.date("%Y-%m-%d %X")),
      c(1, {
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
        ]], { i(1) })
        ),
        sn(nil, fmt([[
int main() {{
	cin.tie(nullptr); ios::sync_with_stdio(false);
  {}
}}
        ]], { i(1) })
        ),

      })
    })
  ),
}, {
  parse("autotrig", "autotriggered, if enabled")
}
