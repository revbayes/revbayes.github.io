# libraries
library(ggplot2)
library(reshape2)
#library(patchwork)
library(cowplot)
# library(rjson)
library(data.table)
library(HDInterval)
library(igraph)

# arguments
cmd_str = "Rscript ./scripts/plot_feature_rate_network.R \
                   ./example_input/results/divtime_timefig.model.txt \
                   ./example_input/hawaii_data/feature_description.csv"

args = commandArgs(trailingOnly = T)
if ( length(args) != 2 ) {
    stop_str = paste0("Invalid arguments. Correct usage:\n> ", cmd_str, "\n")
    stop(stop_str)
}

# filesystem
model_fn          = args[1]                             # ex: model_fn = "./example_input/results/divtime_timefig.model.txt"
desc_fn           = args[2]                             # ex: desc_fn = "./example_input/hawaii_data/feature_description.csv"
plot_fn           = "./output/plot_feature_rate_network.pdf"

# settings
low_color  = "#eeeeff"
high_color = "#4444ff"
na_color   = "#cccccc"

# read input
df_desc = read.csv(desc_fn, sep=",", header=T)
df_all = read.csv(model_fn, sep="\t", head=T)
df_eff = df_all[ , grepl("(^phi)|(^sigma)", names(df_all))]

# analysis info
proc_node = c("m_b","m_d","m_e","m_w")
proc = c("d", "e", "w", "b")
f_burn = 0.1
n_burn = NA # as.integer(f_burn * (length(json_all)-1)) + 1
thin_by = 10

# gather info about feature <-> param <-> rate
param_node = names(df_eff)
param_desc = c()
for (i in 1:length(param_node)) {
    
    z = gsub("\\.", "_", param_node[i])
    tok = strsplit(z, split="_")[[1]]
    
    typ = ifelse(tok[1] == "phi", "quantitative", "categorical")
    rel = ifelse(tok[2] %in% c("e", "w"), "within", "between")
    idx = as.numeric(tok[3])
    param_print = paste0( tok[1], "_", tok[2], "[", idx, "]" )
    
    y = c(idx, rel, typ, tok[1], tok[2], param_node[i], param_print)
    
    param_desc = rbind(param_desc, y)
}

# get data frame of parameter descriptions
df_param_desc = data.frame(param_desc)
rownames(df_param_desc)=NULL
colnames(df_param_desc)=c("idx","rel","typ","letter","process","param","param_print")

# sort for plotting purposes
sort_idx = order(df_param_desc$typ, df_param_desc$rel, df_param_desc$idx)
df_param_desc = df_param_desc[sort_idx, ]
param_node_sort = df_param_desc$param_print

coverage = 0.8
df_mean = colMeans(df_eff)
df_hdi = apply(df_eff, 2, function(x) { hdi(x, credMass=coverage) } )

# make incidence matrix for process (col) vs. feature effects (row)
m = matrix(0, ncol=length(proc_node), nrow=length(param_node_sort))
rownames(m) = param_node_sort
colnames(m) = proc_node
all_names = c(param_node_sort, proc_node)
for (i in 1:length(df_mean)) {
    n = names(df_mean)[i]
    j = paste0("m_", df_param_desc$process[df_param_desc$param == n])
    pretty_n = df_param_desc$param_print[df_param_desc$param == n]
    m[pretty_n,j] = df_mean[i]
}


# build graph object
g1 = graph_from_biadjacency_matrix(m, weighted=T)

# manually construct layout
layout = matrix(data=NA, nrow=length(all_names), ncol=2)
rownames(layout) = all_names
q_idx = which(grepl("^phi", V(g1)$name))
c_idx = which(grepl("^sigma", V(g1)$name))
m_idx = which(grepl("^m", V(g1)$name))
layout[q_idx,2] = -2
layout[m_idx,2] = 0
layout[c_idx,2] = 2
layout[q_idx,1] = -(1:length(q_idx))
layout[c_idx,1] = -(1:length(c_idx))
layout[m_idx,1] = -(1:length(proc_node))
layout[m_idx,1] = layout[m_idx,1] * 2 + 1/2
layout = layout[,2:1]

