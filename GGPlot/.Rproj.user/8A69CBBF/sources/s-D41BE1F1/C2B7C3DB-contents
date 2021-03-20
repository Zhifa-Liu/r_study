library(ggplot2)
mpgsub <- subset(mpg,cyl!=5 & drv %in% c("4","f"))
# 网格分面
ggplot(data=mpgsub,aes(cty,hwy))+geom_point()+facet_grid(.~cyl) # 一行多列
qplot(cty,hwy,data=mpgsub)+facet_grid(drv~cyl) # 多行多列
# 封装分面
# facet_wrap(.~.,nrow,ncol)

# 