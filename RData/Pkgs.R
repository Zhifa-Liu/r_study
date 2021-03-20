# 包是R函数、数据、预编译代码以一种定义完善的格式组成的集合
# library()函数可以显示库中有哪些包
library()
# 包的安装
# install.packages()显示CRAN镜像站点列表，选择站点之后选择包下载并安装
install.packages("gclus") # 有引号
# 包的载入
# library()载入
library(gclus) # 无引号

# 其它
# 工作空间：当前R的工作环境，存储着所有用户定义的对象
# 当前的工作目录(working directory)是R用来读取文件和保存结果的默认目录
# 用于管理R工作空间的函数
getwd() # 显示当前的工作目录
setwd("D:/Code/R/")-修改当前工作目录
ls() # 列出当前工作空间的对象
rm(obj_list) # 移除当前工作空间的对象

