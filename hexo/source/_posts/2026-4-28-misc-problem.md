---
title: SDOI2026二轮省集 杂题
date: 2026-04-28 15:56:33
tags:
- 练习题
categories: 2026二轮省集
---
# Day 2
## 【未完成】[New Year and Boolean Bridges](https://codeforces.com/problemset/problem/908/H)
如果是 AND 就相当于两个点在同一个 SCC 内。OR 相当于没限制，XOR 相当于两个点不在同一个 SCC 内。

把所有 AND 的点都合并起来，不难发现最后一定是个链（不然就有不能到达的点）。那么现在就是要求把一些 SCC 合并起来，使得最终的 SCC 数量最少（这里不考虑孤立点）。

发现删去孤立点以后最多只有 $23$ 个 SCC。因此可以设计一个状压 DP，记录 $f_{i, S}$ 表示加入了 $i$ 条树边，让 $S$ 集合内的 SCC 全部联通是否可行。转移可以是显然的，做子集枚举可以得到 $O(n3^n)$ 的做法。

然而这个并不能子集枚举。考虑实际上这可以转化成一个 OR 卷积的形式，因为正好是分成两部分，一部分是 $f_{i - 1, S_1}$，另一部分是 $f_{0, S - S_1}$。如果两个集合是有交的，那么显然应该也是能够符合要求的。

## 【未完成】[Takahashi The Strongest](https://atcoder.jp/contests/arc132/tasks/arc132_f)

## [[EGOI 2021] Double Move / 二选一游戏](https://www.luogu.com.cn/problem/P9316)
考虑对于某种固定下来的 $a, b$ 计算总共有多少种方式可以让 A 或者 B 赢。这是个比较典的套路，考虑相当于是对于每个 $(a_i, b_i)$ 作为一条边进行定向。

如果要枚举恰好在第 $i$ 个时刻寄掉的话似乎比较困难，因此考虑差分一下，转化成前 $i$ 个时刻游戏还在继续的方案数。

这样就要求没有一个点的入度大于 $2$。对于每个连通块，他如果是基环树就相当于是环任意定向，其他节点强制定向，只有两种方案，而如果是个树就可以任意一个节点作为根，有 $\operatorname{siz}$ 种方案。否则就无解了。

那么对于原问题，就相当于每次添加一条边。那么整个问题实际上与树的集合与基环树的数量有关的，那么直接搜索，复杂度与划分数量相关，由于 $n$ 很小，划分数量应该是 $10^4$ 左右的级别，可以通过。

## [黎明前的巧克力](https://uoj.ac/problem/310)
A 和 B 的异或和相等，相当于 $A\cup B$ 的异或和为 $0$。而任意一种划分方式都是可行的。相当于转化成了求出所有异或和为 $0$ 的子集的 $2^{|S|}$ 的和。

考虑异或卷积，相当于对 $\prod (2x^{a_i} + 1)$ 求常数项的值。这可以用 FWT 做 XOR 卷积得到。

将 $2x^v + 1$ 作 FWT 变换会得到第 $k$ 项为 $1 + 2 \times (-1)^{\operatorname{popcount}(v \operatorname{AND} k)}$。因此他实际上只有 $-1$ 和 $3$ 两种取值。因此做乘法实际上就相当于是 $(-1)^{\text{ODD}} \cdot 3^{\text{EVEN}}$。

问题是由于需要对于每个 $k$ 都做一遍，就算只是统计奇数和偶数项好像也会爆炸，因此需要有一种办法能够优秀地求对于每个 $k$ 的答案。

因此将整个问题转化到出现的频数上做，考虑记录对于每个 $v$ 一共出现了多少次，记录为 $C$。对这个 $C$ 做 FWT 变换之后，得到的第 $k$ 项就是 $\sum\limits_vC_v \times (-1)^{\operatorname{popcount}(v \operatorname{AND} k)}$。

发现其实这就是 $\text {EVEN} - \text {ODD}$。而还知道 $\text {EVEN} + \text {ODD} = n$，解方程就能得到两个未知数了，直接计算即可。

# Day 3
## [[CERC2017] Intrinsic Interval](https://www.luogu.com.cn/problem/P4747)

不难发现两个好区间的交还是好区间，所以其实只需要找到可行的左端点即可。

那么从右往左扫，每次找最左边的左端点即可。查询的时候相当于查询单点的最大值。

## 【未完成】[Almost Multiplication Table](https://atcoder.jp/contests/agc061/tasks/agc061_d)

## [Graph Coloring](https://qoj.ac/problem/4217)
给每个节点一个颜色集合 $S$，发现只要 $S_u \nsubseteq S_v$，那么 $u \to v$ 就可以选出一个肯定不会在 $v$ 中出现的颜色。

于是给每个节点分配 $7$ 种不同的颜色，可以得到 $\binom{14}{7}$ 种集合，这玩意大于 $n$，于是做完了。

## [Hidden Graph](https://qoj.ac/problem/4218)

相当于是说一个图最多有 $k + 1$ 个独立集，因为考虑不断删除度数最小的点直到删空，然后反着插入，那么每次插入的节点的度数都小于 $k$，因此一定可以把他划分到原先 $k + 1$ 个独立集之中的一个。

于是每次插入一个节点，暴力查询他与 $k + 1$ 个独立集之间的边即可。这样的话查一个点的边只会用 $k + 1$ 次，非常牛。

## 【未完成】[Check,Check,Check one two!](https://www.luogu.com.cn/problem/P5115)

考虑 $\operatorname{lcs}(i, j)$ 和 $\operatorname{lcp}(i, j)$ 拼在一起相当于一个极长的相等子串，那么就相当于枚举 $i,j$，如果这个位置前面不同那么他的 $\operatorname{lcp}$ 就可以产生贡献。那么实际上贡献形式只有 $O(n)$ 种，只与 $\operatorname{lcp}$ 长度有关。推导一下发现实际上是个求等差数列和平方数列的和的形式，于是可以 $O(n)$ 处理。

但是 $s_i \neq s_j$ 不好做，考虑容斥，计算所有答案和 $s_i = s_j$ 的答案即可。