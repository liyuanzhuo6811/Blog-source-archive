---
title: 状压DP
date: 2024-08-15 17:29:10
tags:
---

# Part 0. 引子

考虑这样的问题：有一排灯泡（$n \leqslant 15$），每一个灯泡可以是开着或者关着的，每次有许多操作方式，每一种会把一部分灯泡变成开着的，一部分变成关着的，初始时灯泡全部开着，问进行多少次操作才能使得这些灯泡全部熄灭？

显然这是一个DP题。由于 $n<=15$，一个可行的方式是这样做：

```cpp
int dp[2][2][2][2][2][2][2][2][2][2][2][2][2][2][2];
```

不过这样你自己都数不过来。另外，你怎么进行枚举呢？显然这样不是一个优秀的答案。我们考虑~~小学一年级就学过的~~字符串哈希，其中有一种就叫做进制哈希。不知道也没关系，其实我们可以把这里的灯泡状态变成一个二进制数，比如这样：

$$(101101011101000)_2$$

就表示这样：

开，关，开，开，关，开，关，开，开，开，关，开，关，关，关

（当然，你也可以反过来写，都一样。）

这就是状压DP的思想，用一个二进制（当然也不绝对，也可以是三进制的，如果你觉得这个题比较适合用的话）的数来代表一种状态。这样，我们在进行各种操作的时候，就可以把这个状态变成一个类似于“状态编号”的样子，然后对这些编号进行转移。

# Part 1. 前置知识——位运算

前面已经提到，这种算法的核心就是二进制。那么，要想轻松处理二进制，必不可少的就是位运算了。

以下是一些常用的位运算：

- 把 `a` 的第 $k$ 位变成 $1$：`a|(1<<k)`
- 把 `a` 的第 $k$ 位变成 $0$：`a&(~(1<<k))`
- 把 `a` 的第 $k$ 位取反：`a^(1<<k)`
- `a` 的第一个 $1$：`a&(-a)`

这样，我们就可以愉快地编码，而不至于因为不知道该怎么运算而大伤脑筋了。

# Part 2. 常用套路

## 棋盘形

也就是说对于一个矩阵进行一定的操作，使之价值最大。通常这些问题的矩阵大小都非常小，以便于状态压缩编码（因为这样的题目一般没有多项式时间复杂度的做法）。

### [例题](https://vjudge.net/problem/HDU-1565)：

这个题目的意思就是在方格里面选数，要求没有相邻的格子。先考虑暴力，就是枚举每一种情况，然后判断有没有重复的格子。

显然超时。

那么怎么优化呢？对于这样的问题，显然可以使用DP。注意到：

> $n \le 20$

而 $2^{20} < 2000000$，我们可以考虑状态压缩。首先定义 DP 状态：`f[i][k]` 表示前 $i$ 行，其中第 $i$ 行的状态为 $k$ 的最大值。转移方程就自然而然地出来了：

$$f[i][k]=\max_{0 \le t \le 2^n}\{f[i-1][t]\}$$

如何判断情况是否合法呢？分别考虑。
1. 同一行的数是否合法。这种情况我们用 `t & (t>>1)` 来进行检查。如果有两个相邻的 $1$，那么经过位移以后就会有重合，那么最后的结果就会大于 $0$，反之亦然。
2. 行与行之间是否合法。直接检查 `t & k` 

这样就可以进行DP了。考虑一下时间复杂度：进行 $n$ 行操作，每一行要进行 $2^n$ 种情况，对于每种情况要检查前面同样是 $2^n$ 种情况，总复杂度为 $O(n \times 2^{n^2})$，超时。

这是暴力代码：
```cpp
#include<bits/stdc++.h>
#define cin std::cin
#define cout std::cout
#define endl '\n'
#define max std::max
#define check(x) ((x&(x>>1))==0)
int f[21][18000],a[21][21],s[18000];
int n,tot;
int calc(int x,int i){
    int j=n,ans=0;
    while(x){
        if(x&1)ans+=a[i][j];
        x>>=1;
        j--;
    }
    return ans;
}
int main(){
    std::ios::sync_with_stdio(0);
    cin.tie(0);
    cout.tie(0);
    while(cin>>n){
        memset(f,0,sizeof(f));
        for(int i=0;i<(1<<n);i++){
            if(check(i))s[++tot]=i;
        }
        for(int i=1;i<=n;i++){
            for(int j=1;j<=n;j++)cin>>a[i][j];
        }
        for(int i=1;i<=tot;i++){
            int r=s[i];
            f[1][r]=calc(r,1);
        }
        for(int i=2;i<=n;i++){
            for(int j=0;j<=tot;j++){
                int w=calc(s[j],i);
                for(int k=0;k<=tot;k++){
                    if((s[j]&s[k])==0){
                        f[i][s[j]]=max(f[i][s[j]],f[i-1][s[k]]+w);
                    }
                }
            }
        }
        int ans=0;
        for(int i=1;i<=tot;i++)ans=max(ans,f[n][s[i]]);
        cout<<ans<<endl;
    }
    return 0;
}
```

怎么解决这个问题呢？注意到每一次我们都要重复判断每一行里面的情况是否合法，然而这其实是重复工作，我们只需要预处理一次，把所有合法的情况都记录下来就好了。

这是 AC Code：

