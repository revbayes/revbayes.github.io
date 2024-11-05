################################################################################
#
# R script: Plotting the site frequency spectrum.
#
#
# authors: Sebastian Hoehna
#
################################################################################


library(ggplot2)
library("RColorBrewer")

cols <- brewer.pal(n = 6, name = "Set1")

POPULATIONS = c("FiHe", "GeKi", "GeJe", "GeGl", "ItCo", "SwLa")
POPULATION_NAMES=c("Finland-Helsinki","Germany-Kiel","Germany-Jena","Germany-Munich","Italy-Milan","Switzerland-Lausanne")
cols=c("purple3","#9C4A1A", "#EC9704", "#F7C815", "#6D8C00", "#AA1803")



args <- commandArgs(trailingOnly = TRUE)


FiHe <- c(26478977, 1449757, 985341, 704973, 562124, 441656, 379405, 309385, 272636, 228534, 208468, 175249, 164361, 141319, 138409, 134290, 101384, 82036, 79964, 68205, 67842, 58138, 59203, 52002, 54894, 48201, 52344, 48139, 57452, 77808, 844421)
GeGl <- c(25855135, 1980517, 1286174, 902015, 696646, 532270, 455321, 366782, 312570, 253098, 229607, 189140, 176087, 149496, 137657, 114782, 111297, 96280, 94509, 82808, 89554, 62994, 60967, 50669, 51042, 44169, 45665, 39476, 41426, 36030, 37986, 33872, 36322, 33346, 36004, 32814, 37068, 36096, 42651, 56857, 393363)
GeJe <- c(23621539, 2675629, 1548879, 1028584, 747733, 570716, 445204, 355075, 290786, 240356, 202866, 175235, 153776, 133898, 117324, 103789, 94240, 86383, 79074, 74804, 73781, 57595, 51248, 46924, 43493, 40837, 38376, 36947, 35518, 33824, 33022, 32623, 32048, 32191, 32836, 32929, 34521, 36761, 42200, 61650, 330820)
GeKi <- c(25931943, 1884598, 1147198, 809826, 630990, 492287, 404624, 333761, 288000, 246614, 214694, 186476, 163595, 146210, 130552, 118026, 107182, 98056, 90693, 85174, 86135, 65524, 58878, 53775, 49130, 46254, 43059, 41004, 39548, 37320, 36210, 34860, 34517, 33842, 34038, 33599, 35452, 35868, 42234, 60584, 392223)
ItCo <- c(19115426, 8077546, 3177404, 1528532, 919327, 619321, 446117, 340116, 270737, 221885, 186045, 161096, 140385, 125096, 111784, 101978, 93792, 87698, 81668, 78609, 82383, 59865, 54135, 49480, 46263, 43530, 42176, 40327, 38842, 37243, 36814, 36594, 36548, 36905, 37524, 39420, 42665, 47609, 61071, 87053, 485539)
SwLa <- c(38950398, 1315967, 683872, 462428, 380231, 332338, 266540, 233523, 210748, 188851, 174069, 159594, 147199, 135277, 126785, 116918, 108735, 102339, 96877, 98921, 72553, 65207, 58737, 52399, 47385, 43460, 38835, 34284, 30071, 26341, 22521, 20194, 16701, 13913, 11534, 8053, 7186, 5762, 6919)

# remove monomorphic sites
FiHe <- FiHe[-1]
GeGl <- GeGl[-1]
GeJe <- GeJe[-1]
GeKi <- GeKi[-1]
ItCo <- ItCo[-1]
SwLa <- SwLa[-1]
FiHe <- FiHe[-length(FiHe)]
GeGl <- GeGl[-length(GeGl)]
GeJe <- GeJe[-length(GeJe)]
GeKi <- GeKi[-length(GeKi)]
ItCo <- ItCo[-length(ItCo)]
SwLa <- SwLa[-length(SwLa)]


pdf("SFS.pdf", width=9, height=6)
par(mfrow=c(2,3))
par(mar=c(0,0.0,0.0,0.0), oma=c(4,4.0,5,0.1))

