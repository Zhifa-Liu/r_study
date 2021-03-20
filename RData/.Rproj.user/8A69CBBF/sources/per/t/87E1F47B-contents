# 数据的输入：
# 统计软件(SAS、SPSS、Stata)、键盘、文本文件、数据库管理系统(SQL、Mysql等)

patientID <- c(1, 2, 3, 4)
age <- c(25, 34, 28, 52)
diabetes <- c("Type1", "Type2", "Type1", "Type1")
status <- c("Poor", "Improved", "Excellent", "Poor")
patientdata <- data.frame(patientID, age, diabetes, status)

# 使用键盘输入数据
# edit()会自动调用一个允许手动输入数据的文本编辑器
patientdata <- edit(patientdata)
# 函数edit()事实上是在对象的一个副本上进行操作的（注意赋值），适用于小数据集

# CSV文件导入
read.table("flight14.csv",header=TRUE,sep=',')  # 默认字符型变量(列)将转换为因子
# Excel：转换为CSV
# XML数据：xmlTreeParse()和getNodeSet()
# SPSS数据：foreign包的read.spss()与Hmisc包的spss.get()
# 数据库管理系统
library(RODBC) # 使用微软ODBC接口
# odbcConnect()、sqlFetch()、sqlQuery()


# 处理数据对象的常用函数
obj=c(1,2,3)
length(obj) # 对象中元素、成分的数量
dim(patientdata) # 维度
class(obj) # 对象的类或类型
mode(obj) # 对象的模式
names(patientdata) # 对象中各成分的名称
c(obj1,obj2,...,objn) # 把对象合并入一个向量
cbind(obj1,obj2,...,objn) # 按列合并对象
rbind(obj1,obj2,...,objn) # 按行合并对象
obj # 输出对象
head(obj)
tail(obj)
ls() # 列出当前的对象列表
rm(obj1,obj2,...,objn) # 删除一个或更多个对象 rm(list=ls())
new_obj = edit(obj) # 编辑对象并另存为new_obj
fix(patientdata) # 直接编辑对象
edit(patientdata)
