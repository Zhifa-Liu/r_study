###### 主键、基于二分法搜索的subset
library(data.table)
flights <- fread("D:/Course/数据科学导论与R语言/R语言/flights14.csv")

### 主键
## Intro
# data.frame行名(独一无二且每行有且只有一个)
df = data.frame(ID = c("b","b","b","a","a","c"), A = 1:6, B = 7:12, C=13:18)
# data.frame --> data.table：行名被重置(data.table不使用行名)
dt = data.table(df)

## data.table使用主键
# 设置主键(单列)
# 1：setkey()
setkey(flights,origin) # Step1:根据指定列排序；Step2:设置sorted属性以标记主键列
#:2：setkeyv():设置多个列作为主键(注：主键最多只能有一个)
# 3：data.table()的key参数设置主键
# 注：在data.table里，所有的以set开头函数和操作符":="一样，都会更新输入的原数据

# 获取主键
key(flights) # 返回主键列名的字符型向量 or NULL

# 使用主键
flights[.("LGA")] # subset所有origin是"LGA"的行
flights[c("JFK","LGA")] # subset所有origin是"LGA"或"JFK"的行

# 设置主键(多列)
# setkey(flights,origin,dest) or
setkeyv(flights,c("origin","dest")) # 先按origin列排序，再按dest列排序
flights[.("JFK","MIA")] # subset所有origin是"JFK"、dest是"MIA"的行
flights[.(unique(origin),"MIA")] # subset所有dest"MIA"的行

# 主键、j、by
# flights[.("LGA", "TPA"), "arr_delay", with=FALSE] or
flights[.("LGA","TPA"),.(arr_delay)]
flights[.("LGA","TPA"),.(arr_delay)][order(- arr_delay)]
flights[.("LGA","TPA"),max(arr_delay)]

setkey(flights,hour)
key(flights) # output:[1] "hour"
flights[.(24),hour:=0L]
key(flights) # output:NULL (因替换主键列的值而被去除)

setkey(flights, origin, dest)
ans = flights["JFK",max(dep_delay),keyby=month]
key(ans) # keyby自动将month设置为结果的主键

### 参数mult和nomatch
# mult：all、first、last
flights[.("JFK","MIA"),mult="first"]
flights[.(c("LGA","JFK","EWR"),"XNA"),mult="last"] # 获取符合origin="LGA"或"JFK或"EWR"且dest="XNA"的数据的最后一行
# nomatch：指定在没有找到符合条件的数据的情况下，是返回NA还是跳过(不返回)
flights[.(c("LGA","JFK","EWR"),"XNA"),mult="last",nomatch=0L]

### 二分搜索 VS 向量扫描
# 创建样本数据
set.seed(2L)
N=2e7L
dt = data.table(x=sample(letters,N,TRUE),y=sample(1000L,N,TRUE),val=runif(N),key=c("x","y"))
print(object.size(dt),units="Mb")
# 使用向量扫描方法
system.time(dt[x=="f" & y==877L])
# 使用主键：二分搜索
system.time(dt[x=="f" & y==877L])

## 使用主键subset快的原因
# 向量扫描：搜索x、y列分别得到逻辑向量，然后& O(n)
# 二分搜索：data.table根据主键列进行了排序而不需要扫描整个数据，二分搜索 O(log n)

