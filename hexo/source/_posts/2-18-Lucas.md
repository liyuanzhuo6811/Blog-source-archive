---
title: Lucas定理
date: 2025-02-18 17:02:33
tags:
---

# Part 0. 引子

众所周知：

$$
C^n_{m}=\frac{n!}{m!(n-m)!}
$$

现在有个问题：

- 当 $n$，$m$ 比较大的时候，直接用除法会寄掉（因为`long long`能够存储的数相对于阶乘而言小得可怜），此时一般会让你求出这个组合数对一个数取模的结果。但是除法不能直接取模，怎么办？

这个问题的答案还是比较显然的，我们只要用费马小定理求出阶乘的逆元。

然后第二个问题来了：

- 有多组测试数据，每组的取模都不一样，每一次都要求一个很大的组合数，怎么办？

对于这个问题，有一个非常简单的办法：**~~想办法给出题人打 100 万，然后要到数据~~**。

还有一个办法：

# Part 1. Lucas 定理的证明

对于一个组合数：

$$
C^n_p \mod p(p 为素数,n \le p)
$$

可以把它表示成这样的形式：

$$
\frac{p!}{i!(p-i)!} \mod p
$$

由于 $p$ 是质数注意到分子（$p!$）的质因数分解中只有一个 $p$，当 $i \in [1,p-1]$ 的时候，分母中没有因数 $p$，所以取模的结果就是 $0$。当 $i \in \{0,p\}$ 的时候，显然组合数等于 $1$，因此有：

$$
C^n_p \mod p = [n \in \{0, p\}]
$$

那么再结合二项式定理的模数，即：

$$
\begin {align}
\nonumber
(a + b)^p \mod p &= \sum_{k=0}^nC^k_na^kb^{p-k} \mod p\\
\nonumber
&= \sum_{k=0}^n(C^k_na^kb^{p-k} \mod p) \mod p\\
\nonumber
&= \sum_{k=0}^n[(C^k_n \mod p) a^kb^{p-k}] \mod p\\
\nonumber
&= \sum_{k=0}^n([k \in \{0,n\}] a^kb^{p-k}) \mod p\\
&= (a^p + b^p) \mod p \\
\end{align}
$$

注意到刚才的推导由于不需要保证互质等条件，适用于 $a, b$ 为多项式的情况。

那么我们就带进去个式子试试？

设 $f(x)=ax^n+bx^m$，则：

$$
\begin {align}
\nonumber
f^p(x) \mod p &= (ax^n+bx^m)^p \mod p\\
\nonumber
&= (ax^n+bx^m)^p \mod p\\
\nonumber 
&= (a^px^{np}+b^px^{mp}) \mod p \\ 
\nonumber 
&= (ax^{np}+bx^{mp}) \mod p (费马小定理)\\ 
&= f(x^p)
\end{align}
$$

~~到这里，我们距离推导 Lucas 定理又近了 $0$ 米，继续加油！~~

上面这一坨东西怎么和求一个组合数扯上关系呢？答案是：二项式定理可以提供组合数。

也就是这样：

$$
(1 + x)^n = \sum_{k = 0}^nC_n^ix^i
$$

而我们要对这个式子取模：

$$
\begin{align}
\nonumber
(1 + x)^n &= (1+x)^{p \times \lfloor\frac{n}{p}\rfloor}(1+x)^{n \mod p} \\
\nonumber
&\equiv(1+x^p)^{\lfloor\frac{n}{p}\rfloor}(1+x)^{n \mod p}
\end{align}
$$

这一坨东西可以分成前后两部分。第一部分的展开式