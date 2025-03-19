# libraries
library(ggplot2)
library(reshape2)
#library(patchwork)
library(cowplot)
# library(rjson)
library(data.table)

# arguments
cmd_str = "Rscript ./scripts/plot_rates_vs_time_grid.R \
                   ./example_input/results/divtime_timefig
                   ./example_input/hawaii_data/feature_summary.csv \
                   ./example_input/hawaii_data/age_summary.csv \
                   ./example_input/hawaii_data/feature_description.csv \
                   GNKOMHZ"

args = commandArgs(trailingOnly = T)
if ( length(args) != 5 ) {
    stop_str = paste0("Invalid arguments. Correct usage:\n> ", cmd_str, "\n")
    stop(stop_str)
}

# filesystem
results_fp        = args[1]                             # ex: results_fp = "./example_input/results/divtime_timefig"
feature_fn        = args[2]                             # ex: feature_fn = "./example_input/hawaii_data/feature_summary.csv"
age_fn            = args[3]                             # ex: age_fn = "./example_input/hawaii_data/age_summary.csv"
desc_fn           = args[4]                             # ex: desc_fn = "./example_input/hawaii_data/feature_description.csv"
region_names      = args[5]                             # ex: region_names = "GNKOMHZ"
base_plot_fn      = "./output/plot_rate_vs_time"

# settings
low_color = "#eeeeff"
high_color = "#4444ff"
na_color = "#cccccc"

# read input
df_feature = read.csv(feature_fn, sep=",", header=T)
df_age = read.csv(age_fn, sep=",", header=T)
df_desc = read.csv(desc_fn, sep=",", header=T)

# files
results_tok = strsplit(results_fp, split="/")[[1]]
n_tok = length(results_tok)
res_fp = paste(results_tok[1:(n_tok-1)], collapse="/")
res_prefix = paste0(results_tok[n_tok], ".*")
res_pattern = paste0(res_prefix, "\\.bg") #\\..*")
files = list.files(path=res_fp, pattern=res_pattern, full.names=T)

# dimensions
regions = strsplit(region_names, "")[[1]]
# ages = c(0, df_age$mean_age, 22)
num_regions = length(regions)
num_ages = length(df_age$mean_age) + 1

proc = c("d", "e", "w", "b")
f_burn = 0.1
n_burn = NA # as.integer(f_burn * (length(json_all)-1)) + 1
thin_by = 10

# collect posterior traces
df_time = list()
for (i in 1:length(files)) {
    df = read.csv(files[i], header=T, sep="\t")

    if (is.na(n_burn)) {
        n_burn = as.integer(f_burn * nrow(df))
    }

    df = df[(n_burn+1):nrow(df), ]
    colnames(df) = paste0( colnames(df), "_fileindex_", i )
    df_time[[i]] = df
}

df_all = dplyr::bind_cols(df_time)
df_mean = colMeans(df_all)

df_rate = list()
min_rate = c("w"=Inf, "e"=Inf, "d"=Inf, "b"=Inf)
max_rate = -min_rate

for (p in proc) {
    pattern = paste0("r_", p)
    idx = grepl(pattern=paste0("r_",p), names(df))
    df_p = df_mean[idx]
    df_p = df_p[ sort(names(df_p)) ]
    
    r_t = list()
    
    offset = c(1,num_regions)
    if (p == "b" || p == "d") {
        offset = c(num_regions, num_regions)
    }
    
    for (i in 1:num_ages) {
        j = (i-1) * prod(offset) + 1
        k = j + prod(offset) - 1
        r = df_p[j:k]
        # hacky fix: better to read in the NA from region features
        r[r == 0] = NA
        r[r > 20] = NA     
        m = matrix(r, nrow=offset[1], ncol=offset[2], byrow=T)
        colnames(m) = regions
        if (ncol(m) == nrow(m)) {
            rownames(m) = regions
        } else {
            rownames(m) = c("G")
        }
        r_t[[i]] = m
        
        if (min(m, na.rm=T) < min_rate[p]) min_rate[p] = min(m, na.rm=T)
        if (max(m, na.rm=T) > max_rate[p]) max_rate[p] = max(m, na.rm=T)
    }
    
    df_rate[[p]] = r_t
}


