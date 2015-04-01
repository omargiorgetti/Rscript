##################################################################################
# SCRIPT R che legge il csv delle timbrature "lungo", fa qualche ricodifica,     #      
# elimina le varibili superflue per l'operazione e lo trasforma in "largo"       #
# Il csv attualmente letto è la DG Organizzazione a dicembre 2012                #
##################################################################################

library(RJDBC)
drv <- JDBC(driverClass="com.ibm.db2.jcc.DB2Driver", classPath="C:/Programmi/SQuirreL SQL Client/lib/db2/db2jcc.jar", identifier.quote=NA)
conn<-dbConnect(drv,"jdbc:db2://db2dwp1.regione.toscana.it:50000/OSI:currentSchema=DMPERSECO;","dmpersrw","C842477i")


ORG<-dbGetQuery(conn,"
  SELECT
    trim(DMPERSECO.D_DG.CMU),
    TRIM(DMPERSECO.D_DG.NOME),
    DMPERSECO.D_SETTORE.CMU,
    TRIM(DMPERSECO.D_SETTORE.NOME),
    DMPERSECO.TIMBRATURE.TB_DATA_TIMB,
    DMPERSECO.TIMBRATURE.MATRICOLA,
    DMPERSECO.TIMBRATURE.ORA,
    DMPERSECO.TIMBRATURE.TB_SIGLA_TIPO_VERSO_TIMB,
    CASE WHEN DMPERSECO.TIMBRATURE.TB_FLAG='O' THEN 'Timbratura Originale' WHEN DMPERSECO.TIMBRATURE.TB_FLAG='I' THEN 'Timbratura Inserita' WHEN DMPERSECO.TIMBRATURE.TB_FLAG='M' THEN 'Timbratura Modificata' ELSE 'Altro' END
  FROM DMPERSECO.TIMBRATURE 
      LEFT OUTER JOIN DMPERSECO.V_INQUADRAMENTO_DIP  DMPERSECO_V_INQUADRAMENTO_DIP_MANSIONE 
                ON DMPERSECO.TIMBRATURE.MATRICOLA=DMPERSECO_V_INQUADRAMENTO_DIP_MANSIONE.MATRICOLA
                AND DMPERSECO.TIMBRATURE.DATA>=DMPERSECO_V_INQUADRAMENTO_DIP_MANSIONE.II_DT_ENABLE 
                AND DMPERSECO.TIMBRATURE.DATA<=COALESCE(DMPERSECO_V_INQUADRAMENTO_DIP_MANSIONE.II_DT_DISABLE ,30000101)
                AND TRIM(DMPERSECO_V_INQUADRAMENTO_DIP_MANSIONE.IG_RICL)='DISCIPLINE',
    DMPERSECO.D_DG,
    DMPERSECO.D_SETTORE,
    DMPERSECO.UP1ADR00_MANSIONE,
    DMPERSECO.D_GERARCHIA,
  (
    SELECT C.MATRICOLA,C.TB_DATA_TIMB,C.DATA,C.CMU_UO,C.CMU_UF,C.CMU_INC,C.CMU, 
      CASE 
        WHEN D.ID_GERARCHIA IS NOT NULL THEN D.ID_GERARCHIA 
        WHEN F.ID_GERARCHIA IS NOT NULL THEN F.ID_GERARCHIA 
        WHEN H.ID_GERARCHIA IS NOT NULL THEN H.ID_GERARCHIA
      END ID_GERARCHIA
    FROM 
      ( 
        select 
        A.MATRICOLA,A.TB_DATA_TIMB,A.DATA,A.CMU_UO,A.CMU_UF,A.CMU_INC,A.CMU, 
        B.ID_SETTORE, E.ID_AREA, G.ID_DG
        FROM DMPERSECO.V_ASSEGN_GERARCHIE_TIMBRATURE_APPO A 
          LEFT OUTER JOIN DMPERSECO.D_SETTORE B ON A.CMU=B.CMU 
          LEFT OUTER JOIN DMPERSECO.D_AREA E ON A.CMU=E.CMU 
          LEFT OUTER JOIN DMPERSECO.D_DG G ON A.CMU=G.CMU 
      ) C 
    LEFT OUTER JOIN DMPERSECO.D_GERARCHIA D ON C.ID_SETTORE=D.ID_SETTORE  AND D.ID_PO=1 and c.data between d.div and d.dfv
    LEFT OUTER JOIN DMPERSECO.D_GERARCHIA F ON C.ID_AREA=F.ID_AREA  AND F.ID_PO=1 AND F.ID_SETTORE=1 and c.data between f.div and f.dfv
    LEFT OUTER JOIN DMPERSECO.D_GERARCHIA H ON C.ID_DG=H.ID_DG  AND H.ID_PO=1 AND H.ID_SETTORE=1 AND H.ID_AREA=1 and c.data between h.div and h.dfv
  ) AS V_ASSEGN_GERARCHIE_TIMBRATURE
  WHERE
  ( DMPERSECO.TIMBRATURE.MATRICOLA=V_ASSEGN_GERARCHIE_TIMBRATURE.MATRICOLA
      AND
      DMPERSECO.TIMBRATURE.TB_DATA_TIMB=V_ASSEGN_GERARCHIE_TIMBRATURE.TB_DATA_TIMB  )
    AND  ( V_ASSEGN_GERARCHIE_TIMBRATURE.ID_GERARCHIA=DMPERSECO.D_GERARCHIA.ID_GERARCHIA  )
    AND  ( DMPERSECO.D_GERARCHIA.ID_SETTORE=DMPERSECO.D_SETTORE.ID_SETTORE  )
    AND  ( DMPERSECO.D_GERARCHIA.ID_DG=DMPERSECO.D_DG.ID_DG  )
    AND  ( DMPERSECO_V_INQUADRAMENTO_DIP_MANSIONE.IG_CODICE=DMPERSECO.UP1ADR00_MANSIONE.DR_CDCC  )
    AND  
    (
     TRIM(DMPERSECO.D_DG.NOME)  IN  ( 'ORGANIZZAZIONE'  )
   AND
   DMPERSECO.UP1ADR00_MANSIONE.DR_CDCC  NOT IN 
      ( 'B01M11  ','B03M11  ','B3CI01  ','B93500  ','C92500  ','CC1M11  ','DD1M11  ','E93500  '  )
  )");

#dbWriteTable(conn,"PROGRAMMATO_ENTI",programmato_enti,append=T,row.name=F);
#dbSendUpdate(conn,"");

# PULITURA DELLO SPAZIO DI LAVORO
rm(list=ls(all=TRUE))

# LETTURA DEL CSV DELLE TIMBRATURE DI DICEMBRE: DG ORGANIZZAZIONE
setwd("C:\\Documents and Settings\\UserRegTosc\\Documenti\\DSS\\ANALISI PERSONALE\\Compresenza")
#ORG<-read.csv2("dg_organizzazione_dicembre.csv", header = TRUE, sep = ";", 
#               as.is=TRUE, quote="\"", dec=",")

# str(ORG)

# Costruzione della chiave "dip" come concatenamento "Data" + "Matricola"
ORG$dip<-paste(substr(ORG$Data,1,10), ORG$Matricola)

# Trasformazione della stringa dell'ora timbratura in numero di minuti
ORG$timbr<-60*as.numeric(substr(ORG$Ora.timbratura,1, 2)) + 
                  as.numeric(substr(ORG$Ora.timbratura,4, 5))

# Eliminazione delle variabili superflue
ORG$Cmu.DG<-NULL				# potrebbe non esser aqcuisita
ORG$Nome.DG<-NULL				# potrebbe non esser aqcuisita
ORG$Cmu.Settore<-NULL			# potrebbe non esser aqcuisita
ORG$Nome.Settore<-NULL			# potrebbe non esser aqcuisita
ORG$Data<-NULL
ORG$Matricola<-NULL
ORG$Ora.timbratura<-NULL
ORG$Descrizione.flag.timbratura<-NULL	# potrebbe non esser aqcuisita
ORG$Verso.timbratura<-NULL			# potrebbe non esser aqcuisita (se vale la nota che segue)
# str(ORG)

# Ordinamento sulla chiave "dip" e timbrature "timbr". Si assume che la sequenza 
# delle timbrature ordinate per la chiave "dip" sia coerente con la sequenza (E1, U1, E2, U2,...)
# Può non esserlo nel caso di mancate timbrature in entrata non regolarizzate (es. dirigenti)
ORG.ordinato<-ORG[order(ORG$dip, ORG$timbr),]

# Cancellazione di ORG non ordinato
rm(ORG)

# Funzione "Fatti.bene" 
Fatti.bene<-function(fatti.male)
	{
	Tab<-table(fatti.male$dip)		# tabella n° timbrature per matricola-giorno
	n.dip<-length(Tab)			# n° matricole giorno
	Ris<-NULL
	for(Ind in 1:n.dip)			# ciclo su n° matricole giorno
		{
		dip.i<-1:(Tab[Ind])		# sequenza 1,... n per ogni matricola giorno
		Ris<-c(Ris,dip.i)
		}
	con.n<-cbind(fatti.male,Ris)
	Ent1<-con.n[con.n$Ris==1,]
	Usc1<-con.n[con.n$Ris==2,]
	Ent2<-con.n[con.n$Ris==3,]
	Usc2<-con.n[con.n$Ris==4,]
	Ent3<-con.n[con.n$Ris==5,]
	Usc3<-con.n[con.n$Ris==6,]
	Ent4<-con.n[con.n$Ris==7,]
	Usc4<-con.n[con.n$Ris==8,]
	Ent5<-con.n[con.n$Ris==9,]
	Usc5<-con.n[con.n$Ris==10,]

	M1<-merge(Ent1, Usc1, by.x="dip", by.y="dip",all=TRUE)
	M2<-merge(M1, Ent2, by.x="dip", by.y="dip", all=TRUE)
	M3<-merge(M2, Usc2, by.x="dip", by.y="dip", all=TRUE)
	M4<-merge(M3, Ent3, by.x="dip", by.y="dip", all=TRUE)
	M5<-merge(M4, Usc3, by.x="dip", by.y="dip", all=TRUE)
	M6<-merge(M5, Ent4, by.x="dip", by.y="dip", all=TRUE)
	M7<-merge(M6, Usc4, by.x="dip", by.y="dip", all=TRUE)
	M8<-merge(M7, Ent5, by.x="dip", by.y="dip", all=TRUE)
	M9<-merge(M8, Usc5, by.x="dip", by.y="dip", all=TRUE)

	colnames(M9)<-c("dip","E1","R1", "U1", "R2", "E2", "R3",
                      "U2", "R4", "E3", "R5", "U3", "R6",
                      "E4", "R7", "U4", "R8", "E5", "R9", "U5", "R10")
      M9$R1<-NULL
	M9$R2<-NULL
	M9$R3<-NULL
	M9$R4<-NULL
	M9$R5<-NULL
	M9$R6<-NULL
	M9$R7<-NULL
	M9$R8<-NULL
	M9$R9<-NULL
	M9$R10<-NULL

	M9$E1<-ifelse(is.na(M9$E1), 0, M9$E1)
	M9$U1<-ifelse(is.na(M9$U1), 0, M9$U1)
	M9$E2<-ifelse(is.na(M9$E2), 0, M9$E2)
	M9$U2<-ifelse(is.na(M9$U2), 0, M9$U2)
	M9$E3<-ifelse(is.na(M9$E3), 0, M9$E3)
	M9$U3<-ifelse(is.na(M9$U3), 0, M9$U3)
	M9$E4<-ifelse(is.na(M9$E4), 0, M9$E4)
	M9$U4<-ifelse(is.na(M9$U4), 0, M9$U4)
	M9$E5<-ifelse(is.na(M9$E5), 0, M9$E5)
	M9$U5<-ifelse(is.na(M9$U5), 0, M9$U5)

	M9
	}


# Applicazione della funzione che trasforma il data.frame ORG.ordinato "lungo" in ORG2 "largo"
ORG2<-Fatti.bene(ORG.ordinato)
# str(ORG2)

# Riseparazione della Data dalla Matricola e cancellazione della chiave composta "dip"
ORG2$Data<-substr(ORG2$dip,1,10)
ORG2$Matricola<-as.numeric(substr(ORG2$dip, 12, 16))

# Verifiche
# sum(ORG2$E1==0)			   # Casi con 1° entrata = 0   Nessun caso dopo esclusione autisti
# sum(ORG2$E1!=0 & ORG2$U1==0)   # Casi con solo entrata	2 gg di Castellani (orario dirigenti)
# ORG2[ORG2$E1!=0 & ORG2$U1==0,]
# ORG.ordinato[is.element(ORG.ordinato$dip, c("2012/12/17 14483","2012/12/18 14483")),]


# SCRITTURA DEL CSV NELLA STESSA CARTELLA DA DOVE E' STATO LETTO IL CSV DI INPUT
write.table(ORG2, file = "dg_org_dicembre_LARGO.csv", append = FALSE, 
            quote = TRUE, sep = ";", row.names = FALSE,
            eol = "\n", na = "NA", dec = ",", 
            qmethod = c("escape", "double"))


################################################################################################







