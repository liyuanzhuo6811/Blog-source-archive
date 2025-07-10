---
title: FHQ-Treap
date: 2025-06-21 21:42:42
tags:
- 学习笔记
- 数据结构
---

# Part 1. 一些对比

FHQ Treap 与 Splay：

- FHQ Treap 的代码比 Splay 好写得多。
- FHQ Treap 只用到了一些分裂与合并，不会很大的影响到整个树的形态，所以这玩意更容易可持久化。
- 在一些特殊场合（例如 LCT）只能使用 Splay。

FHQ Treap 与 普通 Treap：

- FHQ Treap 不用旋转，更好写。
- 能支持更多功能。~~（比如帮助 lhc0707AKIOI）~~

这么好的东西我们肯定得学啊！

# Part 2. 思想

首先，假设你已经学会了普通 Treap。

接下来我们直接看分裂与合并。

## 更新

当我们改动一个节点的时候，其 `siz` 会发生变化，所以我们需要先写个这玩意：

```cpp
inline void Update(int x){siz[x]=siz[ls[x]]+siz[rs[x]]+1;}
```

## 分裂

对于一个大致长这个样子的平衡树——

![img](https://s21.ax1x.com/2024/12/26/pAvJJm9.png)

（节点中第一个数字表示值，第二个表示优先级）

现在搞点事情：对这个平衡树按照 $x$ 分裂成两棵树。分裂操作就是将一个树分成两个，一个都小于 $x$，一个都大于 $x$。（可能是大于等于什么的）

注意：这个操作并没有辣么简单！

不过首先我们看看简单情况：$x=155$。这个情况下，直接把 $150-220$ 这条边给他断了就完了。

然后我们来看看复杂情况：$x=205$。

此时，我们从根节点下手。因为 $150<205$，所以根节点在分裂以后肯定是左树的根。根节点的左子树都比根节点值小，所以分裂结束以后整个左子树一定还在原来的位置上不变。这样，我们就直接不管左子树，专心研究右子树。

看下一个节点：$220$。$220>205$，所以这个节点分裂以后肯定是右树的根。连同他的右子树都应该是在右树上的。到此为止都还算正常。

我们向左子树走。$210>205$，操作同上。

我们再向左子树走。$200<205$。这个玩意分裂以后应该处于左子树。但是我们把它放到哪啊？！

当前的左树是原树的根节点和其左子树。这个节点属于右子树，所以这个节点显然比根节点大。

那么，我们应该把它放在根节点的右子树上。完了。

这是代码：

```cpp
inline void Split(int u,int x,int &L,int &R){
    if(!u){L=R=0;return;}
    if(val[u]<=x)L=u,Split(rs[u],x,rs[u],R);
    else R=u,Split(ls[u],x,L,ls[u]);
    Update(u);
}
```

## 合并

等会，你把人家一个好好的平衡树撕成两半就晾那儿不管了？有分裂就有合并啊。

![img](https://s21.ax1x.com/2024/12/26/pAvY14P.png)

刚才的平衡树分裂完大概长这个样子。

我们怎么合并呢？那肯定得从根节点开始。来看一下两个根节点，谁才是合并以后的根呢？按照堆的性质，优先级小的节点在上面。那于是 $150$ 就是新节点咯。注意到 $220$ 比 $150$ 大，这样的话我们就把 $220$ 放到 $150$ 的右子树……吗？人家是有右儿子的，你怎么能像 Splay 那样随便就改人家的辈分呢？所以我们只能把这个节点的右子树和当前的右树。

代码：

```cpp
inline int Merge(int L,int R){
    if(!L||!R)return L|R;
    if(pri[L]<pri[R])return rs[L]=Merge(rs[L],R),Update(L),L;
    else return ls[R]=Merge(L,ls[R]),Update(R),R;
}
```

# Part 3. 操作

以下是一些常见操作。

## 插入

首先，我们把树按照 $x$ 分裂成两棵树。然后新建一个节点，把这个节点和左树合并，合并完再合并一次就完了。

```cpp
inline void Insert(int x){
    int L,R,p=Newnode(x);Split(root,x,L,R);
    root=Merge(L,Merge(p,R));
}
```

## 删除

要想删除一个节点，首先把树分裂成小于 $x$，等于 $x$，大于 $x$ 三棵树。然后我们合并中间那棵树的根节点的左右子树（不包括根，这样根节点就消失了），再把这些都合并起来。

```cpp
inline void Delete(int x){
    int L,R,p;
    Split(root,x,L,R);Split(L,x-1,L,p);
    p=Merge(ls[p],rs[p]);
    root=Merge(Merge(L,p),R);
}
```

## 第 k 大的数

这个不用分裂与合并。我们直接平衡树二分即可。

```cpp
inline int K_th(int u,int x){
    int sz=siz[ls[u]]+1;
    if(sz==x)return u;
    if(sz>x)return K_th(ls[u],x);
    else return K_th(rs[u],x-sz);
}
```

## 某个数的排名

首先把树分裂成小于 $x$ 和大于等于 $x$ 的两棵树，然后小于 $x$ 的树的大小再加上 $1$ 就是答案。

```cpp
inline int Get_Rank(int x){
    int L,R;Split(root,x-1,L,R);
    int ans=siz[L];
    return root=Merge(L,R),ans;
}
```

## 前驱

首先把树分裂成小于 $x$ 和大于等于 $x$ 的两棵树，然后小于 $x$ 的树的最右边的数就是。

```cpp
inline int Pre(int x){
    int L,R;Split(root,x-1,L,R);
    int ans=K_th(L,siz[L]);
    root=Merge(L,R);
    return ans;
}
```

## 后继

首先把树分裂成小于等于 $x$ 和大于 $x$ 的两棵树，然后大于 $x$ 的最小值就是。

```cpp
inline int Nxt(int x){
    int L,R;Split(root,x,L,R);
    int ans=K_th(R,1);
    root=Merge(L,R);
    return ans;
}
```

# Part 4. 代码

```cpp
#include<iostream>
#include<cstdio>
#include<cstdlib>
#include<vector>
#include<queue>
#include<cstring>
#include<stack>
#include<map>
#include<algorithm>
#include<cmath>
#include<fstream>
#if __cplusplus >= 201103L
#include<chrono>
#include<random>
#include<unordered_map>
#endif
using namespace std;

#define endl '\n'
#define fi first
#define se second
#define _fil(__in,__out) freopen(__in,"r",stdin),freopen(__out,"w",stdout)
typedef long long ll;
typedef unsigned long long ull;
mt19937 rng(chrono::system_clock::now().time_since_epoch().count());
typedef pair<int,int> pii;
typedef pair<ll,ll> pll;

const int N=1e5+10;
int val[N],siz[N],pri[N],ls[N],rs[N],fa[N],tot,root;
inline void Update(int x){siz[x]=siz[ls[x]]+siz[rs[x]]+1;}
inline int Newnode(int x){
    ++tot;
    pri[tot]=rng()%200,val[tot]=x,siz[tot]=1;
    return tot;
}
inline void Split(int u,int x,int &L,int &R){
    if(!u){L=R=0;return;}
    if(val[u]<=x)L=u,Split(rs[u],x,rs[u],R);
    else R=u,Split(ls[u],x,L,ls[u]);
    Update(u);
}
inline int Merge(int L,int R){
    if(!L||!R)return L|R;
    if(pri[L]<pri[R])return rs[L]=Merge(rs[L],R),Update(L),L;
    else return ls[R]=Merge(L,ls[R]),Update(R),R;
}
inline void Insert(int x){
    int L,R,p=Newnode(x);Split(root,x,L,R);
    root=Merge(L,Merge(p,R));
}
inline void Delete(int x){
    int L,R,p;
    Split(root,x,L,R);Split(L,x-1,L,p);
    p=Merge(ls[p],rs[p]);
    root=Merge(Merge(L,p),R);
}
inline int K_th(int u,int x){
    int sz=siz[ls[u]]+1;
    if(sz==x)return u;
    if(sz>x)return K_th(ls[u],x);
    else return K_th(rs[u],x-sz);
}
inline int Get_Rank(int x){
    int L,R;Split(root,x-1,L,R);
    int ans=siz[L];
    return root=Merge(L,R),ans;
}
inline int Pre(int x){
    int L,R;Split(root,x-1,L,R);
    int ans=K_th(L,siz[L]);
    root=Merge(L,R);
    return ans;
}
inline int Nxt(int x){
    int L,R;Split(root,x,L,R);
    int ans=K_th(R,1);
    root=Merge(L,R);
    return ans;
}
inline void print(int u,int fa,char chi){
    if(!u)return;
    cout<<val[fa]<<","<<pri[fa]<<" "<<val[u]<<","<<pri[u]<<" "<<chi<<endl;
    print(ls[(u)],u,'L'),print(rs[(u)],u,'R');
}
int main(){
    int n;cin>>n;
    while(n--){
        int op,x;
        cin>>op>>x;
        switch(op){
            case 1:Insert(x);break;
            case 2:Delete(x);break;
            case 3:cout<<Get_Rank(x)+1<<endl;break;
            case 4:cout<<val[K_th(root,x)]<<endl;break;
            case 5:cout<<val[Pre(x)]<<endl;break;
            case 6:cout<<val[Nxt(x)]<<endl;break;
        }
    }
    print(root,0,'X');
}
```