# create dummy plot to gather info about label sizes
pdf(NULL)
tmp = plot.igraph(g1, layout=layout)
vsize = strwidth(V(g1)$label) + strwidth("oo") * 1500
vsize2 = strheight("I") * 2 * 350

# create full plot
pdf(plot_fn, height=8, width=12)

plot.igraph(g1, 
    layout=layout,
    vertex.shape="rectangle",
    vertex.size=vsize,
    vertex.size2=vsize2,
    vertex.color=c("green","cyan")[V(g1)$type+1],
    vertex.label.family = "sans",
    vertex.label.color="black",
    edge.width=abs(E(g1)$weight)*8, 
    edge.color=ifelse(E(g1)$weight > 0, "#ffaaaa","#aaaaff"),
    edge.label.family = "sans",
    edge.label=sapply(E(g1)$weight, function(x) {
        y=round(x,digits=2);
        if (y>0) { y = paste0("+",y) } else {y};
        return(y)}),
    edge.label.dist=10,
    edge.label.color="black",
    rescale=F,
    xlim=c(-3, 3),
    ylim=c( min(layout[,2]), max(layout[,2]) ))


par(mar=c(0,0,0,0)+.1)

## NOTE: this part needs to be generalized

# get this from file
qfeat = c("Distance (km)",  "Log distance (km)", "Altitude (m)", "Log altitude (m)")
cfeat = c("In/out Hawaii?", "Into younger?", "Young island?",  "Net growth?")

# add info about regional features for effects
sw = 2.0
sh = 0.5
frsz = 0.0
rect(
     -4.5 - sw/2 - frsz,
     -(1:4)*2+0.5 - sh/2 - frsz,
     -4.5 + sw/2 + frsz,
     -(1:4)*2+0.5 + sh/2 + frsz,
     col="gold"
)
text( x=-4.5, y=-(1:4)*2 + 1/2, qfeat, adj=0.5)
segments( x0=3, x1=3, y0=-(1:4)*2+0, y1=-(1:4)*2+1, lwd=1, col="black")
segments( x0=3, x1=3, y0=-(1:4)*2+0, y1=-(1:4)*2+1, lwd=1, col="black")
segments( x0=3, x1=2.8, y0=-(1:4)*2+0, y1=-(1:4)*2+0, lwd=1, col="black")
segments( x0=3, x1=2.8, y0=-(1:4)*2+1, y1=-(1:4)*2+1, lwd=1, col="black")
segments( x0=3, x1=3.2, y0=-(1:4)*2+0.5, y1=-(1:4)*2+0.5, lwd=1, col="black")

rect(
     4.5 - sw/2 - frsz,
     -(1:4)*2+0.5 - sh/2 - frsz,
     4.5 + sw/2 + frsz,
     -(1:4)*2+0.5 + sh/2 + frsz,
     col="gold"
)
text( x= 4.5, y=-(1:4)*2 + 1/2, cfeat, adj=0.5)
segments( x0=-3, x1=-3, y0=-(1:4)*2+0, y1=-(1:4)*2+1, lwd=1, col="black")
segments( x0=-3, x1=-3, y0=-(1:4)*2+0, y1=-(1:4)*2+1, lwd=1, col="black")
segments( x0=-3, x1=-2.8, y0=-(1:4)*2+0, y1=-(1:4)*2+0, lwd=1, col="black")
segments( x0=-3, x1=-2.8, y0=-(1:4)*2+1, y1=-(1:4)*2+1, lwd=1, col="black")
segments( x0=-3, x1=-3.2, y0=-(1:4)*2+0.5, y1=-(1:4)*2+0.5, lwd=1, col="black")


dev.off()

quit()
