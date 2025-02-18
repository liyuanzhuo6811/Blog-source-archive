---
title: 9月7日——图论练习题目
date: 2024-09-07 16:28:01
tags:
---

# [NOIP2015提高组 信息传递](https://www.luogu.com.cn/problem/P2661)

先读题，这个题目可以转化为一条 $n$ 个点，$n$ 条边的有向图，然后找到这里面的最小环。

那么我们就直接去找最小环？肯定不行啊。注意到这个题目中，

> 可能有人可以从若干人那里获取信息，但是每人只会把信息告诉一个人，即自己的信息传递对象

这其实就是说，这个图每个点的出度都是 $1$。

这个信息怎么用呢？先不急。我们先考虑特殊情况，即这个图是连通图。由于每一条边的出度都是 $1$，在 $n-1$ 条边时这就是一个链，而有 $n$ 条边的时候就是一个链连着一个环。用样例感受一下：

![](https://s21.ax1x.com/2024/09/07/pAeQsc8.png)

1. 首先，这个图里面肯定有一个环（因为有 $n$ 条边，并且这个有向图的出度为 $1$，如果不存在环，一定有一个点是没有出边的）。
2. 其次，这个环肯定在链的后面（因为如果这个环后面还连着什么东西，那么这个环就一定有一个节点）
3. 
这样的话，我们随便找一个节点开始 DFS，就肯定能够找到环。
1. 这个点在环上。这样的话，由于这个环已经到了链的末端，不可能再有出边，只要遍历一圈就一定能够找到这个环。
2. 这个点在链上。这样的话，直接遍历到环上，转化为情况1。

最终怎么记录环的大小呢？只要用 DFN 相减即可。

不是连通图怎么办呢？注意到每一个点的出边都是 $1$，也就意味着边和点是一一对应的，因此每个连通块都有和点数相同的边。转化为连通图进行计算，把所有的环记录下来，取最小值即可。

如果这个题还要让你输出这个环的路径，那就加个栈，然后用 Tarjan 跑一遍就是了。

```cpp
#include<bits/stdc++.h>
#define int long long
using namespace std;
const int N=2e5+10;
int dfn[N],f[N],fa[N],n;
bool ins[N];
int Find(int x){
    if(fa[x]==x)return x;
    return fa[x]=Find(fa[x]);
}
int dfs(int u,int l){
    if(dfn[u])return l-dfn[u];
    dfn[u]=l;
    return dfs(f[u],l+1);
}
signed main(){
    cin>>n;
    for(int i=1;i<=n;i++)fa[i]=i;
    for(int i=1;i<=n;i++){
        cin>>f[i];
        int x=Find(i),y=Find(f[i]);
        if(x!=y)fa[x]=y;
    }
    int ans=0x3f3f3f3f3f3f3f3f;
    for(int i=1;i<=n;i++){
        if(!dfn[Find(i)])ans=min(ans,dfs(i,1));
    }
    cout<<ans<<endl;
}
```

# [NOIP2020 排水系统](https://www.luogu.com.cn/problem/P7113)

这个题目比较有趣。看到这个图是 DAG，就会自然而然想到拓扑排序。研究样例可以发现，如果要让计算复杂度最小，我们需要让一个节点已经算完再计算下一个。怎么算是算完了呢？就是所有的污水都已经算过了。换句话说，就是入度为 $0$。这不就是拓扑排序的经典模型吗？

最后的一个小障碍就是计算。这个题让保留精确值，不过也不难，手推式子就能轻松得到答案。

```cpp
#include<iostream>
#include<queue>
#include<cstring>
#include<cstdio>
#include<vector>
#include<cstdlib>
#include<algorithm>
using namespace std;
typedef __int128_t i128;
const int N=2e5+10;
i128 a[N],b[N],d[N],p[N];
int ff[N];
int n,m;
queue<int>q;
vector<int>e[N];

void out(i128 a){
    if(a>=10)out(a/10);
    putchar(a%10+'0');
}

void top(){
    for(int i=1;i<=n;i++){
        if(p[i]==0)q.push(i),a[i]=1;
    }
    while(!q.empty()){
        int u=q.front();q.pop();
        for(int i=0;i<e[u].size();i++){
            int v=e[u][i];
            i128 x=a[u]*b[v]+a[v]*b[u]*d[u];
            i128 y=b[u]*d[u]*b[v];
            i128 g=__gcd(x,y);
            x/=g;y/=g;
            a[v]=x;b[v]=y;
            p[v]--;
            if(p[v]==0)q.push(v);
        }
    }
}

int main(){
    cin>>n>>m;
    int tot=0;
    for(int i=1;i<=n;i++){
        int x;
        cin>>x;
        if(x==0)ff[++tot]=i;
        for(int j=1;j<=x;j++){
            int v;
            cin>>v;
            e[i].push_back(v);
            p[v]++;
        }
        d[i]=x;
        b[i]=1;
    }
    top();
    for(int i=1;i<=tot;i++)out(a[ff[i]]),cout<<" ",out(b[ff[i]]),cout<<endl;
    return 0;
}
```

**这个题要用高精度。`__int128_t` 也行。**

# [CSP-J2019 江西 道路拆除](https://www.luogu.com.cn/problem/P5683)

这个题目是最短路的一个灵活考察。

题目让删边，那么想都不用想，就肯定是倒序加边。我们只要让这三点连通即可。换句话说，就是求一个关于他们三个节点的最小生成树，或者三个点的最短路。

但是我们只学过算两点最短路的算法和算全部点的最小生成树。看样子最短路更沾边，最小生成树是白搭了。

既然是三条边的最短路，我们可以想象到必然是一个树的形状。

这是第一种情况。

![](https://s21.ax1x.com/2024/09/07/pAe13LD.png)

这是第二种情况。

![](https://s21.ax1x.com/2024/09/07/pAe1Gee.png)

这是第三种情况。

![](https://s21.ax1x.com/2024/09/07/pAe1NFA.png)

也就是说，我们要找到这三种情况里面的最小值。

能不能合成一种情况呢？注意到第三种情况里面的中间节点，当他与节点 $1$ 重合的时候，就变成了第一种情况。另外也一样。

这样的话，我们其实就把问题变成了这样：对每一个节点都跑一遍最短路，找到从这个节点到另外三个节点的最短路，把长度相加，检查是否超过了 $t_1$，$t_2$ 的长度，如果没有，取最小值。复杂度 $O(N^2)$（用 BFS）或 $O(N^2\log n)$（用堆优化 Dijkstra）或 $O(\text{玄学})$（用 SPFA），可以通过本题。

```cpp
#include<iostream>
#include<vector>
#include<queue>
#include<cstring>
#include<cstdio>

using namespace std;
const int N=3100;
int d[N];
bool vis[N];
vector<int>e[N];
struct node{int v,w;bool operator <(node x) const{return w>x.w;}};

void dijk(int s){
    priority_queue<node>q;
    memset(d,0x3f,sizeof(d));
    memset(vis,0,sizeof(vis));
    d[s]=0;
    q.push((node){s,0});
    while(!q.empty()){
        int x=q.top().v;q.pop();
        if(vis[x])continue;
        vis[x]=1;
        for(int i=0;i<e[x].size();i++){
            int v=e[x][i];
            if(vis[v])continue;
            if(d[x]+1<d[v]){
                d[v]=d[x]+1;
                q.push((node){v,d[v]});
            }
        }
    }
}
int main(){
    int n,m,mm;
    cin>>n>>m;
    mm=m;
    while(mm--){
        int u,v;
        cin>>u>>v;
        e[u].push_back(v);
        e[v].push_back(u);
    }
    int s1,t1,s2,t2;
    cin>>s1>>t1>>s2>>t2;
    dijk(1);
    if(d[s1]>t1||d[s2]>t2){
        cout<<-1<<endl;
        return 0;
    }
    int ans=d[s1]+d[s2];
    for(int i=1;i<=n;i++){
        dijk(i);
        if(d[s1]+d[1]>t1||d[s2]+d[1]>t2)continue;
        ans=min(ans,d[s1]+d[s2]+d[1]);
    }
    cout<<m-ans<<endl;
}
```