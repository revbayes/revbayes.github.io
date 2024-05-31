library(RevGadgets)
library(coda)
library(ggplot2)
library(ggtree)
library(grid)
library(gridExtra)
library(reshape2)


# functions
param_label_to_tok = function(x) {
    z = gsub("\\.", "_", x)
    tok = strsplit(z, split="_")[[1]]
    return(tok)
}
get_desc = function(df, par, proc, idx) {
    
    if (proc == "b" || proc == "d") {
        rel = "between"
    } else {
        rel = "within"
    }
    
    if (par == "phi") {
        typ = "quantitative"
    } else {
        typ = "categorical"
    }
    
    desc = df$desc[ df$relationship==rel & df$type == typ & df$index == idx ]
    return(desc)
}

# arguments
cmd_str = "Rscript ./scripts/plot_model_posterior.R \
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
base_plot_fn      = "./output/plot_param"

# analysis vars
param_names = c("sigma", "phi")
process_names = c("d", "e", "w", "b")

# prepare trace
trace_quant = readTrace(path=model_fn, burnin=0.1)
trace_names = names(trace_quant[[1]])
df_desc = read.csv(desc_fn, sep=",", header=T)

# compute RJ probs for all feature pairs
for (p in process_names) {
    
    plot_fn = paste0(base_plot_fn, "_rj.process_", p, ".pdf")

    #phi_match   = grep(paste0("^use_*", p), trace_names)
    rj_match = grep(paste0("^use_[a-z]*_", p), trace_names)

    z = lapply(rj_match, function(i) { as.vector(trace_quant[[1]][[i]]) })
    names(z) = trace_names[rj_match]
    df_rj = data.frame(z)

    res = list()
    num_param = ncol(df_rj)
    for (i in 1:num_param) {
        for (j in 1:num_param) {
            if (i > j) {
                # rj prob of 2x2 feature effects?
                m = matrix(0, ncol=2, nrow=2)
                m[1,1] = sum( !df_rj[,i] & !df_rj[,j] )
                m[1,2] = sum( !df_rj[,i] &  df_rj[,j] )
                m[2,1] = sum(  df_rj[,i] & !df_rj[,j] )
                m[2,2] = sum(  df_rj[,i] &  df_rj[,j] )
                rownames(m) = c("no", "yes")
                colnames(m) = c("no", "yes")
                
                # non-independence between feature effects?
                chisq = chisq.test(m)
                
                # normalize
                m_norm = m / sum(m)
                m_norm = round(m_norm, digits=2)
                
                # axis names
                x = colnames(df_rj)[i]
                x_tok = param_label_to_tok(x)
                x_desc = get_desc(df_desc, x_tok[2], x_tok[3], x_tok[4])
                x_lbl = paste0( x_tok[2], "_", x_tok[3], "[", x_tok[4], "]\n", x_desc)
                
                
                y = colnames(df_rj)[j]
                y_tok = param_label_to_tok(y)
                y_desc = get_desc(df_desc, y_tok[2], y_tok[3], y_tok[4])
                y_lbl = paste0( y_tok[2], "_", y_tok[3], "[", y_tok[4], "]\n", y_desc)
                res[[ length(res)+1 ]] = list(m=m_norm, chisq=chisq, x=x_lbl, y=y_lbl)
            }
        }
    }

   
    pdf(plot_fn, height=5, width=5)
    plt = list()
    for (i in 1:length(res)) {
        m = melt(res[[i]]$m)
        colnames(m) = c("x", "y", "value")
        #br = seq(0,1,by=0.1)
        #col = rainbow(length(br)+1, start=0, end=0.5)
        p = ggplot(m, aes(x=x, y=y, fill=value))
        p = p + geom_tile(color="black", lwd=0.5, linetype=1)
        p = p + geom_text(aes(label=value), color="black", size=4)
        p = p + scale_fill_gradientn( colors=c("red","white","blue"),
                                      values=c(0,0.25,1.0), limits=c(0,1), name = "Prob.")
        p = p + coord_fixed()
        p = p + xlab( res[[i]]$x )
        p = p + ylab( res[[i]]$y )
        p = p + theme(line = element_blank(),
                      panel.grid.minor = element_blank(),
                      panel.grid.major = element_blank(),
                      panel.border = element_blank(),
                      panel.background = element_blank())
        dy = 0.02
        chisq_pval = format(res[[i]]$chisq$p.value, scientific = TRUE, digits = 2)
        chisq_stat = round( res[[i]]$chisq$statistic, digit=2 )
        chisq_lbl  = paste0( "chisq = ", chisq_stat, ", p = ", chisq_pval )
        
        p = p + annotate("text", x = 2.5, y = 2.5 + dy, label=chisq_lbl,  hjust=1, vjust=0 )
        plt[[i]] = p
        print(p)

    }
    dev.off()
}
