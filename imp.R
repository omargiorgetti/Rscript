library(reshape);

monits<-read.csv2("C:/Documents and Settings/userregtosc/Documenti/R/prova_sched/sorgente.csv", 
  sep = ";", dec=",")


monit<-melt(monits,1:3)
print('fine')
write.table(monit,file="C:/Documents and Settings/userregtosc/Documenti/R/prova_sched/prova.csv",
            append = FALSE, 
            quote = FALSE, sep = ";", row.names = FALSE,col.names = FALSE,
            eol = "\n", na = "NA", dec = ".", 
            qmethod = c("escape", "double"))
	
	





















