### 描述性统计分析
# mean()\median()\var()\sd()\range()\sum()\min()\max(): 例略

# summary(): 最值、四分位数、均值等
mt <- mtcars[c("mpg","hp","wt")]
summary(mt)
# sapply()
mystats <- function(x,na.omit=FALSE){
    if(na.omit)
        x <- x[!is.na(x)] # 忽略缺失值
    c <- length(x)
    m <- mean(x)
    std <- sd(x)
    skew <- sum((x-m)^3/std^3)/c
    return(c(counts=c,mean=m,std=std,skew=skew))
}
sapply(mt,mystats)
sapply(mt,mystats,na.omit=TRUE)
# aggregate(): 仅允许使用单值放回函数，无法一次返回若干个统计量
aggregate(mtcars[c("mpg","hp","wt","am")],by=list(am=mtcars$am),mean)
# by(): 允许使用多返回值函数
dstats <- function(x){sapply(x,mystats)}
by(mtcars[c("mpg","hp","wt","am")],mtcars$am,dstats)

### 频数表 & 列联表
# 介绍
# 频数表：数据集按某个特定列分组时各组数据的数据对象个数的表
# 列联表：也是频数表，不过数据集是按两个及以上类别变量联合分组时各分组中数据对象个数的表

# 生成一维频数表
library(vcd)
mytable <- with(Arthritis,table(Improved))
prop.table(mytable) # 转化为比例值

# 创建二维列联表
mytable <- table(Arthritis$Treatment,Arthritis$Improved)
mytable <- xtabs(~Treatment+Improved,data=Arthritis)
margin.table(mytable,1) # 行和
margin.table(mytable,2) # 列和
prop.table(mytable) # 单元格比例
prop.table(mytable,1) # 行比例
prop.table(mytable,2) # 列比例
addmargins(mytable) # 添加行和与列和到表
addmargins(prop.table(mytable))
addmargins(prop.table(mytable,1),2)
addmargins(prop.table(mytable,2),1)

# 创建二维列联表：CrossTable()
install.packages("gmodels")
library(gmodels)
CrossTable(Arthritis$Treatment,Arthritis$Improved)

# 多维列联表
mytable <- xtabs(~Treatment+Sex+Improved,data=Arthritis)
ftable(mytable) # 输出列联表(紧凑形式)
margin.table(mytable,1)
margin.table(mytable,2)
margin.table(mytable,3)
margin.table(mytable,c(1,3))
margin.table(mytable,c(1,2))
ftable(prop.table(mytable,c(1,2)))
ftable(addmargins(prop.table(mytable,c(1,2)),3))

# 列联表的用处：独立性检验

### 参数估计：点估计与区间估计（详见《见概率论与数理统计教材》）

### 假设检验：
# 总体分布已知(参数检验)：对于正态总体，若标准差已知，Z检验；若标准差未知，t检验
# 总体分布未知(非参数检验)：卡方检验（详见《概率论与数理统计》）

### 独立性检验
# 卡方独立性检验
# 原假设：假设两属性之间相互独立
mytable <- xtabs(~Sex+Improved,data=Arthritis)
chisq.test(mytable) # 警告原因：不满足卡方检验的假设之一
mytable <- xtabs(~Treatment+Improved,data=Arthritis)
chisq.test(mytable)

# Fisher精确检验
# 原假设：边界固定的列联表的航和列是相互独立的
fisher.test(mytable)

# CMH(Cochran-Mantel-Haenszel)检验
# 原假设：两个名义变量在第三个变量的每一层中都是条件独立的
mytable <- xtabs(~Treatment+Improved+Sex,data=Arthritis)
mantelhaen.test(mytable)

### 相关性度量及相关性的显著性检验

mytable <- xtabs(~Treatment+Improved,data=Arthritis)
assocstats(mytable)

states <- state.x77[,1:6]

# 协方差
cov(states)

# 常见相关系数及计算：
# Pearson相关系数
cor(states)
cor(states[,c(1,2,3,6)],states[,c(4,5)]) # 非方形相关矩阵
# Spearman相关系数
cor(states,method="spearman")
# Kendall相关系数
cor(states,method="kendall")
# 偏相关系数
# 偏相关是指在控制一个或多个定量变量(要排除影响的定量变量)时，另外两个定量变量之间的相互关系
install.packages("ggm")
library(ggm)
pcor(c(1,5,2,3,6),cov(states)) # 第一个参数的前两个数值表示要计算相关系数的变量的下标
# 多分格(polychoric)相关系数：略
# 多系列(polyserial)相关系数：略

