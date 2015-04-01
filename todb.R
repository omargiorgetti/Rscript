library(RJDBC)

# L'utilizzo del driver JDBC, come in qualsiasi altra applicazione, prevedere di disporre del relativo 
# file jar per la connessione al quel particolare tipo di database. Nel caso di db2 è necessario disporre
# del file db2jcc.jar e del percorso dove questo file è salvato. Inoltre è necessario conoscere anche il nome della classe. 

# Assegnamo queste due informazioni a due variabili:
	driverClass<-"com.ibm.db2.jcc.DB2Driver"
	classPath<-"C:/Documents and Settings/UserRegTosc/Documenti/driver/db2/db2jcc.jar"

# e definiamo con un altra variabile il driver da usare

	drv <- JDBC(driverClass,file.path(classPath) , identifier.quote=NA)

# A questo punto dobbiamo disporre della stringa di connessione che possiamo comporre introducendo i vari parametri 
# in variabili, come indicato nell'esempio seguente:

	server<-"db2dwp1.regione.toscana.it"

	port<-50000

	database<-"OSI"

	schema<-"DMPERSECO"

	usr<-"xxxxxxx" #(utente)
	psw<-"xxxxxxx" #(password)

# Definiti i parametri, tramite l'istruzione paste0(.,.) concateniamoli per ottenere la stringa di connessione, 
# utilizzando l'istruzione trim() per eliminare spazi superflui:
	con_str<-paste0
	(	"jdbc:db2://"
		,trim(server)
		,":"
		,trim(port)
		,"/"
		,trim(database)
		,":currentSchema="
		,trim(schema)
		,";"
	)

# e utilizziamo questa nell'istruzione 
	dbConnect({Driver},{stringa connessione},{usr},{psw})
# nel seguente modo
	conn<-dbConnect(drv,con_str,usr,psw)

# per ottenere la connessione.

# La connessione può essere utilizzata con le seguenti funzioni per interagire con il database

# dbReadTable: consente di leggere una tabella e assegnare il contenuto ad una dataframe
# dbGetQuery: consente di assegnare il risultato di una query ad un dataframe
# dbSendUpdate: consente di mandare una istruzione di modifica verso il database: DML language e UPDATE
# dbWriteTable: consente di trasferire il contenuto di un dataframe verso una tabella sul database