plot(FiHe/sum(FiHe), ylim=c(0,0.5), pch=16, col=cols[1], xlab="", ylab="", xaxt="n", yaxt="n")
text(x=length(FiHe)/2,y=0.45,POPULATION_NAMES[1], cex=2)

plot(GeKi/sum(GeKi), ylim=c(0,0.5), pch=16, col=cols[2], xlab="", ylab="", xaxt="n", yaxt="n")
text(x=length(GeKi)/2,y=0.45,POPULATION_NAMES[2], cex=2)

plot(GeJe/sum(GeJe), ylim=c(0,0.5), pch=16, col=cols[3], xlab="", ylab="", xaxt="n", yaxt="n")
text(x=length(GeJe)/2,y=0.45,POPULATION_NAMES[3], cex=2)

plot(GeGl/sum(GeGl), ylim=c(0,0.5), pch=16, col=cols[4], xlab="", ylab="", xaxt="n", yaxt="n")
text(x=length(GeGl)/2,y=0.45,POPULATION_NAMES[4], cex=2)

plot(ItCo/sum(ItCo), ylim=c(0,0.5), pch=16, col=cols[5], xlab="", ylab="", xaxt="n", yaxt="n")
text(x=length(ItCo)/2,y=0.45,POPULATION_NAMES[5], cex=2)

plot(SwLa/sum(SwLa), ylim=c(0,0.5), pch=16, col=cols[6], xlab="", ylab="", xaxt="n", yaxt="n")
text(x=length(SwLa)/2,y=0.45,POPULATION_NAMES[6], cex=2)

mtext( side=1, "Allele frequency", line=2, cex=2, outer=TRUE )
mtext( side=2, "Frequency", line=1, cex=2, outer=TRUE )

dev.off()



FiHe_folded <- c()
GeGl_folded <- c()
GeJe_folded <- c()
GeKi_folded <- c()
ItCo_folded <- c()
SwLa_folded <- c()
for (i in 1:(ceiling(length(FiHe)/2)))  FiHe_folded[i] <- ifelse( i == (length(FiHe)+1)/2, FiHe[i], FiHe[i] + FiHe[length(FiHe)-i+1] )
for (i in 1:(ceiling(length(GeGl)/2)))  GeGl_folded[i] <- ifelse( i == (length(GeGl)+1)/2, GeGl[i], GeGl[i] + GeGl[length(GeGl)-i+1] )
for (i in 1:(ceiling(length(GeJe)/2)))  GeJe_folded[i] <- ifelse( i == (length(GeJe)+1)/2, GeJe[i], GeJe[i] + GeJe[length(GeJe)-i+1] )
for (i in 1:(ceiling(length(GeKi)/2)))  GeKi_folded[i] <- ifelse( i == (length(GeKi)+1)/2, GeKi[i], GeKi[i] + GeKi[length(GeKi)-i+1] )
for (i in 1:(ceiling(length(ItCo)/2)))  ItCo_folded[i] <- ifelse( i == (length(ItCo)+1)/2, ItCo[i], ItCo[i] + ItCo[length(ItCo)-i+1] )
for (i in 1:(ceiling(length(SwLa)/2)))  SwLa_folded[i] <- ifelse( i == (length(SwLa)+1)/2, SwLa[i], SwLa[i] + SwLa[length(SwLa)-i+1] )




pdf("SFS_folded.pdf", width=9, height=6)
par(mfrow=c(2,3))
par(mar=c(0,0.0,0.0,0.0), oma=c(4,4.0,5,0.1))

plot(FiHe_folded/sum(FiHe_folded), ylim=c(0,0.5), pch=16, col=cols[1], xlab="", ylab="", xaxt="n", yaxt="n")
text(x=length(FiHe_folded)/2,y=0.45,POPULATION_NAMES[1], cex=2)

plot(GeKi_folded/sum(GeKi_folded), ylim=c(0,0.5), pch=16, col=cols[2], xlab="", ylab="", xaxt="n", yaxt="n")
text(x=length(GeKi_folded)/2,y=0.45,POPULATION_NAMES[2], cex=2)

