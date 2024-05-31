# libraries
library(ape)

# arguments
cmd_str = "Rscript ./scripts/plot_range_counts.R ./example_input/kadua_data/kadua_range_n7.nex ./example_input/kadua_data/kadua_range_label.csv GNKOMHZ"
args = commandArgs(trailingOnly = T)
if ( length(args) != 3 ) {
    stop_str = paste0("Invalid arguments. Correct usage:\n> ", cmd_str, "\n")
    stop(stop_str)
}
range_fn        = args[1]                                   # ex: "./example_input/kadua_data/kadua_range_n7.nex"
label_fn        = args[2]                                   # ex: "./example_input/kadua_data/kadua_range_label.csv"
region_names    = args[3]                                   # ex: "GNKOMHZ"

# filesystem
plot_fp = "./output/"
plot_region_fn = paste0(plot_fp, "plot_region_histogram.pdf")
plot_range_fn  = paste0(plot_fp, "plot_range_histogram.pdf")
tbl_region_fn  = paste0(plot_fp, "dat_region_histogram.csv")
tbl_range_fn   = paste0(plot_fp, "dat_range_histogram.csv")

# function
bits2regions = function(x) {
    paste(region_names[as.logical(x)], collapse="") 
}

# read range file
dat_ranges  = read.nexus.data(range_fn)
dat_ranges  = lapply(dat_ranges, as.numeric)
df_ranges   = t(data.frame(dat_ranges))
num_regions = ncol(df_ranges)
if (nchar(region_names) == num_regions) {
    region_names = unlist(strsplit(region_names, ""))
} else {
    region_names = LETTERS[1:num_regions]
}
colnames(df_ranges) = region_names

# get label order
df_labels = read.csv(label_fn, sep=",", colClasses=c("character","character"))

# get ranges as sets
df_sets = apply(df_ranges, 1, bits2regions)

# get counts of range-sets
tbl_ranges = table(df_sets)
names_tbl_ranges = names(tbl_ranges)

# reorder range table
ordered_bits = df_labels$range
ordered_ranges = sapply(ordered_bits, function(x) { 
    y = as.numeric(unlist(strsplit(x,"")[[1]]))
    return(bits2regions(y))
})
match_ranges = ordered_ranges[sort(match(names_tbl_ranges, ordered_ranges ))]
tbl_ranges = tbl_ranges[match_ranges]

# get counts of regions
tbl_regions = colSums(df_ranges) 

# write region count table and barplot
fmt_ranges = data.frame(names=names(tbl_ranges), counts=as.vector(tbl_ranges))
write.csv(fmt_ranges, file=tbl_range_fn, quote=F, row.names=F)
pdf(plot_range_fn, height=7, width=7)
barplot(fmt_ranges$counts, names=fmt_ranges$names, xlab="Range", ylab="Count", las=2)
dev.off()

# write range count table and barplot
fmt_regions = data.frame(names=names(tbl_regions), counts=as.vector(tbl_regions))
write.csv(fmt_regions, file=tbl_region_fn, quote=F, row.names=F)
pdf(plot_region_fn, height=7, width=7)
barplot(fmt_regions$counts, names=fmt_regions$names, xlab="Region", ylab="Count", las=2)
dev.off()

