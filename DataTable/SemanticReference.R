###### Semantics Reference

### Read Data
library(data.table)
flights <- fread("D:/Course/数据科学导论与R语言/R语言/flights14.csv")

### Intro
# 背景(not important)
# 影子拷贝(指针，不是真被复制)与深度拷贝(真的被复制)
df = data.frame(ID = c("b","b","b","a","a","c"), A = 1:6, B = 7:12, C=13:18)
df$C <- 18:13 # (1) -- replace entire column
df$C[df$ID=="b"] <- 15:13 # (2) -- subassign in column 'C'
# V3.1版本之前，(1)(2)操作均会导致整个df的深度拷贝
# V3.1版本之后，仅(2)操作会导致整个df的深度拷贝
# ?

# ":=" ----> 调高效率、避免冗余

### 操作符 ":="
# data.table的语义引用允许通过引用(reference)来add/update/delete列
## 左右等式形式
# DT[, c("colA", "colB", ...) := list(valA, valB, ...)]
# DT[, colA := valA] #只有一列时
## 函数形式
# DT[, `:=`(colA = valA, # valA is assigned to colA 
#           colB = valB, # valB is assigned to colB 
#           ... )
#   ]


# 添加列
flights[,c("speed"):=list(distance/(air_time/60))] # 添加speed列
flights[,`:=`(total_delay=arr_delay+dep_delay)] # 添加total_delay列
# 更新列
flights[,sort(unique(hour))] # 获取hour列所有可能值并排序
flights[hour==24L,hour:=0L][] # 24点均替换为0点，其中"[]"用来查看运行结果 
# 删除列
flights[,c("total_delay"):=NULL] # 删除一列时，可去掉c("")
flights[,`:=`(speed=NULL)]

flights[,c("speed","total_delay"):=list(distance/(air_time/60),arr_delay+dep_delay)]
# ":="与分组
flights[, max_speed := max(speed), by=.(origin, dest)]
# ":="与复数列
flights[,c("max_dep_delay","max_arr_delay"):=lapply(.SD,max),by=month,.SDcols=c("dep_delay","arr_delay")]

flights[, c("speed", "total_delay", "max_speed", "max_dep_delay", "max_arr_delay"):=NULL] # 恢复原数据
# ":="的副作用
foo <- function(dt){ # 用于返回每个月的最快速度
    dt[,speed:=distance/(air_time/60)]
    dt[,.(max_speed=max(speed)),by=month]
}
ans = foo(flights) # flights增加了speed列
# ":="与copy()
flights[,speed:=NULL]
foo <- function(dt){
    dt <- copy(dt)
    dt[,speed:=distance/(air_time/60)]
    dt[,.(max_speed=max(speed)),by=month]
}
ans = foo(flights) # copy()深度拷贝：flights未增加了speed列
