# 统计图形是从数据到几何物体（点、线、条)的美学属性(颜色、形状、大小)的映射。

###### 从qplot入门
install.packages("ggplot2")
library(ggplot2)

qplot(carat, price, data = diamonds)
qplot(log(carat), log(price), data = diamonds)
qplot(carat, x * y * z, data = diamonds)
## 设定数据点颜色、形状
subdiamonds = diamonds[sample(nrow(diamonds),1000L),]
qplot(carat, price, data=subdiamonds, colour=color)
qplot(carat, price, data=subdiamonds, shape=cut)
## alpha：创建半透明的颜色
qplot(carat, price, data=diamonds, alpha=l(1/100))
qplot(carat, price, data=diamonds, alpha=l(1/500))

## 参数geom：
# point 散点图(default)、smooth 拟合的平滑曲线、boxplot 箱线图、path or line 数据点连续
# histogram 直方图、freqploy 频率多边形、density 密度曲线、bar 条形图、point 气泡图

# 平滑曲线图
qplot(carat, price, data=subdiamonds, geom=c("point", "smooth"))
qplot(carat, price, data=diamonds, geom=c("point", "smooth"))
# 扰动点图与箱线图
qplot(color, price/carat, data=diamonds, geom="jitter")
qplot(color, price/carat, data=subdiamonds, geom="boxplot")
# 直方图与密度曲线
qplot(carat, data=diamonds, geom="histogram") # 参数binwidth：设定组距
qplot(carat, data=diamonds, geom="density") # 参数adjust：控制曲线平滑程度
qplot(carat, data=diamonds, geom="histogram", binwidth=0.1, xlim=c(0,3)) # xlim：横坐标范围
qplot(carat, data=diamonds, geom="histogram", binwidth=0.05, xlim=c(0,3))
# 直方图与密度曲线-不同分组之间的对比：图形映射(aesthetic mapping)
qplot(carat, data=diamonds, geom="density", colour=color)
# weight：如果数据已经进行了汇总，或者想用其他方式对数据进行分组处理，则可以使用weight几何对象
qplot(color, data=diamonds, geom="bar")
qplot(color, data=diamonds, geom="bar", weight=carat)+scale_y_continuous("carat")
# 时间序列的线条图与路径图：常用语可视化时间序列数据
# 线条图：展示单个变量随时间变化的情况
# 路径图：展示两个变量随时间联动的情况，时间反映在点的顺序上
qplot(date, unemploy/pop, data=economics, geom="line") # 失业率
qplot(date, uempmed, data=economics, geom="line") # 失业时间长度
qplot(unemploy/pop, uempmed, data=economics, geom="path", colour=as.POSIXlt(date)+1900)

## 参数：facets ------ 分面(划分数据子集，然后创建一个图形矩阵)
# 针对color分面
qplot(carat, data=diamonds, facets=color~., geom="histogram", binwidth=0.1, xlim=c(0, 3))
# ..density..表示将密度而不是频数映射到y轴，使用密度可以使得比较不同组的分布时不会受该组样本量大小的影响
qplot(carat, ..density.., data=diamonds, facets=color~, geom="histogram", binwidth=0.1, xlim=c(0, 3))

## 其它选项
# xlim、ylim：设置x轴和y轴的显示区间
# log="x"表示对x轴取对数、log="xy"表示对x轴和y轴都取对数
# main
# xlab、ylab：坐标轴标签文字，字符串或数学表达式
qplot(carat, price, data=subdiamonds, xlab="Weight(unit:carat)", ylab="Price(unit:$)", main="Price-Weight")
qplot(carat, price/carat, data=subdiamonds, xlab="Weight(unit:carat)", ylab=expression(frac(price, carat)))
qplot(carat, price, data=subdiamonds, log="xy")

