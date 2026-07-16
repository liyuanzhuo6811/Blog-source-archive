---
title: 【补裆】ZROI2026 组合计数
date: 2026-07-16 07:59:07
tags:
- 组合数学
- 练习题
categories: 
- ZROI2026省选一轮课程
---

# 组合数
几个公式。
- 组合数列和
$$\sum_{i = r}^n \binom ir = \binom {n + 1}{r + 1}$$

考虑组合意义。

- 范德蒙德卷积
$$
\sum_{i = 0}^{k} \binom ai \binom b{k - i} = \binom {a + b}k
$$

清仓甩卖我杀了你。

- 范德蒙德卷积的对偶形式

$$ \sum_{k=0}^n \binom{k}{a} \binom{n-k}{b} = \binom{n+1}{a+b+1} $$

虽然不是上课讲的，但是想起来了就写一下吧，鬼知道明年会不会还有封印（seal）甩卖（sale）

- 卢卡斯定理
$$
\binom nm \equiv \binom {\lfloor n / p \rfloor}{\lfloor m / p \rfloor}\binom {n \bmod p}{m \bmod p} \pmod p
$$

妈妈生的。

# 容斥原理
算了吧，都整理到[这里](../2026-6-14-inversion)得了。