library(data.table)
dt <- fread("D:/Course/数据科学导论与R语言/R语言/melt_default.csv")
dt.m1 = melt(dt, id.vars=c("family_id", "age_mother"), measure.vars=c("dob_child1","dob_child2","dob_child3"))
# or just simply
dt.m1 = melt(dt, id.vars=c("family_id", "age_mother"))
dt.m1 = melt(dt, measure.vars=c("dob_child1","dob_child2","dob_child3"))
# 命名variable列和value列
dt.m1 = melt(dt, id.vars=c("family_id", "age_mother"), variable.name="child", value.name="dob")
# 还原
dcast(dt.m1, family_id+age_mother~child, value.var="dob")

### 如何对两组不同类型的属性分别melt成两列呢？(Previous way)
dt <- fread("D:/Course/数据科学导论与R语言/R语言/melt_enhanced.csv")
dt$dob_child1=as.character.Date(dt$dob_child1)
dt$dob_child2=as.character.Date(dt$dob_child2)
dt$dob_child3=as.character.Date(dt$dob_child3) # Date and other data type
dt.m1 = melt(dt, id.vars=c("family_id", "age_mother"), measure.vars=3:8)
dt.m1[, c("variable", "child"):=tstrsplit(variable, "_", fixed=TRUE)]
dt.c1 = dcast(dt.m1, family_id+age_mother+child~variable, value.var="value")
# 上述方法迂回、低效
# 需要被整合的列可能是不同的类型，使用函数melt的时候，这些列被硬塞到结果里面(非Data类型列数据丢失?)

### data.table对reshape2包的melt、dcast的增强
## 增强的melt
library(data.table)
dt <- fread("D:/Course/数据科学导论与R语言/R语言/melt_enhanced.csv")
cols1 = c("dob_child1", "dob_child2", "dob_child3")
cols2 = paste("gender_child", 1:3, sep="")
dt.m2 <- melt(dt, measure=list(cols1, cols2), value.name=c("dob", "gender"))
# patterns
dt.m2 = melt(dt, measure=patterns("^dob", "^gender"), value.name=c("dob", "gender")) # C实现，效率高、节省内存

## 增强的dcast
dt.c2 = dcast(dt.m2, family_id+age_mother~variable, value.var=c("dob","gender"))

