---
title: Tarjan与图的连通性
date: 2024-08-03 17:07:25
tags: 
- 学习笔记
- 图论
---

# Part 0. 引子

Tarjan，是图的连通性的一类算法**们**。没错，这个算法如果你到洛谷上面查的话，会有5个模板题。他们分别是：点双连通分量，边双连通分量，缩点（强连通分量），割点，割边。

没错，就是这么多。他们的基本思路都一样，就是一个 `dfn` 和一个 `low`。如果让一个学过Tarjan的人评价一下这个算法的话，那就是四个字，又臭又长！

不过虽然他的代码很长也很难理解，但是他的作用是巨大的，很多图论相关的题目都可以用Tarjan进行化简，让他变成可做题。

# Part 1. DFN与LOW——Tarjan的核心思想

DFN是DFS序，也就是说，对于一棵树，我们在进行DFS的时候，DFN就是搜索到当前节点的时间戳。那么，在一个图中呢？

如果我们的图是存在环的，那么我们的一个显然思路就是一个 `vis` 数组标记是否已经到达过。虽然这样有些时候会发生问题，平时我们不这么干，但是对于 Tarjan，他是有用的。

请想象一下，我们对一个图（不管是有向还是无向），跑一遍 DFS，如果 `vis` 过了就跳过，否则 DFS这个点，这样最终会形成什么样的数据结构？树！没错，这个方式跑出来的树，叫做 DFS 生成树。这样，在树上就有四种边：

- 树边：作为 DFS 生成树的一条边
- 返祖边：不经过父亲，直接回到祖先的边
- 横叉边：不经过父亲，到达不在同一子树上的边（在无向图中并不存在，因为如果有这样的边，那么在两个端点中 `dfn` 较小的那个一定会DFS到他）
- 前向边：指向子树的边（在无向图中，这就是返祖边）
  
定义一个 `low` 数组，用于记录某一个节点**不经过父节点**能够到达的DFN最小的在同一棵子树上的节点。显然，这里只有返祖边是有用的，其他的边都不行。这里，定义一个节点是可以到达它本身的，也就是说， `low[i]` 最小就应该是 `dfn[i]`。

它有什么用呢？如果他能够不经过父节点而到达比父节点DFN更小的节点，就证明他爹没封死他的所有路，还是有一些小道可以通向世界的。（雾

大体就是这个意思。所以说，这个 `low`，就是Tarjan解决图的连通性问题的一个重要工具。

# Part 2. Tarjan 核心代码

Tarjan的核心代码就是 Tarjan 的递归部分。

下面是核心代码：

```cpp
void tarjan(int x){
    low[x]=dfn[x]=++tot;
    for(int i=0;i<e[x].size();i++){
        int v=e[x][i];
        if(!dfn[v])tarjan(v),low[x]=min(low[x],low[v]);
        else low[x]=min(low[x],dfn[v]);
    }
    if(dfn[x]<=low[x]){
        // 实力不详，遇强则强
    }
}
```

其中，第一部分为递归部分，也就是进行 DFS，第二部分是处理部分，把 DFS 到的内容进行处理。处理部分的位置并不确定，一些算法是在递归后立刻判断，另一部分是全部DFS完了以后再进行处理。

接下来，就是各种常用的算法了。

# Part 3. 割点

## 思路

首先，如果一个图能够互相连通，就称作这个图是连通图。如果一个图不是连通图，则其中每一个**极大的**连通子图（也就是说，没有节点与这个子图连通），就称作连通分量。

一个连通图就是一个连通分量。

如果去掉某一个节点，使得这个图的连通分量增加，也就是把原来的一个连通分量分割成了几部分，那么这个点就称为割点。

这里我们以无向图为例，有向图类似。

首先，我们构造一个 DFS 生成树。接下来，判断根节点是不是割点。很明显，只要他有两个以上的子树，那么他就是割点。

