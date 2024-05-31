library(ape)

prefix_fn = "./input/results/Kadua_M1_213"

phy_fn = paste0(prefix_fn, ".tre")
dat_fn = paste0(prefix_fn, ".states.txt")
out_fn = paste0(prefix_fn, ".thinned.tre")

#phy = read.nexus(phy_fn)
phy = read.csv(phy_fn, sep="\t")
dat = read.csv(dat_fn, sep="\t")

phy_thinned = phy[ match(dat$Iteration, phy$Iteration), ]
write.table(x=phy_thinned, file=out_fn, sep="\t", col.names=T, quote=F, row.names=F)
