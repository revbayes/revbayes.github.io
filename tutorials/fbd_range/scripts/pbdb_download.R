
# Function to download PBDB occurrence data written by Joe O'Reilly (Univeristy of Bristol)
occurr.get = function(base_name){
  
  # Make the URL
  url <- paste0( "https://paleobiodb.org/data1.2/occs/list.txt?base_name=", base_name, "&show=class&taxon_status=valid")
  
  # Download it
  print(paste0("Downloading Data For ... ", base_name))
  curl::curl_download(url = url, destfile = "occ_temp.csv")
  pbdb <- read.csv("occ_temp.csv", header = TRUE, stringsAsFactors = FALSE)
  file.remove("occ_temp.csv")
  
  #pbdb <- pbdb[, c("accepted_name", "min_ma", "max_ma", "phylum", "class", "order", "family", "genus", "reference_no")]
  #pbdb$accepted_name <- gsub(pbdb$accepted_name, pattern=" ", replacement = "_") # replace spaces in species names with underscores
  
  return(pbdb)
}

######

# download occurrences
pbdb = occurr.get(base_name = "dinosauria")

# only retain records older than the Cenozoic
pbdb = pbdb[which(pbdb$min_ma >= 66),]

# eliminate anything only dated at the period level
pbdb = pbdb[which(pbdb$early_interval != "Cretaceous" 
           & pbdb$early_interval != "Jurassic"
           & pbdb$early_interval != "Triassic"),]

# only retain specimens with < 10 Myr uncertainty
unc = 5
pbdb = pbdb[which(pbdb$max_ma - pbdb$min_ma <= unc),]

# only retain specimens known at the species level
pbdb = pbdb[which(pbdb$accepted_rank == "species"),]

#### manipulate output for revbayes analysis

# group together interval names
# note you could do this for "late interval" and elimate entries with early != late, but there don't appear to be any entries like this

pbdb$early_interval[grepl("Triassic", pbdb$early_interval)]      = "Triassic"
pbdb$early_interval[grepl("Jurassic", pbdb$early_interval)]      = "Jurassic"

pbdb$early_interval[grepl("Anisian", pbdb$early_interval)]       = "Triassic"
pbdb$early_interval[grepl("Ladinian", pbdb$early_interval)]      = "Triassic"
pbdb$early_interval[grepl("Carnian", pbdb$early_interval)]       = "Triassic"
pbdb$early_interval[grepl("Tuvalian", pbdb$early_interval)]      = "Triassic"
pbdb$early_interval[grepl("Norian", pbdb$early_interval)]        = "Triassic"
pbdb$early_interval[grepl("Lacian", pbdb$early_interval)]        = "Triassic"
pbdb$early_interval[grepl("Alaunian", pbdb$early_interval)]      = "Triassic"
pbdb$early_interval[grepl("Rhaetian", pbdb$early_interval)]      = "Triassic"

pbdb$early_interval[grepl("Hettangian", pbdb$early_interval)]    = "Jurassic"
pbdb$early_interval[grepl("Sinemurian", pbdb$early_interval)]    = "Jurassic"
pbdb$early_interval[grepl("Pliensbachian", pbdb$early_interval)] = "Jurassic"
pbdb$early_interval[grepl("Toarcian", pbdb$early_interval)]      = "Jurassic"
pbdb$early_interval[grepl("Tenuicostatum", pbdb$early_interval)] = "Jurassic"
pbdb$early_interval[grepl("Aalenian", pbdb$early_interval)]      = "Jurassic"
pbdb$early_interval[grepl("Bajocian", pbdb$early_interval)]      = "Jurassic"
pbdb$early_interval[grepl("Bathonian", pbdb$early_interval)]     = "Jurassic"
pbdb$early_interval[grepl("Callovian", pbdb$early_interval)]     = "Jurassic"
pbdb$early_interval[grepl("Oxfordian", pbdb$early_interval)]     = "Jurassic"
pbdb$early_interval[grepl("Kimmeridgian", pbdb$early_interval)]  = "Jurassic"
pbdb$early_interval[grepl("Tithonian", pbdb$early_interval)]     = "Jurassic"

