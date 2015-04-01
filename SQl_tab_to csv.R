library(RJDBC)
drv <- JDBC(driverClass="com.ibm.db2.jcc.DB2Driver", classPath="C:/Programmi/SQuirreL SQL Client/lib/db2/db2jcc.jar", identifier.quote=NA)
conn<-dbConnect(drv,"jdbc:db2://db2ott1.regione.toscana.it:55200/SVILECO:currentSchema=ARTEAODS;",{utente},{password})

tmp<-dbGetQuery(conn,"{query sql}")

# salvataggio in csv
write.table(tmp,file="C:\\Documents and Settings\\userregtosc\\Documenti\\sistemi_direzionali\\artea\\sorgenti\\programmato\\programmato_enti20130111.csv",
            append = FALSE,
            quote = FALSE, sep = ";", row.names = FALSE,col.names = FALSE,
            eol = "\n", na = "NA", dec = ",",
            qmethod = c("escape", "double"))
