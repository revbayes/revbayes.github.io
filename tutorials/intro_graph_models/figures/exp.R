png("exp.png",width=500,height=250)
curve(dexp(x, 1), from=0, to=3, lwd=3, 
      xlab=expression(sigma),
      ylab=expression(paste("P(", sigma ,")")), 
      ylim=c(0,2))
curve(dexp(x, 10), from=0, to=3, lwd=3, col="red", add=T)
curve(dexp(x, 100), from=0, to=3, lwd=3, col="blue", add=T, n=1000)
legend("topright", 
       c(expression(paste(lambda," = 1")), 
         expression(paste(lambda," = 10")),
         expression(paste(lambda," = 100"))), 
       fill=c("black", "red", "blue"))
dev.off()
