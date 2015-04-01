#caricamento librerie rJava e RJDBC
library(rJava)
library(RJDBC)

#caricamento del driver db2
drv <- JDBC(driverClass="com.ibm.db2.jcc.DB2Driver", classPath="c:/drivers/db2/db2jcc.jar", identifier.quote=NA)


#connessione allo schema DMPERSECO tramite il driver precedentem assegnato alla variabile drv
conn<-dbConnect(drv,"jdbc:db2://db2dwp1.regione.toscana.it:50000/OSI:currentSchema=DMPERSECO;","mm15046","M000000i")

#esempio di query sulla tabella dipend_mail
rs <- dbSendQuery(conn, 
			"select *
			 from dipend_mail
			 where matricola=15046")

#assegnazione del risultato della query (set object) al dataframe df
df <- fetch(rs, -1)

#visualizzazione della struttura del dataframe df 
#e successiva visualizzazione a video del risultato della query
str(df)
df


#altro esempio: query su tabella f_inquadramento_dip
inq <- dbSendQuery(conn, 
				"select *	
				 from f_inquadramento_dip
				 where matricola=15046
				 and data_rif>'20100101'")

D_inq <- fetch(inq, -1)
str(D_inq)
D_inq



#esempio di query sulla tabella dipend_mail ma con dbGetQuery
rs2 <- dbGetQuery(conn, 
			"select *
			 from dipend_mail
			 where matricola=15046")

#visualizzazione della struttura del dataframe rs2 
#e successiva visualizzazione a video del risultato della query
str(rs2)
rs2


