### data.table介绍
# R语言data.table包是自带包data.frame的增强版本，用于数据框格式数据的处理
# data.table与data.frame的区别：
# 字符型的列，不会被自动转化成因子
# 行号后面有个冒号，用于隔开第一列的内容
# 不能设置行的名称

### 术语规定
# subset：指对行的选择
# select：指对列的选择

### 基础
library(data.table)

# dt[i,j,by]
# 同时接受三个参数，并在计算之前，选取最优的计算方法，而不是分步骤计算

## 创建data.table
dt = data.table(id=1:3,alpha=c('a','b','c'),beta=1:3)
class(dt$alpha) # class()用来查看对象类型
df = data.frame(id=1:3,alpha=c('a','b','c'),beta=1:3)
dt = as.data.table(df)

## 读取数据集与参数i、j
flights <- fread("D:/Course/数据科学导论与R语言/R语言/flights14.csv")
dim(flights)
# subset行：参数i
ans <- flights[origin=="JFK" & month==6L] # L:指明是整数
ans <- flights[1:2]
ans <- flights[order(origin,-dest)] # 排序
# select列：参数j
ans <- flights[,arr_delay] # arr_delay列
ans <- flights[,list(arr_delay)]
ans <- flights[,.(arr_delay)] # .()是list的别名
ans <- flights[,.(arr_delay,dep_delay)] # 可以给选择的列指定名字 .(arr=arr_delay)

ans <- flights[,c("arr_delay","dep_delay"),with=FALSE] # 像data.frame一样用列名引用
ans <- flights[,c("arr_delay","dep_delay")] # with参数可不写
ans <- flights[,!c("arr_delay","dep_delay"),with=FALSE] # 排除列，- or !

# j参数除了select列之外，还可以处理表达式，即针对列进行计算
ans <- flights[,sum(arr_delay+dep_delay<0)] # 起飞延误与到达延误时间小于0的航班数
ans <- flights[origin=="JFK" & month==6L,.(mean_arr=mean(arr_delay),mean_dep=mean(dep_delay))]

ans <- flights[origin=="JFK" & month=6L,length(dest)] # 满足i设定的条件的航班数
ans <- flights[origin=="JFK" & month=6L,.N] # .N 当前分组的对象的数目

## 分组聚合(原数据的顺序会反映在结果之中)

ans <- flights[,.(.N),by=.(origin)] # 每个机场起飞航班数
ans <- flights[,.N,by=origin] #
ans <- flights[carrier=="AA",.N,by=origin]  # AA：美航
ans <- flights[carrier=="AA",.N,by=.(origin,dest)]
ans <- flights[carrier=="AA",.(mean(arr_delay),mean(dep_delay)),by=.(origin,dest,month)]

# keyby参数(结果按照升序排列，排序在数据操作完成后进行)
ans <- flights[carrier=="AA",.(mean(arr_delay),mean(dep_delay)),keyby=.(origin,dest,month)]

# chaining表达式
ans <- flights[carrier=="AA",.N,by=.(origin,dest)][order(origin,-dest)]

# by表达式
ans <- flights[dep_delay>0 & arr_delay>0,.N]
ans <- flights[,.N,.(dep_delay>0,arr_delay>0)]

# .SD：包含通过by分组后的每一组
dt = data.table(ID=c("b","b","b","a","a","c"), A=1:6, B=7:12, C=13:18)
dt[,lapply(.SD, mean),by=ID] # lapply()返回列表

# .SDcols设置.SD包含的列
flights[carrier=="AA",lapply(.SD,mean),by=.(origin,dest,month),.SDcols=c("arr_delay","dep_delay")]

# 针对**每组**subset .SD
ans <- flights[,head(.SD,2),by=month]


### 语义引用：SemanticReference.R
### 主键、基于二分法搜索的subset：KeyAndSubset.R
### 二次索引和自动索引：Index.R
### 数据拆分和合并