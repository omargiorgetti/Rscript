#######################################################################
#parametri utili per configurazione oracle
#oracle.jdbc.driver.OracleDriver
#jdbc:oracle:thin:@dbsirthrtest-eng.regione.toscana.it:1521:ESEL
#######################################################################


#caricamento librerie rJava e RJDBC
library(rJava)
library(RJDBC)


#caricamento del driver oracle
drv <- JDBC(driverClass="oracle.jdbc.driver.OracleDriver", classPath="c:/drivers/oracle/ojdbc14.jar")


#connessione al db SIRT-HR
conn <- dbConnect(drv,"jdbc:oracle:thin:@dbsirthrtest-eng.regione.toscana.it:1521:ESEL","PAGHEL","PAGHEL")


#esempio di query sulla vista v_matricola_dip
rs <- dbSendQuery(conn, 
			"select *
			 from paghe.v_matricola_dip
			 where matricola=15046")


#assegnazione del risultato della query al dataframe df (il -1 serve a recuperare tutte le righe risultato della query;
#se si sinseriva ad es. 10 si recuperavano le prime 10 righe)
df <- fetch(rs, -1)


#visualizzazione della struttura del dataframe df 
#e successiva visualizzazione a video del risultato della query
str(df)
df



#altro esempio di query (vista v_ore_rese)
rs2 <- dbSendQuery (conn, 
				"select *
				 from paghe.v_ore_rese
				 where id_inq_indiv=14383
				 order by mese")

df2 <- fetch(rs2, -1)
str(df2)
df2