# 相关性的显著性检验
# 常用原假设：变量之间不相关(相关系数为0)
# 检验：cor.test(x,y,alter=,method=) alter->two.side\less\greater method->pearson\spearman\kendall
cor.test(states[,3],states[,5]) # 文盲率与谋杀率是否相关
# cot.test每次只能检验一种相关关系，而corr.test则不同
install.packages("psych")
library(psych)
corr.test(states,use="complete") # complete 对缺失值执行行删除

### t检验
# 原假设：两组均值是否相同
# t.test(y~x,data):x为二分变量，y为数值型变量 or t.test(x,y):x、y均为数值型变量
library(MASS)
t.test(Prob~So,data=UScrime)

### 方差分析

# 介绍
#     方差分析就是根据所采集的实验数据或生产数据，分析各有关因素对试验和生产
# 结果影响情况的统计分析方法。在对试验和生产数据的分析中，将所考虑的指标称为
# 试验指标，影响指标的条件称为因素(因素可分为可控因素和不可控因素，不可控因素
# 一般为随机因素)。因素所处的状态称为因素的水平，每个水平下得到的样本数据称为
# 观测值。方差分析主要用于分类型自变量和数值型变量之间的关系。

# 方差分析的类型
# 单因素方差分析 & 双因素方差分析

# 方差分析的基本假定
# 在方差分析中，总假设各个总体之间相互独立，且服从有相同方差的正态分布


# SST\SSE\SSA
# 总离差平方和：SST，全体样本对总平均值的离差平方和
# 组内方差(误差平方和)：SSE，反映各个样本观测值对本组组均值的分散程度，反映了各个总体均值之间的差异

# 详见《概率论与数理统计》

# aov(formula,data=df):方差分析模型拟合

# 单因素方差分析
# 原假设：各个总体的均值是否相等、是否具有显著性差异
library(multcomp)
attach(cholesterol)
fit <- aov(response ~ trt)
summary(fit) # 方差分析表：Df-自由度(4=5-1 45=50-5)
library(gplots)
plotmeans(response ~ trt,xlab="Treatment",ylab="Response",main="不同疗法胆固醇降低的均值\n(含95%的置信区间)")
detach(cholesterol)

# 多重比较

# F检验表明物种药物疗法效果不同，但是并没有指出哪种疗法与其它疗法不同，故采用多重比较
# TukeyHSD()：提供了对各组均值差异的成对检验
TukeyHSD(fit) # 2times-1time均值差异不如4times-1time显著
par(las=2) # 旋转轴标签
par(mar=c(5,10,5,5)) # 调整外边距
plot(TukeyHSD(fit))

# 双因素方差分析
attach(ToothGrowth)
table(supp,dose) # 喂食方法 抗坏血酸含量；列联表结果表明实验涉及是均衡设计
fit <- aov(len ~ supp*dose)
summary(fit) # 方差分析表结果表明主效应(supp、dose)和交互效应都非常显著
# interaction.plot()：可用于展示双因素方差分析的交互效应
interaction.plot(dose,supp,len,type="b",col=c("red","blue"),pch=c(16,18))
# or
plotmeans(len ~ interaction(supp,dose,sep=" "),connect = list(c(1,3,5),c(2,4,6)),col=c("red","blue"))
# or
install.packages("HH")
library(HH)
interaction2wt(len ~ supp*dose) # 能够展示任意复杂度设计的主效应和交互效应


### 组间差异的非参数检验
# 两组的比较
# wilcox.test(y~x,data):x为二分变量，y为数值变量 or wilcox.test(x,y):x、y为各组数据的结果变量
library(MASS)
wilcox.test(Prob~So,data=UScrime) #原假设：南方与非南方的监禁概率相同 Prob-监禁概率、So-“南方”标记 

# 多于两组的比较
# 各组独立：kruskal.test(y~A,data)
states <- data.frame(state.region,state.x77)
kruskal.test(Illiteracy,state.region,data=states)
# 各组不独立：friedman.test(y~A|B,data)