for (y in proc) {
   
    if (y == "e" || y == "w") {
        desc = paste0("r_", y, "(i,t)")
    }
    if (y == "b" || y == "d") {
        desc = paste0("r_", y, "(i,j,t)")
    }
    title <- ggdraw() +
      draw_label(desc, fontface = 'bold', x = 0, hjust = 0
      ) + theme( plot.margin = margin(0.5, 0.5, 0.5, 7) )
        
    plot_fn = paste0(base_plot_fn, ".process_", y, ".pdf")
    p_list = list()
    for (j in 1:num_ages) {
        x = df_rate[[y]][[j]]
        # convert to melted long format matrix
        m = melt(as.matrix(x))
        colnames(m) = c("region1", "region2", "value")
        m$region1 = factor(m$region1, ordered=T, levels=rev(regions))
        m$region2 = factor(m$region2, ordered=T, levels=regions)

        
        ylab = paste0("Epoch ", j) #, "\n", ages[j], " to ", ages[j+1],)
        
        # make plot
        p = ggplot(m, aes(x=region2, y=region1, fill=value))
        p = p + geom_tile(color="black")
        p = p + geom_text(aes(label = round(value, 2)))
        p = p + xlab(NULL) + ylab(ylab)
        p = p + theme_bw()
        if (y == "w" || y == "e") {
            p = p + theme(axis.text.y = element_blank(),
                          axis.ticks.y = element_blank())
        }
        p = p + theme(axis.line = element_blank(),
                      plot.background = element_blank(),
                      panel.grid.minor = element_blank(),
                      panel.grid.major = element_blank(),
                      panel.border = element_blank() )
        p = p + scale_fill_gradient(low=low_color, high=high_color, na.value=na_color,
            limits=c(min_rate[y], max_rate[y]))
        if (j == num_ages) {
            p_legend = cowplot::get_legend(p)
        }
        p = p + theme(legend.position="none")
        p_list[[ length(p_list)+1 ]] = p
    }
    # collect info about plot size
    if (y == "d" || y == "b") {
        h = num_ages * num_regions
    } else if (y == "w" || y == "e") {
        h = num_ages
    }

    p_fig = cowplot::plot_grid(plotlist=p_list, ncol=1)
    p_tit = cowplot::plot_grid(title, p_fig, ncol=1, rel_heights=c(0.1, h))
    p_all = cowplot::plot_grid(p_tit, p_legend, ncol=2, rel_widths=c(10,1))
    #p_all = p_all + ggtitle(desc)
    p_all = p_all + theme(plot.margin=margin(2,2,2,2))

    pdf(plot_fn, width=num_regions, height=h)
    print(p_all)
    dev.off()
    
}


if (FALSE) {
df_all = data.frame()
for (y in proc) {
    for (i in 1:num_ages) {
        d = dim(df_rate[[y]][[i]])
        for (j in 1:d[1]) {
            for (k in 1:d[2]) {
                dk = (k-3) * 0.05
                if (i != num_ages) {
                    row = c(y, ages[i]+dk, ages[i+1]+dk, regions[j], regions[k], df_rate[[y]][[i]][j,k], df_rate[[y]][[i+1]][j,k])
                } else {
                    row = c(y, ages[i]+dk, ages[i+1]+dk, regions[j], regions[k], df_rate[[y]][[i]][j,k], df_rate[[y]][[i]][j,k])
                }
                df_all = rbind(df_all, row)
            }
        }
    }
}
colnames(df_all) = c("process","age1","age2","region1","region2","rate1", "rate2")
df_all$rate1 = as.numeric(df_all$rate1)
df_all$rate2 = as.numeric(df_all$rate2)
df_all$age1 = as.numeric(df_all$age1)
df_all$age2 = as.numeric(df_all$age2)
#df_all$region1 = factor(df_all$region1, order=T, levels=regions)
#df_all$region2 = factor(df_all$region2, order=T, levels=regions)

df_w = df_all[ df_all$process == "w", ] # & df_all$region2 == "G", ]
df_e = df_all[ df_all$process == "e", ] # & df_all$region2 == "G", ]
df_div = df_w
df_div$rate1 = df_div$rate1 - df_e$rate1
df_div$rate2 = df_div$rate2 - df_e$rate2

pp = ggplot(df_w, aes(x=age1, xend=age2, color=region2, y=rate1, yend=rate1))
pp = pp + geom_segment()
pp = pp + geom_segment( aes(x=age2, xend=age2, color=region2, y=rate1, yend=rate2))
pp = pp + geom_point( aes(x=age2, y=rate1), size=1/2 )
pp = pp + geom_point( aes(x=age1, y=rate1), size=1/2 )
pp = pp + theme_bw()
pp = pp + xlab("Age (Ma)") + ylab("r_w(i,t) - r_e(i,t)")
pp = pp + ggtitle("Within-region net div. rates over time")
pp
}
