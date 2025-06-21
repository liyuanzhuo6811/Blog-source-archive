---
title: 数论分块
date: 2025-02-16 15:40:44
tags:
  - 数学
  - 数论
  - 学习笔记
---

# 一类问题

有一类问题，要求你求：

$$\sum_{i=1}^n\lfloor \frac{n}{i} \rfloor$$

这样的东西。$n$ 的范围往往很大（$10^9 \sim 10^{15}$），要用低于线性的复杂度。

# 思路

一般而言，这种东西的性质就是：虽然 $n$ 很大，但是很多的数都是相同的：

| $i$ | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 |
|---|---|---|---|---|---|---|---|---|---|---|
| $\lfloor \frac{10}{i} \rfloor$ | 10 | 5 | 3 | 2 | 2 | 1 | 1 | 1 | 1 | 1 |

所以我们没必要把每个 $\lfloor \frac{n}{i} \rfloor$ 都求出来。

考虑会有多少种可能的 $\lfloor \frac{n}{i} \rfloor$ 的取值：

![](https://s21.ax1x.com/2025/06/21/pVZkzjJ.png)

在 $\sqrt{n}$ 以后，$f(x)=\frac{n}{x}$ 的导数小于 $1$，因此 $f(x)$ 的变化速度要低于 $x$，因此 $\forall y \in [1,\sqrt n] \cap \mathbb{N}$ 都是可能的取值。

在 $\sqrt{n}$ 以前，一共只有 $\sqrt n$ 种可能的取值，而由于导数大于 $1$，$\forall x \in [1,\sqrt n] \cap \mathbb{N}$ 所对应的 $f(x)$ 都不同。

因此，变化次数为 $O(\sqrt n)$。

那么，怎么求出每种取值的区间呢？

假设一种取值对应的区间为 $[l, r]$，则：

$$\lfloor \frac{n}{l} \rfloor \le \frac{n}{r} < \lfloor \frac{n}{l} \rfloor+1$$

所以：


$$r\leqslant\left\lfloor\dfrac{n}{\left\lfloor\dfrac{n}{l}\right\rfloor}\right\rfloor$$

$$r_{max}=\left\lfloor\dfrac{n}{\left\lfloor\dfrac{n}{l}\right\rfloor}\right\rfloor$$

**THE $\sqrt{}$ END**

（又补完一篇博客）

---

# Code

```cpp
#include <iostream>
using namespace std;
using ll = long long;
int main() {
	ll n, k;
	cin >> n >> k;
	ll l, r;
	ll ans = n * k;
	for (l = 1; l <= n; l = r + 1) {
		if (k / l) r = min(k / (k / l), n);
		else r = n;
		ans -= (r - l + 1) * (k / l) * (l + r) / 2;
	}
	cout << ans << endl;
}
```