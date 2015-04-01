#############################################################
# Grafico dinamico di una passeggiata aleatoria.            #
# La funzione Passeggiata prende i due argomenti:           #
# 1) Il numero dei passi                                    #
# 2) Il valore dell'incremento (slope) event. uguale a 0    #
# 3) Il ritardo fra un passo e l'altro                      #
#############################################################

Passeggiata<-function(N, slope, sleep)
	{
	Y<- cumsum(rnorm(N, mean=slope))
	for (i in 1:(N-1))
		{
		plot(Y[1:i], type="l", xlim=c(1, N-1),
                 ylim=c(min(Y), max(Y)), col=2, lwd=2,
                 xlab="tempo", ylab="Y",
                 main="Passeggiata aleatoria")
	       segments(i,Y[i],i+1, Y[i+1], col=2, lwd=2)	
	       Sys.sleep(sleep)
		}
	}

Passeggiata(50, 0.2, 0.1)