那么，对于子树中的节点，我们怎么判断呢？这个时候就要用到 `dfn` 与 `low` 了。只要某个点不是割点，他的子节点就必然会有一条返祖边可以不经过父亲，直接到达祖先。这是因为，删去他的父节点，这些节点依然可以连向他的祖先，连通性不受影响。

反过来也成立，只要有一个子节点的 `low` 小于等于当前节点的 `dfn` ，就证明这个节点不经过父亲没法到达其他子树以外的节点，也就证明删掉父亲他就与世隔绝了。

## 代码（模板题 [P3388](https://www.luogu.com.cn/problem/P3388)）

```cpp
#include<bits/stdc++.h>
using namespace std;
const int N=1e5+10;
vector<int>e[N];
int low[N],dfn[N];
int tot,s;
bool iscut[N];
void tarjan(int x){
    low[x]=dfn[x]=++tot;
    int cl=0;
    for(int i=0;i<e[x].size();i++){
        int v=e[x][i];
        if(!dfn[v]){
            cl++;
            tarjan(v);
            low[x]=min(low[x],low[v]);
            if(low[v]>=dfn[x]&&x!=s){
                iscut[x]=1;
            }
        }
        else low[x]=min(low[x],dfn[v]);
    }
    if(x==s&&cl>=2)iscut[s]=1;
}
int main(){
    int n,m;
    cin>>n>>m;
    for(int i=1;i<=m;i++){
        int u,v;
        cin>>u>>v;
        e[u].push_back(v);
        e[v].push_back(u);
    }
    for(int i=1;i<=n;i++){
        if(!dfn[i])s=i,tarjan(i);
    }
    int ans=0;
    for(int i=1;i<=n;i++){
        if(iscut[i])ans++;
    }
    cout<<ans<<endl;
    for(int i=1;i<=n;i++){
        if(iscut[i])cout<<i<<" ";
    }
    
}
```

# Part 4. 割边

## 思路

割边和割点几乎就是同一个东西，割边就是去掉一条边之后，连通分量增加。代码也完全相同，所以这里就不详细展示了。

# Part 5. 点双连通分量

## 定义

- 点双连通：没有割点，也就是说去掉任意一个点后图依然联通
- 点双连通分量：和连通分量类似，没有割点的极大子图

## 思路

还是 Tarjan。刚才我们是在求割点，那么我们这里思考，一个双连通分量和其他双连通分量必然是一个割点连接。同时，一个点本身是**双连通**的（这里注意，不是双连通分量）。

如果一个子图是一个点双连通分量，那么在 `dfn`，`low` 上会有什么样的表现呢？很显然，如果一个子图是双连通的，那么就有

$$low_i \le dfn_i$$

如果一个子图是点双连通分量呢？那么这里就能取等了。

这样我们就有了基本思路，那就是 DFS 以后用这两个数组判断他是不是点双的根节点。问题来了，怎么确定这个分量里面的其他节点呢？

这里就要用到我们的栈了。我们定义一个栈，用来表示当前搜索到并且还没有被划入连通分量的节点，那么我们每搜索到一个节点就入栈，先进行DFS，然后判断这个节点是不是有刚才的条件，如果是，那么就证明他就是一个点双，这样就把这些元素出栈，一直出栈到他自己为止。

思路清晰，代码吃人。就算学会了，也得勤加练习才行。

## 代码（模板题 [P8435](https://www.luogu.com.cn/problem/P8435)）

