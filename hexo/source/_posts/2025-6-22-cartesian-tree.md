---
title: 笛卡尔树
date: 2025-06-22 19:52:33
tags:
- 学习笔记
- 数据结构
---

# 算法

笛卡尔树是一种非常简单的 Treap。这是一种静态的平衡树，不支持修改操作，如果给定的序列是有序的，那么可以直接在 $O(n)$ 的时间复杂度内完成建树。一般而言，题目中多半会把元素的下标作为 Treap 的排名权值（即满足二叉树性质的那个维度）。

在这种情况下，建笛卡尔树的方法比较巧妙。首先，我们维护一个“右链”，也就是当前的树的最右侧的元素构成的链。此时如果需要新建一个节点，一定会在这条链上。原因很简单，一个二叉查找树的右子树一定比当前节点大，而由于我们是顺序插入的，这个权值一定是最大的。

但是还有堆的性质。也就是说我们应该在这个链上找一个合适位置插入，然后原来这个节点的右子树改为当前节点的左子树。

代码如下：
```cpp
#include <iostream>
#include <stack>

#define IAKIOI for (int i = 1; i <= n; i++) 
using namespace std;
const int N=1e7+10;
int p[N],ch[N][2];

inline void build(int n){
    stack<int>st;st.push(1);
    int top=1;
    for(int i=2;i<=n;i++){
        while(!st.empty()&&p[st.top()]>p[i])st.pop();
        if(st.empty())ch[i][0]=top,top=i;
        else ch[i][0]=ch[st.top()][1],ch[st.top()][1]=i;
        st.push(i);
        // cout<<st.top()<<" "<<p[st.top()]<<" "<<i<<" "<<p[i]<<" ";
        // cout<<st.size()<<endl;
    }
}
signed main() {
    ios::sync_with_stdio(0);
    cin.tie(0);cout.tie(0);
    int n;
    cin>>n;
    for(int i=1;i<=n;i++)cin>>p[i];
    build(n);
    // IAKIOI cout<<i<<" "<<ch[i][0]<<endl;
    // IAKIOI cout<<i<<" "<<ch[i][1]<<endl;
    int ans=0;
    IAKIOI ans^=(i*(ch[i][0]+1));cout<<ans<<" ";ans=0;
    IAKIOI ans^=(i*(ch[i][1]+1));cout<<ans<<endl;
}
```

# 应用

## 1. RMQ 又一解决方案

找到 $l$ 和 $r$ 所对应的元素并且求出这两个元素的 LCA，这个节点就是最值。（至于是最大值还是最小值就要看你的堆是怎么建的）。

## 2. 区间的最小值

[例题](https://www.luogu.com.cn/problem/B4273)

这种东西显然就是找一个区间的长度乘以区间最小值的最大值。直接枚举是 $O(n^2)$ 的，显然会炸掉。注意到对于一个最小值，它只有左右都延伸到极限的时候，也就是说这个区间两侧的两个矩形都比这个区间的最小值要小的时候，这个区间才可能成为答案。

因此我们以矩形高度为优先级建笛卡尔树，这样的话一个节点的子树大小就是这个极限的长度，再乘上这个节点的高度，然后求最大值就好了。

**THE END**

（又补完一篇博客）