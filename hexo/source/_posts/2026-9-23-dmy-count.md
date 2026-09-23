---
title: 9.25 计数
date: 2026-09-23 10:21:15
tags:
- 练习题
- 计数
categories: 代码源9月集训
---

## A. [Legendary Game](https://qoj.ac/problem/20297)
所有的数可以被分成三类，分别是 $[1,N],[N+1,N+K,N+K+1,2N]$。

考虑抽出来的牌的形态，显然应该是左右交替直到遇到一个中间的数。而中间的数只有 $K$ 个，所以考虑用中间的数把序列分成若干段。

每一段应该有四种形态，并且当长度确定的时候，数量都是固定的：

- 空段（显然只有一种）
- 左右相等（可以是左边在前，也可以是右边在前，共两种）
- 左边多（只能是左边在两端）
- 右边多（只能是右边在两端）

把第一种情况扔进左右相等的部分里（其实扔到哪里应该都行），假设后三种有 $x,y,z$ 个，从 $x$ 中选出 $w$ 个非空的。这些段的奇偶性不同，但是由于已经枚举出来了每种的数量，考虑对他们都除以 $2$ 下取整，也就是将每个左右的对都拿出来，这样就可以直接变成放小球的模型了。划分的方式选完以后，再做一个多重排列确定每种的方式，以及计算选出来的牌的排列。
## B. [Existence Counting](https://atcoder.jp/contests/arc174/tasks/arc174_e)

## C. [Amanojaku and Sequence (Hard Version)](https://codeforces.com/problemset/problem/2228/E2)

## D. [The Destruction of the Universe (Hard Version)](https://codeforces.com/problemset/problem/2030/G2)

## E. [No Streak](https://atcoder.jp/contests/agc070/tasks/agc070_c)

## F. [Four Square Tiles](https://atcoder.jp/contests/arc197/tasks/arc197_e)