```cpp
#include<iostream>
#include<stack>
#include<vector>
using namespace std;
const int N=2e6+10;
stack<int>s;
vector<int>e[N];
vector<vector<int>>as;
bool ins[N];
int dfn[N],low[N];
int n,cnt=0;
void tarjan(int x,int fa){
    ins[x]=1;
    s.push(x);
    dfn[x]=low[x]=++cnt;
    if(!e[x].size()&&fa==0)as.push_back(vector<int>{x});
    for(int i=0;i<e[x].size();i++){
        int v=e[x][i];
        if(v==fa)continue;
        if(!dfn[v]){
            tarjan(v,x);
            low[x]=min(low[x],low[v]);
            if(dfn[x]<=low[v]){
                vector<int>ans;
                int t;
				do{
					t=s.top();
                    s.pop();
                    ans.push_back(t);
				}while(t!=v);
                ans.push_back(x);
                as.push_back(ans);
            }
        }
        else if(ins[v])low[x]=min(low[x],dfn[v]);
    }
    
}
int main(){
    int n,m;
    cin>>n>>m;
    while(m--){
        int u,v;
        cin>>u>>v;
        if(u==v)continue;
        e[u].push_back(v);
        e[v].push_back(u);
    }
    for(int i=1;i<=n;i++){
        if(!dfn[i])tarjan(i,0);
    }
    cout<<as.size()<<endl;
    for(int i=0;i<as.size();i++){
        cout<<as[i].size()<<" ";
        for(int j=0;j<as[i].size();j++)cout<<as[i][j]<<" ";
        cout<<endl;
    }
}
```

# Part 6. 边双连通分量

## 思路

和点双类似，只是把割点变成了割边。

在求点双的时候，我们是在遍历节点的时候寻找点双的。这是因为一个割点可能是多个点双的公共部分，因而不能直接在循环结束以后再进行检查。

但是边双的性质更好，每一条割边不会属于任何一个边双，也就意味着每一个连通分量不会有重合部分。证明很简单，如果割边在边双里面，那么删掉他就一定会导致连通分量增加，因此肯定不对。

那么我们就直接遍历所有节点，遍历完再检查是否有刚才的条件即可。

## 代码（模板题 [P8436](https://www.luogu.com.cn/problem/P8436)）
```cpp
#include<iostream>
#include<stack>
#include<vector>
using namespace std;
const int N=2e6+10;
stack<int>s;
vector<int>e[N];
vector<int>id[N];
vector<vector<int>>as;
bool ins[N];
int dfn[N],low[N];
int n,cnt=0;
void tarjan(int x,int fa,int idx){
    ins[x]=1;
    s.push(x);
    dfn[x]=low[x]=++cnt;
    for(int i=0;i<e[x].size();i++){
        int v=e[x][i];
        if(v==fa&&i==idx)continue;
        if(!dfn[v]){
            tarjan(v,x,id[x][i]);
            low[x]=min(low[x],low[v]);
        }
        else if(ins[v])low[x]=min(low[x],dfn[v]);
    }
    if(dfn[x]==low[x]){
        vector<int>ans;
        int t=s.top();
        do{
            t=s.top();
            ans.push_back(t);
            s.pop();
        }while(t!=x);
        as.push_back(ans);
    }
}
int main(){
    int n,m;
    cin>>n>>m;
    while(m--){
        int u,v;
        cin>>u>>v;
        if(u==v)continue;
        e[u].push_back(v);
        e[v].push_back(u);
        id[u].push_back(e[v].size()-1);
        id[v].push_back(e[u].size()-1);
    }
    for(int i=1;i<=n;i++){
        if(!dfn[i])tarjan(i,0,0);
    }
    cout<<as.size()<<endl;
    for(int i=0;i<as.size();i++){
        cout<<as[i].size()<<" ";
        for(int j=0;j<as[i].size();j++)cout<<as[i][j]<<" ";
        cout<<endl;
    }
}
```

