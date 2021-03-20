### 基本图形

# 1.条形图(Bar plots)
install.packages("vcd")
library(vcd)
# table() 使用N个类别型变量(因子)创建一个N维列联表(频数表)
effect_counts <- table(Arthritis$Improved)
barplot(effect_counts,main="Title",xlab="Improvement",ylab="Frequency",col=c("red","yellow","green"),horiz=TRUE) # 水平条形
counts <- table(Arthritis$Improved,Arthritis$Treatment)
barplot(counts,xlab="Treatment",ylab="Frequency",col=c("red","yellow","green"),legend=(rownames(counts))) # 堆砌条形图
barplot(counts,xlab="Treatment",ylab="Frequency",col=c("red","yellow","green"),legend=(rownames(counts)),beside=TRUE) # 分组条形图
# 均值条形图
states = data.frame(state.region,state.x77)
means <- aggregate(states$Illiteracy,by=list(state.region),FUN=mean)
means <- means[order(means$x),]
barplot(means$x,names.arg=means$Group.1,main="Mean llliteracy Rate")

# 2.饼图(Pie charts)
slices <- c(1,2,3,4)
lbs <- c("A","B","C","D")
pie(slices,labels=lbs,main="Pie")
install.packages("plotrix")
library(plotrix)
pie3D(slices,labels=lbs,explode=0.1)

# 3.扇形图(Fan plot)
fan.plot(slices,labels=lbs)

# 4.直方图(Histograms)
hist(mtcars$mpg,breaks=6,col="lightblue",xlab="Miles Per Gallon",ylab="Frequency")

# 5.核密度图(Kernel density plots)
# 核密度估计是用于估计随机变量概率密度函数的一种非参数方法；
# 核密度估计不利用数据分布的先验知识，对数据分布不附加任何假定，是一种从数据样本本身出发研究数据分布特征的方法
plot(density(mtcars$mpg))
hist(mtcars$mpg,freq=FALSE,breaks=9,col="lightblue",xlab="Miles Per Gallon")
lines(density(mtcars$mpg),col="skyblue",lwd=2)

# 6.箱线图/盒状图(Box plots):important
# 使用并列箱线图进行跨组比较
# 为类别型变量cyl(气缸数)的每个值生成数值型变量mpg(每加仑行驶距离)的箱线图
boxplot(mpg~cyl,data=mtcars,main="Title",xlab="Number of Cylinders",ylab="Miles Per Gallon")

# 7.点图
dotchart(mtcars$mpg,labels=row.names(mtcars),cex=.7,main="Gas Mileage for Car Models")
x <- mtcars[order(mtcars$mpg),]
x$cyl <- factor(x$cyl)
x$color[x$cyl==4] <- "red"
x$color[x$cyl==6] <- "lightblue"
x$color[x$cyl==8] <- "green"
dotchart(x$mpg,labels=row.names(x),cex=.8,pch='o',groups=x$cyl,color=x$color,xlab="Miles Per Gallon")


### 中级绘图
# 1.散点图 important
attach(mtcars)
plot(wt,mpg)
abline(lm(mpg~wt),col="lightblue",lwd=2,lty=2)
# 1.1散点图矩阵
pairs(~mpg+disp+drat+wt,data=mtcars)
# install.packages("car")
library(car)
scatterplotMatrix(~mpg+disp+drat+wt,data=mtcars,spread=FALSE,smoother.args=list(lty=2))
# 1.2高密度散点图
set.seed(12)
n <- 10000
d_1 <- matrix(rnorm(n,mean=0,sd=.5),ncol=2)
d_2 <- matrix(rnorm(n,mean=3,sd=2),ncol=2)
d = rbind(d_1,d_2)
d <- as.data.frame(d)
names(d) <- c("x","y")
with(d,plot(d$x,d$y,pch=19))
# 1.3高密度散点图:smoothScatter()
with(d,smoothScatter(d$x,d$y))
# 1.4高密度散点图:hexbin()
# install.packages("hexbin")
library(hexbin)
with(d,{
  bin <- hexbin(d$x,d$y,xbins=100) # xbins x轴上的六边形数量
  plot(bin)
})
# 1.5高密度散点图:iplot()-pkg:IDPmisc;scatterplot3d()-pkg:scatterplot3d

# 2.气泡图
# 除三维散点图可以展示三个定量变量间的关系，还可以使用二维散点图，加上用电的大小来代表第三个变量的值
r <- sqrt(disp/pi) # disp 发动机排量
symbols(wt,mpg,circle=r,inches=.3,fg="white",bg="lightblue")
text(wt,mpg,rownames(mtcars),cex=0.5)
# 3.折线图
t = subset(Orange,Tree==1)
plot(t$age,t$circumference,type='o')
Orange$Tree <- as.numeric(Orange$Tree)
ntrees = max(Orange$Tree)
xrange = range(Orange$age)
yrange = range(Orange$circumference)
plot(xrange,yrange,type="n")
colors <- rainbow(ntrees)
linetype <- c(1:ntrees)
plotchar <- seq(18,18+ntrees,1)
for (i in 1:ntrees){
  tree <- subset(Orange,Tree==i)
  lines(tree$age,tree$circumferenc,type='o',lwd=1,lty=linetype[i],col=colors[i],pch=plotchar[i])
}
legend(xrange[1],yrange[2],1:ntrees,cex=1,col=colors,pch=plotchar,lty=linetype,title="Tree")

# 4.相关图(Correlograms)
install.packages("corrgram")
library(corrgram)
corrgram(mtcars,order=TRUE,lower.panel=panel.shade,upper.panel=panel.pie,text.panel=panel.txt)
# 下三角：
# 蓝斜杆：正相关；红斜杆：负相关；颜色深浅：相关性大小
# 上三角：
# 顺时针填充：正相关；逆时针填充：负相关；颜色深浅：相关性大小

# 5.马赛克图
# 马赛克图用于可视化两个以上的类别型变量
ftable(Titanic)
library(vcd)
mosaic(Titanic,shade=TRUE,legend=TRUE)