pbdb$early_interval[grepl("Berriasian", pbdb$early_interval)]    = "Early Cretaceous"
pbdb$early_interval[grepl("Valanginian", pbdb$early_interval)]   = "Early Cretaceous"
pbdb$early_interval[grepl("Hauterivian", pbdb$early_interval)]   = "Early Cretaceous"
pbdb$early_interval[grepl("Barremian", pbdb$early_interval)]     = "Early Cretaceous"
pbdb$early_interval[grepl("Aptian", pbdb$early_interval)]        = "Early Cretaceous"
pbdb$early_interval[grepl("Albian", pbdb$early_interval)]        = "Early Cretaceous"
pbdb$early_interval[grepl("Neocomian", pbdb$early_interval)]     = "Early Cretaceous"

pbdb$early_interval[grepl("Cenomanian", pbdb$early_interval)]    = "Late Cretaceous"
pbdb$early_interval[grepl("Turonian", pbdb$early_interval)]      = "Late Cretaceous"
pbdb$early_interval[grepl("Coniacian", pbdb$early_interval)]     = "Late Cretaceous"
pbdb$early_interval[grepl("Santonian", pbdb$early_interval)]     = "Late Cretaceous"
pbdb$early_interval[grepl("Campanian", pbdb$early_interval)]     = "Late Cretaceous"
pbdb$early_interval[grepl("Judithian", pbdb$early_interval)]     = "Late Cretaceous"
pbdb$early_interval[grepl("Maastrichtian", pbdb$early_interval)] = "Late Cretaceous"
pbdb$early_interval[grepl("Lancian", pbdb$early_interval)]       = "Late Cretaceous"
pbdb$early_interval[grepl("Senonian", pbdb$early_interval)]      = "Late Cretaceous"
pbdb$early_interval[grepl("Edmontonian", pbdb$early_interval)]   = "Late Cretaceous"

# assign a fixed specimen age based on median interval age & rescale the timeline to the present
pbdb$fixed_age = ((pbdb$max_ma - pbdb$min_ma)/2) + pbdb$min_ma - 66 #pbdb$fixed_age = runif(1, pbdb$min_ma, pbdb$max_ma)

#hist(pbdb$fixed_age)

#### parse output for revbayes

# define stages
stages = data.frame(stage = c("Late Cretaceous", "Early Cretaceous", "Jurassic", "Triassic"),
                    max = c(100, 145, 201, 252) - 66,
                    min = c(66, 100, 145, 201) - 66)

#### ranomly sub sample species

length(unique(pbdb$accepted_name))

set.seed(116)

sample = c()

for(i in unique(pbdb$accepted_name)){

  if(runif(1) > 0.18) next
  else sample = c(sample, i)
  
}

length(sample)

#### create rev input files

file1 = "dinosaur_ranges.tsv"
file2 = "dinosaur_fossil_counts.tsv"

cat("taxon", "\t", "min", "\t", "max", "\n", sep = "", file = file1, append = FALSE)

cat("taxon", "\t", "Late_Cre", "\t", "Early_Cre", "\t", "Jur", "\t", "Tri", "\n", sep = "", file = file2, append = FALSE)

for(i in sample){
  
  tmp = pbdb[which(pbdb$accepted_name == as.character(i)),]
  
  name = gsub(" ", "_", i)
  name = gsub("\\(", "", name)
  name = gsub("\\)", "", name)
  
  # ranges file
  cat(name, "\t", min(tmp$fixed_age), "\t", max(tmp$fixed_age), "\n", sep = "", file = file1, append = TRUE)
  
  # fossil count file
  cat(name, "\t", file = file2, append = TRUE)

  for(j in stages$stage){
    tmp2 = which(tmp$early_interval == j)
    if(length(tmp2) > 0) count = length(tmp2)
    else count = 0
    if(j == "Triassic")
      cat(count, "\n", file = file2, append = TRUE)
    else
      cat(count, "\t", file = file2, append = TRUE)
  }
  
}