注意，这道题是有坑的——这个图可能会有重边。我们思考一下，如果有重边，那么这些边的端点就形成了自环，那么这个子图本身就是一个边双连通子图（不一定是连通分量）。这里对于模板代码进行了一定程度的修改，详见[这篇帖子](https://www.luogu.com.cn/discuss/888539)。当然，用链式前向星会好判断一些，但是我~~抄~~翻遍了题解也没找到一个`vector`，这毕竟对于新手不太友好。

# Part 7. 有向图的强连通分量与缩点

## 定义

就是说，在有向图中任意两个点都能互相到达，就是强连通的。其余自行脑补，都一样。

## 思路

和边双类似，只要找到 `dfn[x]=low[x]` 的点就能找到强连通分量了。

注意，有向图的情况会复杂一些，四种边都有，所以在处理的时候牢记只关心树边（向下递归）和返祖边（更新`low`）即可，其他的边不需要处理，请自行证明其正确性。

在找到了所有强连通分量以后，我们可以进行缩点。缩点就是把每一个强连通分量看作一个点，这样整个图就变成了DAG图，然后就可以进行拓扑排序或者是方便地进行图上的DP了。

怎么进行缩点呢？我们只要记下每一个点所在的强连通分量的编号，最后遍历整个图，对于每一条边，我们把端点所对应的SCC连接起来，这样最后就能形成一个新的图，节点编号就是SCC的编号了。

## 代码（模板题 [P3387](https://www.luogu.com.cn/problem/P3387)）
```cpp
#include<bits/stdc++.h>
#define int long long
using namespace std;
const int N=1e5+10;
int low[N],dfn[N],tot=0,sc=0,scc[N],s[N],head=0,sz[N],n,m,f[N],a[N],p[N];
bool ins[N];
vector<int>e[N];
vector<int>G[N];
void tarjan(int x){
    low[x]=dfn[x]=++tot;
    s[++head]=x;
    ins[x]=1;
    for(int i=0;i<e[x].size();i++){
        int v=e[x][i];
        if(!dfn[v])tarjan(v),low[x]=min(low[x],low[v]);
        else if(ins[v])low[x]=min(low[x],dfn[v]);
    }
    if(dfn[x]<=low[x]){
        sc++;
        while(s[head]!=x){
            int v=s[head];
            sz[sc]+=a[v];
            scc[v]=sc;
            ins[v]=0;
            head--;
        }
        sz[sc]+=a[x];scc[x]=sc;
        ins[x]=0;head--;
    }
}
void top(){
    queue<int>q;
    for(int i=1;i<=sc;i++){
        if(p[i]==0)q.push(i),f[i]=sz[i];
    }
    while(!q.empty()){
        int u=q.front();q.pop();
        for(int i=0;i<G[u].size();i++){
            int v=G[u][i];
            f[v]=max(f[v],f[u]+sz[v]);
            p[v]--;
            if(p[v]==0)q.push(v);
        }
    }
}
signed main(){
    cin>>n>>m;
    for(int i=1;i<=n;i++)cin>>a[i];
    for(int i=1;i<=m;i++){
        int u,v;
        cin>>u>>v;
        if(u!=v)e[u].push_back(v);
    }
    for(int i=1;i<=n;i++){
        if(!dfn[i])tarjan(i);
    }
    for(int i=1;i<=n;i++){
        for(int j=0;j<e[i].size();j++){
            int v=e[i][j];
            if(scc[v]!=scc[i])G[scc[i]].push_back(scc[v]),p[scc[v]]++;
        }
    }
    int ans=0;
    top();
    for(int i=1;i<=n;i++)ans=max(ans,f[i]);
    cout<<ans<<endl;
}
```

# Part 8. 附注

## 代码部分
1. 部分代码参考了OI Wiki，另外有一部分是借鉴了题解。在此感谢所有提供代码者。
2. 很明显，这些代码非常难写。因此，建议在大考开始之前，着重复习一下这个模板，不然到了赛场上就很难调出来了。
3. 所有代码均在 C++14（GCC 9）环境下调试通过。

## 思路部分
1. 对于图的连通性问题，Tarjan是很通用且高效的算法，但是并不是唯一的算法，另外也有一些诸如差分算法的其他方式，不过主流还是Tarjan，有兴趣学习其他算法可以参考模板题题解或者OI Wiki。
2. 对于部分内容，本文未对其做出严谨证明。如果希望深刻理解Tarjan，建议对于一些未加以证明或者仅仅进行了粗略的证明的过程进行深入的思考。

