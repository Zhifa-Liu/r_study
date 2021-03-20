### qplot()的局限
# 只能使用一个数据集合一组图形属性映射，解决这个问题的办法就是使用图层

library(ggplot2)
### 创建绘图对象
# ggplot():参数1：数据；参数2：图形属性映射
p <- ggplot(diamonds, aes(carat, price, colour=cut))
print(p) # 图形对象在加上图层之前无法显示
### 图层
p <- p+layer(geom="point", stat="identity", position="identity") # "+"用来添加图层
print(p)
## 图层参数
# layer(geom, params, stat, data, mapping, position)
p <- ggplot(diamonds, aes(x=carat))+layer(geom="bar", params=list(fill="lightblue", binwidth=0.25), stat="bin", position="identity")
print(p)
### 快捷函数(shortcut)
## 形式：geom_XXX(mapping, data, ..., geom, position) or stat_XXX(mapping, data, ..., stat, position)
# mapping:图形属性映射,aes()
# data:修改默认数据集
# geom or stat:例如binwidth、fill
# position:选择一种调整对象重合的方式
p <- ggplot(diamonds, aes(x=carat))+geom_histogram(binwidth=0.25, fill="lightblue")
print(p)

### ggplot()和qplot()的等价性
qplot(sleep_rem/sleep_total, awake, data=msleep)
ggplot(msleep, aes(sleep_rem/sleep_total, awake))+geom_point()

qplot(sleep_rem/sleep_total, awake, data=msleep)+geom_smooth()
ggplot(msleep, aes(sleep_rem/sleep_total, awake))+geom_point()+geom_smooth()

### 图形对象
# 图形对象可以存储到变量
p <- ggplot(msleep, aes(sleep_rem/sleep_total, awake))
summary(p)
p <- p+geom_point()
summary(p)
p <- p+geom_smooth()
summary(p)

### 图层对象
# 图层对象可以存储到变量，且可用于不同数据
lay <- geom_smooth(method="lm", se=F, colour=alpha("steelblue",0.5), size=2)
qplot(sleep_rem, sleep_total, data=msleep)+lay
qplot(awake, brainwt, data=msleep, log="y")+lay
qplot(bodywt, brainwt, data=msleep, log="xy")+lay

### 图形属性映射
# 例：aes(x=weight, y=height, colour=age)---x坐标映射为weight\y坐标映射为height\颜色映射为age

### 图和图层
# 默认的图形属性映射可以在图形对象初始化时设定，或者之后用"+"修改
p <- ggplot(mtcars, aes(x=mpg, y=wt))
p+geom_point()
p+geom_point(aes(colour=factor(cyl))) # add
p+geom_point(aes(y=disp)) # override---aes(x=mpg,y=disp) (if remove,use aes(y=NULL))

### 分组
# 所有离散型变量的交互作用被设计为分组的默认值
# 如果没能正确分组或图中没 有离散型变量,就需要自定义分组结构
library(nlme)
Oxboys # 26名男孩(Subject)在9个不同的时期(Occasion)
qplot(age, height, data=Oxboys, group=Subject, geom="line")

## 不同图层上的不同分组
p <- ggplot(Oxboys, aes(age, height, group=Subject))+geom_line()
p+geom_smooth(aes(group=1), method="lm", size=2, se=F) # 根据所有男孩的年龄和身高在图中添加一条光滑线条

## 匹配图形属性和图形对象
# 如何将个体的图形属性映射给整体的图形属性？
# 对于个体几何对象这不是问题，因为每一条观测都被一个单一的图形元素所表示;但高密度的数据会使得区别单个点变得困难或不可能.

# 线条和路径遵循差一原则 
df <- data.frame(x=1:3, y=1:3, colour=c(1,3,5))
qplot(x, y, data=df, colour=factor(colour), size=I(5))+geom_line(aes(group=1), size=2)
qplot(x, y, data=df, colour=colour, size=I(5))+geom_line(size=2) # 尽管颜色是连续的,但默认条件下,R不会对相邻颜色进行插补

xgrid <- with(df, seq(min(x), max(x), length=50))
interp <- data.frame(
    x = xgrid,
    y = approx(df$x, df$y, xout=xgrid)$y,
    colour = approx(df$x, df$colour, xout=xgrid)$y
    )
qplot(x, y, data=df, colour=colour, size=I(5))+geom_line(data=interp, size=2) # 对于连续型变量，如果希望线段平稳地从一种图形属性变换到另一种图形属性，可以使用线性插值法

### 几何对象(geom)
# 几何图形对象负责图层的渲染和图的类型
# 每个几何对象(point\line\...)都有一组它能识别的图形属性和一组绘图所需的值
# 每个几何对象都有一个默认的统计变换，并且每衣蛾统计变换都有一个默认的几何对象
# 7.3 29-30

### 统计变换(stat)
# 统计变换通常以某种方式对数据信息进行汇总
# 为了阐明在图形的意义,一个统计变换必须是一个位置尺度不变量,即f(x+a)=f(x)+a且f(b·x) =b· f(x)
# 这样才能保证当改变图形的标度时，数据变换保持不变
# 7.3 33

### 位置调整(position)
# 位置调整是对该层中的元素进行微调；
# 位置调整一般多见于处理离散型数据，连续型数据一般很少出现完全重叠的问题(并且出现问题用位置调整也解决不了)
# 五种位置调整参数：
# dodge\fill\identity\jitter\stack
p <- ggplot(diamonds, aes(clarity, fill=cut))
p+geom_bar(position="dodge")
p+geom_bar(position="fill")
p+geom_bar(position="stack")

### 生成变量
# 统计变换能将图形属性映射成新变量
# 例：
# 用于绘制直方图的stat_bin统计变换会生成以下新变量：count\density\x(组的中心位置)
ggplot(diamonds, aes(carat)) + geom_histogram(aes(y=..density..), binwidth=0.1)
# 注：生成变量的名字必须要用..围起来,以防止混淆原数据集中的变量和生成变量

