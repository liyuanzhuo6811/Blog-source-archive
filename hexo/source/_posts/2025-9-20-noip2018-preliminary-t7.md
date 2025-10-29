---
title: NOIP2018初赛T7
date: 2025-09-20 09:36:10
tags:
- 数学
categories:
---

积分是不会的。

我们考虑有限的情况，即将一个线段均匀分成 $n - 1$ 段，这样就会有 $n$ 个点（包括两个端点）。

然后枚举线段的长度，取平均值就是期望了。（这里为了方便，我没有枚举实际长度，而是枚举了端点之间的线段数量，因此在分母位置还要多一个 $n - 1$）

$$E(n) = \frac{2\sum_{i=0}^{n - 1}i(n - i)}{(n - 1)n^2}$$

分子可以展开：

$$
\begin{aligned}
\sum_{i=0}^{n - 1}i(n - i) &= \sum_{i=0}^{n - 1}ni - i^2 \\
&= \sum_{i=0}^{n - 1}ni - \sum_{i=0}^{n - 1}i^2 \\
&= \frac{n^2(n - 1)}2 - \frac{n(n - 1)(2n - 1)}6 \\
\end{aligned}
$$

这样我们再回到原式，得到

$$
\begin{aligned}
E(n) &= 2 \cdot \frac{\frac{n^2(n - 1)}2 - \frac{n(n - 1)(2n - 1)}6}{(n - 1)n^2} \\

&=2 \cdot \frac{\frac{n^2}2 - \frac{n(2n - 1)}6}{n^2} \\

&= \frac{3n^2 - n(2n - 1)}{3n^2} \\
&= \frac{3n^2 - 2n^2 + n}{3n^2} \\
&= \frac13 + \frac{1}{3n}
\end{aligned}
$$

当 $n \to \infty$ 时，$\cfrac{1}{3n} \to 0$，则

$$E(x) = \frac13$$