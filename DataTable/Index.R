###### 二次索引和自动索引
library(data.table)
flights <- fread("D:/Course/数据科学导论与R语言/R语言/flights14.csv")

### 二次(二级)索引
## 二级索引与data.table主键的区别
# 不在内存对data.table排序，而是计算某列顺序并将其保存在属性index
# 一个data.table可以有多个二级索引
## 使用二级索引的原因
# 对一个data.table重新排序成本太高(计算排序向量->排序)
# 除非需要对某一列重复地进行subset，否则二分法快速subset的高效性可能被重新排序抵消
# 为添加／更新列而对整个data.table重新排序并不理想

# 设置二级索引
setindex(flights,origin) # setindexv()

# 获取二级索引
indices(flights)
setindex(flights,dest)
indices(flights) # 返回data.table所有的二级索引

# 删除二级索引
setindex(flights,NULL)

## 使用参数on和索引快速subset
# 参数on：能自动创建并重用二级索引
flights["JFK",on="origin"] # .("JFK")\list("JFK")
flights[.("JFK","LAX"),on=c("origin","dest")] # 选取所有从"JFK"起飞到达"LAX"的所有航班
# 因为计算索引非常快，所以我们不需要使用setindex();除非需要对某一列重复地subset

flights[.("LGA", "TPA"), .(arr_delay), on = c("origin", "dest")]
flights[.("LGA", "TPA"), .(arr_delay), on = c("origin", "dest")][order(-arr_delay)]
flights[.("LGA", "TPA"), max(arr_delay), on = c("origin", "dest")]

flights[.(24L), hour := 0L, on = "hour"]

flights["JFK", max(dep_delay), keyby = month, on = "origin"]

# 参数mult
flights[c("BOS","DAY"), on = "dest", mult = "first"]
flights[.(c("LGA", "JFK", "EWR"), "XNA"), on = c("origin", "dest"), mult = "last"]
# 参数nomatch
flights[.(c("LGA", "JFK", "EWR"), "XNA"), mult = "last", on = c("origin", "dest"), nomatch = 0L]

### 自动索引
# 自动索引能自动创建二级索引:第一次对某一列使用 == 或者 %in% 的时候，会自动创建一个二级索引
# 注：自动索引只支持操作符 == 和 %in% ，且只对一列起作用
# 注：当某一列被自动创建为二级索引，会作为data.table的属性保存起来；这跟参数on不同，参数on会每次创建一个临时索引。

# 创建数据集
set.seed(1L)
dt = data.table(x=sample(1e5L,1e7L,TRUE),y=runif(100L))
print(object.size(dt),units="Mb")

system.time(dt[x == 989L]) # 第一次运行，自动创建索引
system.time(dt[x == 989L]) # 第二次，利用索引"x"来subset，速度加快

# 可以通过设置全局参数关闭自动索引
options(datatable.auto.index = FALSE)
dt = data.table(x=sample(1e5L,1e7L,TRUE),y=runif(100L))
system.time(dt[x == 989L]) # 1
system.time(dt[x == 989L]) # 2

