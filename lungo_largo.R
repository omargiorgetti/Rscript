##############################################################
# Passaggio da data.frame "lungo" a "largo" e viceversa      #
##############################################################


############## con stack / unstack

require(stats)
data(PlantGrowth)
str(PlantGrowth)
PlantGrowth		# Struttura lunga

pg <- unstack(PlantGrowth, form=weight~group) 

pg			# Struttura larga
str(pg)		

stack(pg)         # Torno alla struttura lunga


############### con reshape

df.lungo <- data.frame(id=rep(1:4,rep(2,4)),
                      visit=I(rep(c("Before","After"),4)),
                      x=rnorm(4), y=runif(4))
df.lungo
str(df.lungo)

df.largo<-reshape(df.lungo, timevar="visit", idvar="id",
                 direction="wide")
df.largo
str(df.largo)

reshape(df.largo, idvar="id", direction="long")





y<-data.frame(id=rep(1:4),num=c("a","b","c","d"),a2001=I(seq(10,40,by=10)),a2002=I(seq(100,400,by=100))
