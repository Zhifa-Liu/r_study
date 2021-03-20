### 图层类型
## 用于展示数据本身(data)
# 辨识数据的整体结构、局部结构、离群点
## 用于展示数据的统计摘要
# 用于展示模型的预测效果、绘制在数据层之上
## 用于添加额外的元数据(metadata)、上下文信息和注解
# 元数据层展示背景上下文，以帮助理解原始数据；元数据可用来强调数据的重要特征(例，离群点加上解释性标签)

### 基本图形类型
df <- data.frame(x=c(3, 1, 5), y=c(2,4,6), label=c("a", "b", "c"))
p <- ggplot(df, aes(x, y, label=label))+xlab(NULL)+ylab(NULL)
p+geom_point()+labs(title="geom_point")
p+geom_bar(stat="identity")+labs(title="geom_bar")
p+geom_line()+labs(title="geom_line") # 线条图
p+geom_area()+labs(title="geom_area") # 面积图
p+geom_path()+labs(title="geom_path") # 路径图
p+geom_text()+labs(title="geom_text") # 带标签的散点图
p+geom_tile()+labs(title="geom_tile") # 色深图
p+geom_polygon()+labs(title="geom_polygon") # 多边形图

### 展示数据分布
# 直方图
qplot(depth, data=diamonds, geom="histogram")
qplot(depth, data=diamonds, geom="histogram", xlim=c(55, 70), binwidth=0.1)
# 分布的跨组比较
depth_dist <- ggplot(diamonds, aes(depth))+xlim(58, 68)
depth_dist+geom_histogram(aes(y=..density..), binwidth=0.1)+facet_grid(cut~.)
depth_dist+geom_histogram(aes(fill=cut), binwidth=0.1, position="fill")
depth_dist+geom_freqpoly(aes(y=..density.., colour=cut), binwidth=0.1)

### 几何对象(geom)和统计变换(stat)
qplot(cut, depth, data=diamonds, geom="boxplot")
library(plyr)
qplot(carat, depth, data=diamonds, geom="boxplot", group = round_any(carat, 0.1, floor), xlim=c(0, 3))

### 遮盖绘制问题
df <- data.frame(x = rnorm(2000), y = rnorm(2000))
norm <- ggplot(df, aes(x, y))
norm + geom_point()

### 统计摘要