plot(GeJe_folded/sum(GeJe_folded), ylim=c(0,0.5), pch=16, col=cols[3], xlab="", ylab="", xaxt="n", yaxt="n")
text(x=length(GeJe_folded)/2,y=0.45,POPULATION_NAMES[3], cex=2)

plot(GeGl_folded/sum(GeGl_folded), ylim=c(0,0.5), pch=16, col=cols[4], xlab="", ylab="", xaxt="n", yaxt="n")
text(x=length(GeGl_folded)/2,y=0.45,POPULATION_NAMES[4], cex=2)

plot(ItCo_folded/sum(ItCo_folded), ylim=c(0,0.5), pch=16, col=cols[5], xlab="", ylab="", xaxt="n", yaxt="n")
text(x=length(ItCo_folded)/2,y=0.45,POPULATION_NAMES[5], cex=2)

plot(SwLa_folded/sum(SwLa_folded), ylim=c(0,0.5), pch=16, col=cols[6], xlab="", ylab="", xaxt="n", yaxt="n")
text(x=length(SwLa_folded)/2,y=0.45,POPULATION_NAMES[6], cex=2)

mtext( side=1, "Folded allele frequency", line=2, cex=2, outer=TRUE )
mtext( side=2, "Frequency", line=1, cex=2, outer=TRUE )

dev.off()


png("SFS_Munich.png", width=6, height=4)
par(mfrow=c(1,2))
par(mar=c(0,1.0,0.0,0.0), oma=c(2,2.0,2,0.1))

plot(GeGl/sum(GeGl), ylim=c(0,0.5), pch=16, col=cols[4], xlab="", ylab="", xaxt="n", yaxt="n")
mtext( side=3, "unfolded", line=0.5, cex=1.5 )

plot(GeGl_folded/sum(GeGl_folded), ylim=c(0,0.5), pch=16, col=cols[4], xlab="", ylab="", xaxt="n", yaxt="n")
mtext( side=3, "folded", line=0.5, cex=1.5 )

mtext( side=1, "Folded allele frequency", line=0.5, cex=1.5, outer=TRUE )
mtext( side=2, "Frequency", line=0.5, cex=1.5, outer=TRUE )

dev.off()





# remove singleton sites
FiHe <- FiHe[-1]
GeGl <- GeGl[-1]
GeJe <- GeJe[-1]
GeKi <- GeKi[-1]
ItCo <- ItCo[-1]
SwLa <- SwLa[-1]
FiHe <- FiHe[-length(FiHe)]
GeGl <- GeGl[-length(GeGl)]
GeJe <- GeJe[-length(GeJe)]
GeKi <- GeKi[-length(GeKi)]
ItCo <- ItCo[-length(ItCo)]
SwLa <- SwLa[-length(SwLa)]

FiHe_folded <- FiHe_folded[-1]
GeGl_folded <- GeGl_folded[-1]
GeJe_folded <- GeJe_folded[-1]
GeKi_folded <- GeKi_folded[-1]
ItCo_folded <- ItCo_folded[-1]
SwLa_folded <- SwLa_folded[-1]


pdf("SFS_no_singletons.pdf", width=9, height=6)
par(mfrow=c(2,3))
par(mar=c(0,0.0,0.0,0.0), oma=c(4,4.0,5,0.1))

plot(FiHe/sum(FiHe), ylim=c(0,0.5), pch=16, col=cols[1], xlab="", ylab="", xaxt="n", yaxt="n")
text(x=length(FiHe)/2,y=0.45,POPULATION_NAMES[1], cex=2)

plot(GeKi/sum(GeKi), ylim=c(0,0.5), pch=16, col=cols[2], xlab="", ylab="", xaxt="n", yaxt="n")
text(x=length(GeKi)/2,y=0.45,POPULATION_NAMES[2], cex=2)

plot(GeJe/sum(GeJe), ylim=c(0,0.5), pch=16, col=cols[3], xlab="", ylab="", xaxt="n", yaxt="n")
text(x=length(GeJe)/2,y=0.45,POPULATION_NAMES[3], cex=2)

