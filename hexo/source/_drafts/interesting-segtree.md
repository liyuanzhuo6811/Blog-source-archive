---
title: 线段树真好玩
tags:
- 数据结构
- 学习笔记
---

# 李超线段树

线段树的每个节点维护 $\text{mid}$ 处最高（或最低）的线段。当我们新加一个线段的时候，和原来的东西对比，如果成功了的话就把比下去的那一条线段下传。

统计答案时可以直接把一个区间可能成为答案的所有线都枚举一遍，复杂度 $O(\log n)$。如果是线段的话，就把这个线段拆成一些整段的长度，分别加入到对应的节点。

实现的话，放个模板题的代码

```cpp
#include <cmath>
#include <iostream>
#include <ostream>
#include <stdarg.h>
#define int long long
using namespace std;
using ldb = long double;
const int N      = 1e5 + 10, BMD = 1e9 + 7, SMD = 39989;
const ldb eps = 1e-14;
struct Line {
    ldb k, b, id;
    Line() {}
    Line(ldb kk, ldb bb, int idx) : k(kk), b(bb), id(idx) {}
    Line(ldb x0, ldb y0, ldb x1, ldb y1, int idx) {
        id = idx;
        if (x0 == x1) k = 0, b = max(y0, y1);
        else k = (y1 - y0) / (x1 - x0), b = y0 - k * x0;
    }
    inline ldb operator()(int x) { return k * x + b; }
    inline bool greater(Line x, int t) { return k * t + b > x(t); }
};
ostream &operator<<(ostream &os, Line &x) {
    return os << x.id << " " << x.k << " " << x.b;
}
inline bool beat(Line x, Line y, int p) {
    return (x(p) < y(p)) || (fabs(x(p) - y(p)) < eps && x.id > y.id);
}
struct SegT {
    Line maxl[N << 2];
    inline void update(int p, int l, int r, Line x) {
        int mid = (l + r) >> 1;
        if (!maxl[p].id) maxl[p] = x;
        if (beat(maxl[p], x, mid)) swap(x, maxl[p]);
        // cout << l << " " << r << "-" << maxl[p] << ":" << x << endl;
        if (beat(maxl[p], x, l)) update(p << 1, l, mid, x);
        if (beat(maxl[p], x, r)) update(p << 1 | 1, mid + 1, r, x);
    }
    inline void insert(int p, int l, int r, int x0, int x1, Line x) {
        // cout << p << " " << l << " " << r << " " << x << endl;
        if (l >= x0 && r <= x1)
            return update(p, l, r, x);
        int mid = (l + r) >> 1;
        if (x0 <= mid) insert(p << 1, l, mid, x0, x1, x);
        if (x1 > mid) insert(p << 1 | 1, mid + 1, r, x0, x1, x);
    }
    inline Line query(int p, int l, int r, int x) {
        if (l == r) return maxl[p];
        int mid = (l + r) >> 1;
        if (x <= mid) {
            Line qL = query(p << 1, l, mid, x);
            return (beat(maxl[p], qL, x)) ? qL : maxl[p];
        } else {
            Line qL = query(p << 1 | 1, mid + 1, r, x);
            return (beat(maxl[p], qL, x)) ? qL : maxl[p];
        }
    }
} tree;
signed main() {
    int q, lastans{0}, tot = 0;
    cin >> q;
    // cout << beat(Line(-1, 3, 2), Line(0, 1, 1), 2) << endl;
    while (q--) {
        int op, x0, x1, y0, y1;
        cin >> op >> x0;
        if (op) {
            cin >> y0 >> x1 >> y1;
            y0 = (y0 + lastans - 1) % BMD + 1;
            x0 = (x0 + lastans - 1) % SMD + 1;
            y1 = (y1 + lastans - 1) % BMD + 1;
            x1 = (x1 + lastans - 1) % SMD + 1;
            if (x0 > x1) swap(x0, x1), swap(y0, y1);
            tree.insert(1, 1, N, x0, x1, Line(x0, y0, x1, y1, ++tot));
        } else {
            x0 = (x0 + lastans - 1) % 39989 + 1;
            cout << (lastans = tree.query(1, 1, N, x0).id) << endl;
        }
    }
}
```

它常见的用法是优化 DP，应用范围和斜率优化类似。

## [基站建设](https://www.luogu.com.cn/problem/P2497)

首先考虑 DP。状态比较好想，一维就够了：

$$f_i = \min\{f_j + w(i, j)\} + v_i$$

然后考虑：$w(i, j)$ 表示链接到 $j$ 的代价，那么应该是 $\sqrt {r'}$。$r'$ 的计算用到勾股定理，由于 $j$ 位置的半径是固定的，我们只需要满足：

$$(x_i - x_j)^2+(r' - r_j)^2=(r_j + r')^2$$

大概化简一下：

$$(x_i - x_j)^2=(r' + r_j)^2-(r_j - r')^2$$
$$4r_jr'=(x_i - x_j)^2$$
$$r'=\frac{(x_i - x_j)^2}{4r_j}$$
$$\sqrt {r'} = \frac{x_i - x_j}{2\sqrt {r_j}}$$

然后方程也就出来了。接下来就是一些套路化简，然后可以得到一些直线的形式。（其实和斜率优化类似，但是这个东西会把 $i$ 看成 $y$，也就是求值而不是求截距，另外这个东西也不需要单调性。）

## [Sum of Prefix Sums](https://codeforces.com/problemset/problem/1303/G)

考虑前缀和的和可以直接通过合并同类项的方式变成如下的形式：

$$\sum_{i=1}^kis_i$$

那么我们可以通过点分治，把一条链分成两部分。

假设一条链是 $u \to 1 \to v$，那么 $1 \to v$ 这一部分的贡献比较简单，我们只需要维护一个**从上到下**的 $\sum_{i=1}^kis_i$。然而另一部分就麻烦一些，因为这一部分不是简单的**从下到上** $\sum_{i=1}^kis_i$，而是 $\sum_{i=t}^{k + t}is_i$。不过实际上这样也没问题，只需要再维护一个链长度即可。

这样，我们可以枚举这个链的一端，而直接计算另一端的最优值：

$$f_u = \max\{up_{u, i} + dis_{u, i} \cdot len_{u, j} + down_{u, v}\}$$

还是套路，李超树维护。

## [Escape Through Leaf](https://codeforces.com/problemset/problem/932/F)

方程还是非常好想的，$f_u = \min\{f_v + a_u \cdot b_v\}$。

那么现在的问题是，子树的限制不好做，于是考虑李超树合并。复杂度是 $O(\log n)$ 的，因为一个线最多就会在一边被下传，而下传不会超过 $O(\log n)$ 次。而考虑到线段树合并是 $O(n \log n)$ 的，整个复杂度就是 $O(n \log^2n)$ 的。

## ~~南斯拉夫集训~~ 最短路

### 题意

对于一张图，将经过的边的边权按顺序排列，代价是 $\sum cost(p_i, p_{i - 1})$，其中 $cost(x, y) = \sum_{i = 0}^k c_i x^{a_i}b^{b_i}$。$n,m \le 2 \times 10^5$，$k,a,b \le 5$。

### 解析

首先考虑边点互换。