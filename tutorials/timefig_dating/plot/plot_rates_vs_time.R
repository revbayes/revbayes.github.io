# libraries
library(ggplot2)
library(reshape2)
#library(patchwork)
library(cowplot)
# library(rjson)
library(data.table)


# arguments
my_args = commandArgs(trailingOnly=T)

feature_fn = "./input/hawaii_data/feature_summary.csv"
age_fn = "./input/hawaii_data/age_summary.csv"
desc_fn = "./input/hawaii_data/feature_description.csv"
res_fn = "./input/results/Kadua_crash_M1_777"
json_fn = "./input/results/Kadua_M1_100.param.json"
region_names = "GNKOMHZ"

if (length(my_args) == 4) {
    feature_fn = my_args[1]
    age_fn = my_args[2]
    desc_fn = my_args[3]
    region_names = my_args[4]
}

# settings
low_color = "#eeeeff"
high_color = "#4444ff"
na_color = "#cccccc"

# read input
df_feature = read.csv(feature_fn, sep=",", header=T)
df_age = read.csv(age_fn, sep=",", header=T)
df_desc = read.csv(desc_fn, sep=",", header=T)


# files
res_fp = "./input/results"
res_prefix = "Kadua_crash_M1_777"
res_pattern = paste0(res_prefix, ".time.*")
files = list.files(path=res_fp, pattern=res_pattern, full.names=T)

regions = strsplit(region_names, "")[[1]]
ages = c(0, df_age$mean_age, Inf)
num_regions = length(regions)
num_ages = length(df_age$mean_age) + 1

# 
# json_all = readLines(json_fn)

proc = c("d", "e", "w", "b")
f_burn = 0.1
n_burn = NA # as.integer(f_burn * (length(json_all)-1)) + 1
thin_by = 10
# 
# 
# # process JSON for iteration
# for (i in n_burn:length(json_all)) {
# 
#     # thin
#     if (i %% 10 != 0) {
#         next
#     }
#     
#     # get sample for iteration
#     json_it = json_all[i]
#     x_it = fromJSON(json_it)
#     
#     for (p in proc) {
#         rho = x_it[[ paste0("rho_", p) ]]
#         m = x_it[[ paste0("m_", p) ]]
#         
#     }
# 
# }


# json2row = function(x) {
#     num_ages = length(x)
#     num_regions = length(x[[1]])
#     
#     df = x
#     
#     for (i in 1:length(x)) {
#         for (j in 1:length(x[[1]])) {
#             for (k in 1:length(x[[1]][[1]])) {
#                 
#             }
#         }
#     }
# }

# 
# 
# 
# collect posterior traces
df_time = list()
for (i in 1:length(files)) {
    df = read.csv(files[i], header=T, sep="\t")

    if (is.na(n_burn)) {
        n_burn = as.integer(f_burn * nrow(df))
    }

    df = df[(n_burn+1):nrow(df), ]
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
    
    desc = paste0("r_", y, "(t)")
    title <- ggdraw() +
      draw_label(desc, fontface = 'bold', x = 0, hjust = 0
      ) + theme( plot.margin = margin(0.5, 0.5, 0.5, 7) )
        
    plot_fn = paste0("./output/rate_vs_time_process_", y, ".pdf")
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


# 
#         # desc = paste0("r_", p, "(t)")
#         # title <- ggdraw() + 
#         #   draw_label(desc, fontface = 'bold', x = 0, hjust = 0
#         #   ) + theme( plot.margin = margin(0.5, 0.5, 0.5, 7) )
#         #     # add margin on the left of the drawing canvas,
#         #     # so title is aligned with left edge of first plot
#         # 
#         # p_list = list()
#         # min_val = Inf
#         # max_val = -Inf
# 
# 
# for (i in 1:nrow(feature_sets)) {
#    
# 
#     for (j in 1:num_ages) {
#         
#         # read feature_set
#         x = read.csv(time_fn[j], sep=",", header=T)
#         if (nrow(x) == ncol(x)) {
#             rownames(x) = colnames(x)
#         }
#         for (k in 1:ncol(x)) {
#             x[is.nan(x[,k]),k] = NA
#         }
#         
#         # plot inf
#         min_val = min(c(min_val,min(x, na.rm=T)))
#         max_val = max(c(max_val,max(x, na.rm=T)))
#         zlim = c(min_val, max_val)
#        
#         ylab = paste0("Epoch ", j) #, "\n", ages[j], " to ", ages[j+1],)
#             
#         # convert to melted long format matrix
#         m = melt(as.matrix(x))
#         colnames(m) = c("region1", "region2", "value")
#         m$region1 = factor(m$region1, ordered=T, levels=rev(regions))
#         m$region2 = factor(m$region2, ordered=T, levels=regions)
# 
#         # make plot
#         p = ggplot(m, aes(x=region2, y=region1, fill=value))
#         p = p + geom_tile(color="black")
#         p = p + geom_text(aes(label = round(value, 1)))
#         p = p + xlab(NULL) + ylab(ylab)
#         p = p + theme_bw()
#         if (rel == "within") {
#             p = p + theme(axis.text.y = element_blank(),
#                           axis.ticks.y = element_blank())
#         }
#         p = p + theme(axis.line = element_blank(),
#                       plot.background = element_blank(),
#                       panel.grid.minor = element_blank(),
#                       panel.grid.major = element_blank(),
#                       panel.border = element_blank() )
#         p = p + scale_fill_gradient(low=low_color, high=high_color, na.value=na_color, limits=zlim)
#         if (j == num_ages) {
#             p_legend = cowplot::get_legend(p)
#         }
#         p = p + theme(legend.position="none")
#         p_list[[ length(p_list)+1 ]] = p
#     }
#     
#     # collect info about plot size
#     if (rel == "between") {
#         h = num_ages * num_regions
#     } else if (rel == "within") {
#         h = num_ages
#     }
#     
#     p_fig = cowplot::plot_grid(plotlist=p_list, ncol=1)
#     p_tit = cowplot::plot_grid(title, p_fig, ncol=1, rel_heights=c(0.1, h))
#     p_all = cowplot::plot_grid(p_tit, p_legend, ncol=2, rel_widths=c(10,1))
#     #p_all = p_all + ggtitle(desc)
#     p_all = p_all + theme(plot.margin=margin(2,2,2,2))
# 
#     pdf(plot_fn, width=num_regions, h)
#     print(p_all)
#     dev.off()
# 
# }
