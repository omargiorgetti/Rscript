library(RJDBC)
drv <- JDBC("sun.jdbc.odbc.JdbcOdbcDriver")
conn<-dbConnect(drv,"jdbc:odbc:svileco_con","og15382","")



library(RJDBC)
drv <- JDBC(driverClass="com.ibm.db2.jcc.DB2Driver", classPath="c:/driver/db2/db2jcc.jar", identifier.quote=NA)
conn<-dbConnect(drv,"jdbc:db2://db2dwt1.regione.toscana.it:55000/SVILECO:currentSchema=dm_sdsr;","og15382","sOl1071O")
