# libraries
library(ggplot2)

# arguments
my_args = commandArgs(trailingOnly=T)

feature_fn = "./input/hawaii_data/feature_summary.csv"
age_fn = "./input/hawaii_data/age_summary.csv"
region_names = "GNKOMHZ"

if (length(my_args) == 3) {
    feature_fn = my_args[1]
    age_fn = my_args[2]
    region_names = my_args[3]
}

# read input
df_feature = read.csv(feature_fn, sep=",", header=T)
df_age = read.csv(age_fn, sep=",", header=T)

regions = strsplit(region_names, "")[[1]]
num_regions = length(regions)

ages = c(0, df_age$mean_age)
num_ages = length(ages)

#print( df_feature[, c("feature_index","feature_relationship","feature_type")] )

col_names = c("feature_index", "feature_relationship", "feature_type")
feature_sets = df_feature[ !duplicated( df_feature[, col_names] ), col_names ]

for (i in 1:nrow(feature_sets)) {
    idx = feature_sets[i,1]
    rel = feature_sets[i,2]
    typ = feature_sets[i,3]

    row_idx = (df_feature$feature_index==idx & df_feature$feature_relationship==rel & df_feature$feature_type == typ)
    time_fn = df_feature$feature_path[row_idx]
    plot_fn = paste0("./output/out_line.feat_vs_time.idx_",idx,".rel_",rel,".typ_",typ,".pdf")

    if (rel == "within") {

        m = matrix( nrow=num_ages, ncol=num_regions )
        for (i in 1:num_ages) {
            x = unlist(read.csv(time_fn[i], sep=",", header=T))
            x[is.nan(x)] = NA
            m[i,] = x
        }

        pdf(plot_fn)
        plot(NA, NA, xlim=c(0, max(ages)), ylim=c(0,max(m, na.rm=T)), xlab="age", ylab="feature")
        dx = max(ages) / 200
        for (i in 1:num_regions) {
            idx0 = (num_ages-1):1
            idx1 = num_ages:2
            x0 = ages[idx0]
            x1 = ages[idx1]
            y0 = m[idx1,i]
            y1 = m[idx1,i]
            segments(x0=ages[idx0]+dx, x1=ages[idx1]-dx, y0=m[idx0,i], y1=m[idx0,i], col=i)
            segments(x0=ages[idx1]-dx, x1=ages[idx1]+dx, y0=m[idx0,i], y1=m[idx1,i], col=i)
        }

        if (typ == "quantitative") {
            lines(ages, rep(mean(m,na.rm=T), num_ages), lty=2, col=8)
        }
        for (i in 1:num_regions) {
            na_idx = which(!is.na(m[,i]))
            j = na_idx[length(na_idx)]
            k = min(c(j+1, num_regions))
            print(na_idx)
            print(j)
            points( ages[k]+dx, m[j,i], col=i)
        }

        legend("topright", legend=c(regions, "mean"), col=c(1:8), lwd=2)
        dev.off()
    }
}