plot(GeGl/sum(GeGl), ylim=c(0,0.5), pch=16, col=cols[4], xlab="", ylab="", xaxt="n", yaxt="n")
text(x=length(GeGl)/2,y=0.45,POPULATION_NAMES[4], cex=2)

plot(ItCo/sum(ItCo), ylim=c(0,0.5), pch=16, col=cols[5], xlab="", ylab="", xaxt="n", yaxt="n")
text(x=length(ItCo)/2,y=0.45,POPULATION_NAMES[5], cex=2)

plot(SwLa/sum(SwLa), ylim=c(0,0.5), pch=16, col=cols[6], xlab="", ylab="", xaxt="n", yaxt="n")
text(x=length(SwLa)/2,y=0.45,POPULATION_NAMES[6], cex=2)

mtext( side=1, "Allele frequency", line=2, cex=2, outer=TRUE )
mtext( side=2, "Frequency", line=1, cex=2, outer=TRUE )

dev.off()


pdf("SFS_folded_no_singletons.pdf", width=9, height=6)
par(mfrow=c(2,3))
par(mar=c(0,0.0,0.0,0.0), oma=c(4,4.0,5,0.1))

plot(FiHe_folded/sum(FiHe_folded), ylim=c(0,0.5), pch=16, col=cols[1], xlab="", ylab="", xaxt="n", yaxt="n")
text(x=length(FiHe_folded)/2,y=0.45,POPULATION_NAMES[1], cex=2)

plot(GeKi_folded/sum(GeKi_folded), ylim=c(0,0.5), pch=16, col=cols[2], xlab="", ylab="", xaxt="n", yaxt="n")
text(x=length(GeKi_folded)/2,y=0.45,POPULATION_NAMES[2], cex=2)

plot(GeJe_folded/sum(GeJe_folded), ylim=c(0,0.5), pch=16, col=cols[3], xlab="", ylab="", xaxt="n", yaxt="n")
text(x=length(GeJe_folded)/2,y=0.45,POPULATION_NAMES[3], cex=2)

plot(GeGl_folded/sum(GeGl_folded), ylim=c(0,0.5), pch=16, col=cols[4], xlab="", ylab="", xaxt="n", yaxt="n")
text(x=length(GeGl_folded)/2,y=0.45,POPULATION_NAMES[4], cex=2)

plot(ItCo_folded/sum(ItCo_folded), ylim=c(0,0.5), pch=16, col=cols[5], xlab="", ylab="", xaxt="n", yaxt="n")
text(x=length(ItCo_folded)/2,y=0.45,POPULATION_NAMES[5], cex=2)

plot(SwLa_folded/sum(SwLa_folded), ylim=c(0,0.5), pch=16, col=cols[6], xlab="", ylab="", xaxt="n", yaxt="n")
text(x=length(SwLa_folded)/2,y=0.45,POPULATION_NAMES[6], cex=2)

mtext( side=1, "Folded allele frequency", line=2, cex=2, outer=TRUE )
mtext( side=2, "Frequency", line=1, cex=2, outer=TRUE )

dev.off()


cat("unfolded:\t",FiHe,"\n")
cat("folded:\t\t",FiHe_folded,"\n")



pdf("SFS_folded_no_singletons_FiHe.pdf", width=4, height=3)
par(mar=c(4,5.0,0.1,0.1))

plot(FiHe_folded, ylim=c(0,1.1*max(FiHe_folded)), pch=16, col=cols[1], xlab="", ylab="", xaxt="n", yaxt="n")
#text(x=length(FiHe_folded)/2,y=0.45,POPULATION_NAMES[1], cex=2)

# axis(side, at=, labels=, pos=, lty=, col=, las=, tck=, ...)
axis(1)
axis(2, at=c(2.5E5,5.0E5,7.5E5,1E6), labels=c("2.5E5","5.0E5","7.5E5","1E6"), las=2)
mtext( side=1, "Folded allele frequency", line=3, cex=1.5, outer=!TRUE )
mtext( side=2, "Frequency", line=3.5, cex=1.5, outer=!TRUE )

dev.off()


cat("unfolded:\t",FiHe,"\n")
cat("folded:\t\t",FiHe_folded,"\n")
