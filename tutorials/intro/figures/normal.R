png("normal.png",width=500,height=500)
curve(dnorm(x, 0, 0.1), from=-3, to=3, lwd=3, 
      xlab=expression(theta),
      ylab=expression(paste("P(", theta ,")")), 
      ylim=c(0,4))
curve(dnorm(x, 0, 1), from=-3, to=3, lwd=3, col="red", add=T)
curve(dnorm(x, 0, 10), from=-3, to=3, lwd=3, col="blue", add=T, n=1000)
legend("topright", 
       c(expression(paste(sigma," = 0.1")), 
         expression(paste(sigma," = 1.0")),
         expression(paste(sigma," = 10.0"))), 
       fill=c("black", "red", "blue"))
dev.off()
