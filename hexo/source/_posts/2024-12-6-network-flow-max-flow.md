---
title: 网络流（一）：最大流
date: 2024-12-06 18:48:20
tags: 
- 学习笔记
- 图论
---

# Part 0. 场景
现在有一堆节点，每个节点连着一堆水管，每个水管有流量的限制（也就是说每个管子最多能流过多少水），现在从起点往里面猛灌水，问终点能得到多少水。

# Part 1. 概念

- 弧：就是边
- 流量：流量
- 剩余流量：还能留多少水

## 反向弧
反向弧是一个非常重要的概念，基本上这个概念会应用于所有的算法中。

大抵就是这样：流过来多少水，就能流回去多少水。

也就是说，正反弧加一块肯定是原来的流量。这个概念其实很有用，后面细说。

# Part 2. FF

FF 是远古时期的网络流算法，复杂度 $O(m \times \text{Maxflow})$。

这个算法说白了就是个大模拟。每一次都随便找一条从起点到终点的路径，然后给每一条边都减去这么多流量。

完了。真的。

不对！这玩意不是贪心吗？怎么证明正确性呢？或者说，大家可能非常轻松地就找到一些反例。~~哎哎哎你们别打我脸，我自己打~~：

![](https://s21.ax1x.com/2024/12/06/pA7PuRI.png)

显而易见，这里的最大流是这样两条增广路：

![](https://s21.ax1x.com/2024/12/06/pA7PIeO.png)

最大流为 $4$。

猛一看，这条路好像没问题。但是因为输入是随机的，你怎么会知道程序先走哪条边？如果他不是按照上面的方式来的，而是这样：

![](https://s21.ax1x.com/2024/12/06/pA7PqfA.png)

结果就是 $3 \to 4$ 的那一条边炸了，我们的 $1 \to 3$ 流不过去，导致了计算结果为 $3$。

这个问题的解决方式嘛……我们找个 xxs 来。

> 他把我东西抢了，你说我是不是应该把他的也抢了？

真聪明。就这么着，既然 $3 \to 4$ 这条边被抢了，那么我们就抢走他本来该走的那条 $2 \to 4$。

然后就又出问题了。如果我们直接用 $1 \to 3 \to 2 \to 4$ 的方式，会发现这条路产生了 $3$ 的流量。欸？？？这样加起来就是 $5$ 了！咋回事呢？其实是因为本来我们是不能走 $3 \to 2$ 这条路的，结果你现在直接用他的反边往回跑。这个的话，我们再请个看热闹不嫌事大的老师来。

> 你抢可以，但是他抢你多少，你就最多抢他多少。

~~看看人家多公平公正~~。没错，我们最多只能从这边流 $2$，因为本来我们也只能从 $3 \to 4$ 这边走 $2$。OK，这个时候就体现出“反向弧”这个概念的重要性来了。

![](https://s21.ax1x.com/2024/12/06/pA7i1pR.png)

当绿色的流流过 $2 \to 3$ 的这条边的时候，我们给这条弧的容量减去 $2$，他的反向弧，也就是这条红色的边加上 $2$。这样我们就可以再从这里流回去。现在，绿色表示正向弧的容量，红色表示反向弧的容量。现在我们终于搞明白了这个算法。

Code:
```cpp
#include <iostream>
#include <cstdio>
#include <cstdlib>
#include <vector>
#include <queue>
#include <cstring>
#include <stack>
#include <map>
#include <algorithm>
#include <cmath>
#include <fstream>
#if __cplusplus >= 201103L
#include <random>
#include <unordered_map>
#endif
using namespace std;

#define endl '\n'
#define fi first
#define se second
typedef long long ll;
typedef unsigned long long ull;
typedef pair<int, int> pii;
typedef pair<ll, ll> pll;

const int N = 1e5 + 10, INTMAX = 1e9+10;
struct edge
{
    int u, v, nxt;
    ll w;
} e[N << 1];
bool vis[N];
ll head[N], tot = 1, t;
inline void add(int u, int v, ll w)
{
    e[++tot].u = u;
    e[tot].v = v;
    e[tot].w = w;
    e[tot].nxt = head[u];
    head[u] = tot;
}
inline ll dfs(int u, ll minf)
{
    // cout<<u<<endl;
    if (u == t || minf == 0)
        return minf;
    vis[u] = 1;
    for (int i = head[u]; i; i = e[i].nxt)
    {
        ll v = e[i].v, &w = e[i].w;
        if (!vis[v] && w)
        {
            ll flw = dfs(v, min(minf, w));
            if (flw)
            {
                w -= flw;
                e[i ^ 1].w += flw;
                return flw;
            }
        }
    }
    return 0;
}

inline ll FF(int s)
{
    ll MXF = 0;
    while (1)
    {
        memset(vis, 0, sizeof(vis));
        ll flw = dfs(s, INTMAX);
        if (flw == 0)
            return MXF;
        MXF += flw;
    }
    return 0;
}

int main()
{
    ios::sync_with_stdio(0);
    cin.tie(0);
    cout.tie(0);
    int n, m, s;
    cin >> n >> m >> s >> t;
    while (m--)
    {
        int u, v, w;
        cin >> u >> v >> w;
        cout<<u<<" "<<v<<endl;
        add(u, v, w);
        add(v, u, 0);
    }
    cout << FF(s) << endl;
}
```

# Part 3. EK

刚才说到，FF 算法的复杂度是很高的。其原因就是因为进行搜索的时候，我们是盲目搜索的。于是我们想到了一些比较科学的搜索方式，比如说沿着最短路推进。（你可以在这里[这里](https://oi.wiki/graph/flow/max-flow#/:~:text=%E5%A2%9E%E5%B9%BF%E6%80%BB%E8%BD%AE%E6%95%B0%E7%9A%84%E4%B8%8A%E7%95%8C%E7%9A%84%E8%AF%81%E6%98%8E)找到证明）

没错，如果你在增广的时候不是瞎撞，而是每一次都找最短路（**注意：这里所说的最短路并不是所谓的最短路，他事实上表示的是 BFS 层次的最短路**），这个算法就能减少很多无用功。于是乎，时间来到了 $O(nm^2)$。

Code:
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
#include<random>
#include<unordered_map>
#endif
using namespace std;

#define endl '\n'
#define fi first
#define se second
typedef long long ll;
typedef unsigned long long ull;
typedef pair<int,int> pii;
typedef pair<ll,ll> pll;

const int N=1e5+10;
const ll MAXINT=0b111111111111111111111111111111111111111111111111111111111111111;
struct edge{
    int v,nxt;
    ll w;
}edge[N<<1];
ll head[N],flow[N],vis[N],pre[N],n,m,s,t,_=1;
void add(int u,int v,ll w){
    edge[++_].v=v;
    edge[_].w=w;
    edge[_].nxt=head[u];
    head[u]=_;
}

ll bfs(){
    memset(vis,0,sizeof(vis));
    memset(pre,0,sizeof(pre));
    queue<int>q;
    vis[s]=1;
    q.push(s);
    flow[s]=MAXINT;
    while(!q.empty()){
        int u=q.front();q.pop();
        for(int i=head[u];i;i=edge[i].nxt){
            ll v=edge[i].v,w=edge[i].w;
            if(w&&!vis[v]){
                flow[v]=min(flow[u],w);
                pre[v]=i;
                q.push(v);
                vis[v]=1;
                if(v==t)return flow[v];
            }
        }
    }
    return 0;
}

ll EK(){
    ll MXF=0,f;
    while(f=bfs()){
        int u=t;
        while(u!=s){
            int i=pre[u];
            edge[i].w-=f;
            edge[i^1].w+=f;
            u=edge[i^1].v;
        }
        MXF+=f;
    }
    return MXF;
}

int main(){
    cin>>n>>m>>s>>t;
    while(m--){
        int u,v,w;
        cin>>u>>v>>w;
        add(u,v,w);
        add(v,u,0);
    }
    cout<<EK()<<endl;
    return 0;
}
```

# Part 4. Dinic

刚才我们所说的所有算法都是一次增广一条路，但是我们很显然发现走法很智障：明明我们都流到这里了，你这里还有路，为啥不能换一条路，继续走呢？

用一个图解释一下：本来，按照我们的 EK 算法我们应该这么增广（暂时忽略 $v2$）：

![](https://s21.ax1x.com/2024/12/06/pA7FuKP.png)

这样我们一共走了 $3$ 遍。然而我们再仔细想想，第一趟结束以后，$v1$ 这个位置已经流走了 $2$，还剩 $3$，那么我们回去干啥？接着用剩下的 $3$ 流量用干净啊！也就是说一路扩展到这里：

![](https://s21.ax1x.com/2024/12/06/pA7Fmvt.png)

这样就再也不会出现刚才那样的智障问题了。在路上，我们依然按照 EK 的传统，按层次增广。

## 当前弧优化

我们发现，当从 $v1$ 往这边找的时候，已经走过了一次 $d1$ 和 $d2$ 节点，那么接下来如果我们再走到这里，$d1$ 和 $d2$ 的流量一定已经用尽（因为在这里我们依然用了多路增广，肯定是把所有能流的地方都流干净了），那么我们就又解决了一个智障问题，每次遍历的时候接着上次的往下遍历即可。具体看代码。

Code:
```cpp
#include <iostream>
#include <cstdio>
#include <cstdlib>
#include <vector>
#include <queue>
#include <cstring>
#include <stack>
#include <map>
#include <algorithm>
#include <cmath>
#include <fstream>
#if __cplusplus >= 201103L
#include <random>
#include <unordered_map>
#endif
using namespace std;

#define endl '\n'
#define fi first
#define se second
#define int long long
typedef long long ll;
typedef unsigned long long ull;
typedef pair<int, int> pii;
typedef pair<ll, ll> pll;

const int N = 2e5 + 10;
const ll MX = 0b111111111111111111111111111111111111111111111111111111111111111;
struct edge
{
    int v, nxt;
    ll w;
} e[N];
int head[N], cur[N], d[N], n, m, s, t, __________ = 1;
void add(int u, int v, int w)
{
    e[++__________].v = v;
    e[__________].w = w;
    e[__________].nxt = head[u];
    head[u] = __________;
}
bool bfs()
{
    memset(d, -1, sizeof(d));
    queue<int> q;
    q.push(s);
    d[s] = 0;
    while (!q.empty())
    {
        int u = q.front();
        q.pop();
        for (int i = head[u]; i; i = e[i].nxt)
        {
            int v = e[i].v, w = e[i].w;
            if (d[v] == -1 && w)
            {
                d[v] = d[u] + 1;
                q.push(v);
            }
        }
    }
    return d[t] != -1;
}

int dfs(int u, int minf)
{
    if (u == t || !minf)
        return minf;
    int f, flw = 0;
    for (int i = cur[u]; i; i = e[i].nxt)
    {
        cur[u] = i;
        int v = e[i].v, w = e[i].w;
        if (d[v] == d[u] + 1 && (f = dfs(v, min(minf, w))))
        {
            minf-=f;
            flw+=f;
            e[i].w-=f;
            e[i^1].w+=f;
            if(!minf)return flw;
        }
    }
    return flw;
}

ll dinic()
{
    int MXF=0;
    while(bfs()){
        for(int i=1;i<=n;i++)cur[i]=head[i];
        MXF+=dfs(s,MX);
    }
    return MXF;
}

signed main(){
    cin>>n>>m>>s>>t;
    while(m--){
        int u,v,w;
        cin>>u>>v>>w;
        add(u,v,w);
        add(v,u,0);
    }
    cout<<dinic()<<endl;
}

```

# Part 5,6,7,8,9,INF 正在学习