```cpp
#include<bits/stdc++.h>
#define int long long
#define cin std::cin
#define cout std::cout
#define endl '\n'
#define max std::max
#define check(x) ((x&(x>>1))==0)
int f[21][18000],a[21][21],s[18000];
int n,tot;
int calc(int x,int i){
    int j=n,ans=0;
    while(x){
        if(x&1)ans+=a[i][j];
        x>>=1;
        j--;
    }
    return ans;
}
signed main(){
    std::ios::sync_with_stdio(0);
    cin.tie(0);
    cout.tie(0);
    while(cin>>n){
        tot=0;
        memset(f,0,sizeof(f));
        for(int i=0;i<(1<<n);i++){
            if(check(i))s[++tot]=i;
        }
        for(int i=1;i<=n;i++){
            for(int j=1;j<=n;j++)cin>>a[i][j];
        }
        for(int i=1;i<=n;i++){
            for(int j=1;j<=tot;j++){
                int w=calc(s[j],i);
                for(int k=1;k<=tot;k++){
                    if((s[j]&s[k])==0){
                        f[i][j]=max(f[i][j],f[i-1][k]+w);
                    }
                }
            }
        }
        int ans=0;
        for(int i=1;i<=tot;i++)ans=max(ans,f[n][i]);
        cout<<ans<<endl;
    }
    return 0;
}
```

**最后提醒一句，这个题是多测。**

## 线性

这种题目的常见套路就是有一排 or 一列什么东西，然后每种状态可以进行一定的操作 or 可以从前面的状态转移，最终得到答案。

这种题一般可以和一些其他知识结合，详见例题。
### [例题（最短路）](https://www.luogu.com.cn/problem/P2622)：

这个题就是可以通过记录每一种状态，然后从能够转移到这个状态的状态到这个状态建一条单向边，最后我们就从编号为 $2^n-1$ 的状态开始跑最短路，最终得到答案。

这是 AC Code：
```cpp
#include<iostream>
#include<cstring>
#include<vector>
#include<queue>
using namespace std;
const int N=5e3;
vector<int>e[N];
int d[N];
bool vis[N][N];
void spfa(int s){
    queue<int>q;
    q.push(s);
    memset(d,0x3f,sizeof(d));
    d[s]=0;
    while(!q.empty()){
        int u=q.front();q.pop();
        for(int i=0;i<e[u].size();i++){
            int v=e[u][i];
            if(d[v]>d[u]+1){
                d[v]=d[u]+1;
                q.push(v);
            }
        }
    }
}
int main(){
    int n,m;
    cin>>n>>m;
    for(int i=1;i<=m;i++){
        int a[30];
        for(int j=1;j<=n;j++)cin>>a[j];
        for(int j=0;j<(1<<n);j++){
            int nw=j;
            for(int k=1;k<=n;k++){
                if(a[k]==-1)nw=nw|(1<<(k-1));
                if(a[k]==1)nw=nw&(~(1<<(k-1)));
                
            }
            if(!vis[j][nw]){
                vis[j][nw]=1;
                e[j].push_back(nw);
            }
        }
    }
    spfa((1<<n)-1);
    if(d[0]==0x3f3f3f3f)cout<<-1<<endl;
    else cout<<d[0]<<endl;
    return 0;
}
```

当然了，你用 Dijkstra 也完全没有问题。

### [例题（数学期望）](hhttps://atcoder.jp/contests/tdpc/tasks/tdpc_ball)：

这个题也很经典。

首先考虑只有一个瓶子的情况。在这个时候。我们显然可以直接冲着那个瓶子砸，狂砸 3 次就理论上可以干掉这个球。这个 3 就是只有一个球的期望。

再考虑多个球的情况。我们枚举在每一个位置扔球，则数学期望就是砸倒以后的三种情况的期望的平均值再加上 1。那如果没砸到怎么办？那这样就相当于是一个解方程了，我们只要分类讨论即可。

这是 AC Code：
```cpp
#include<iostream>
#include<algorithm>
#include<cstring>
#include<cstdio>
using namespace std;
const int N=20;
double f[1<<N];
int x[N];
int main(){
    int n,zt=0,mx=0;
    cin>>n;
    memset(f,0x42,sizeof(f));
    for(int i=1;i<=n;i++){
        cin>>x[i];
        zt+=1<<x[i];
        mx=max(mx,x[i]);
    }
    for(int i=0;i<=mx;i++)f[1<<i]=3;
    for(int i=1;i<(1<<(mx+1));i++){
        if(__builtin_popcount(i)==1)continue;
        // cout<<endl<<i<<endl;
        for(int k=1;k<=mx;k++){
            int dal=i&(~(1<<(k+1)));
            int dam=i&(~(1<<k));
            int dar=i&(~(1<<(k-1)));
            int cnt=0;
            bool l=0,m=0,r=0;
            if(dal==i)cnt++,l=1;
            if(dam==i)cnt++,m=1;
            if(dar==i)cnt++,r=1;
            if(cnt==3)continue;
            else{
                // cout<<k<<endl;
                // cout<<dal<<" "<<dam<<" "<<dar<<endl;
                if(cnt==1){
                    // cout<<111<<endl;
                    if(l)f[i]=min(f[i],(f[dam]+f[dar]+3)/2);
                    if(m)f[i]=min(f[i],(f[dal]+f[dar]+3)/2);
                    if(r)f[i]=min(f[i],(f[dam]+f[dal]+3)/2);
                }
                if(cnt==2){
                    if(l&&m)f[i]=min(f[i],f[dar]+3);
                    if(l&&r)f[i]=min(f[i],f[dam]+3);
                    if(r&&m)f[i]=min(f[i],f[dal]+3);
                }
                if(cnt==0)f[i]=min(f[i],(f[dal]+f[dar]+f[dam]+3)/3);
            }
        }
        // cout<<f[i]<<endl;
    }
    // cout<<zt<<endl;
    printf("%.15f",f[zt]);
}
```