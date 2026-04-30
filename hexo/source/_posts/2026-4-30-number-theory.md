---
title: number-theory
date: 2026-04-30 16:00:33
tags:
categories:
---
## [密码学第三次小作业](https://www.luogu.com.cn/problem/P5451)
考虑一定可以找到一组 $s, t$，满足 $s e_1 + t e_2 = 1$。

那么只需要找到一组 $s, t$，可以得到 $c_1^sc_2^t \equiv m \pmod N$。

## [So Mean](https://www.luogu.com.cn/problem/CF1299E)
把除了 $k$ 以外的所有数都放进去问一遍，那么发现只有 $1$ 和 $n$ 的结果是 $1$。由于他是对称的，随便钦定一个 $1$ 和 $n$ 就可以。

同样，去掉这两个数可以同样的方式知道 $2$ 和 $n - 2$，这样就可以 $O(n^2)$ 问出来了。

考虑优化。如果能够得到每个位置的数对几个小质数的余数，就可以通过 CRT 得到最终的答案。也就是说，考虑把 $a_i$ 分别和 $\{1, 2\}$,$\{1,3\}$,$\{2,3\}$ 放在一块，就可以得到对 $3$ 的余数。

取模数集合为 $\{3, 5, 7, 8\}$ 就可以满足条件了。而对于每个实际上都跑不满，所以理论上就能过了。更优秀的做法是，发现可以容易地确定 $a_i \bmod 2$ 的值，那么实际上再问一次就可以得到 $a_i \bmod 4$ 的值，然后也可以得到 $8$，这样的话就很保险了。

## [±AB](https://atcoder.jp/contests/arc127/tasks/arc127_f)
> 引理：如果 $A + B - 1 \le M$，且 $x = V + pA + qB$，则 $V$ 可以变成 $x$。

这是容易构造的。

那么现在只需要解决 $A + B \ge M$ 的情况。先令 $V \to V \bmod A$，然后如果第一次选择 $+A$，下一次肯定不能选 $+B$，所以只能 $+A$ 或者 $-B$，而这两个不能同时成立，因此每个只有一条出边。

可以证明，转移图是没有环的，因为假如存在一个最小的环，那么就一定存在 $Ax = By$，由于 $\gcd = 1$，其最小解就是 $x=B,y=A$，但是这样走了大于 $M$ 步，所以这个环还可以更小。

同时两种走法是无交的，因为起点相同且操作相反，有交就肯定会成环。所以现在可以对这两种情况分别计算答案。

假设进行 $k$ 次 $+A$，再进行若干次 $-B$，相当于计算这样最远能走多少步。

那么假设进行了 $k$ 次 $+A$ 的操作，由于现在被卡死（不能加减），此时的 $x \in [M - A + 1, B - 1]$。这样就可以解出来发现一定进行了 $\left \lfloor \frac {V + kA}B\right \rfloor$ 次 $-B$ 的操作。

这样是根据上界得到的操作次数，在用它带回去得到 $x = (V + kA) \bmod B\ge M + 1$，相当于求最小的 $k$。

那么令 $V' = V \bmod B$，如果 $V' + A > M$，那么显然有 $k = 1$。否则，一定有 $V' + (kA) \bmod B < B$，否则这个终态还可以继续操作。

因此得到了这个式子的范围，转化为求 $L \le kA \bmod B \le R$ 的最小 $k$。这个问题需要进行一些转化，看上去取模不太好做，考虑转化成下取整的形式：

$$
\begin{align*}
kA \bmod B & \in [L,R] \\
\Rightarrow kA - B \left\lfloor \frac {kA}B\right \rfloor &  \in [L,R] \\
\Rightarrow kA - (B \bmod A)\left\lfloor \frac {kA}B\right \rfloor-A \left\lfloor \frac BA\right \rfloor\left\lfloor \frac {kA}B\right \rfloor &\in [L,R]\\
\Rightarrow A(k - \left\lfloor \frac BA\right \rfloor\left\lfloor \frac {kA}B\right \rfloor)-(B \bmod A)\left\lfloor \frac {kA}B\right \rfloor & \in [L, R]
\end{align*}
$$

对这个东西进行换元，令 $y = \left\lfloor \frac {kA}B\right \rfloor$。那么经过变换，上面的式子就等价于：

$$
(B \bmod A)y \in [AX-r,AX - l]
$$

也就是说把两边对 $A$ 取余就可以把 $X$ 消掉，剩下一个 $(B \bmod A)y \bmod A \in [-r, -l]$。这个问题和上面的形式相同，于是可以类欧几里得计算。

这个东西的感性理解方式就是相当于从 $0$ 开始每次往后跳 $A$ 步，每次大于 $B$ 就直接传送回来，那么这个 $y$ 就相当于是传送的次数，边界就是如果不用传送就能落在区间里面一定是优的，否则就相当于每次传送回来都产生一些偏移，得到了一个完全相同的子问题。

