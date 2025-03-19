

match_param_feature = function(df) {

    df_all = read.csv(mdl_fn, sep="\t", head=T)
    df_eff = df_all[ , grepl("(^phi)|(^sigma)", names(df_all))]
    
    
    param_node = names(df_eff)
    param_desc = c()
    for (i in 1:length(param_node)) {
        
        z = gsub("\\.", "_", param_node[i])
        tok = strsplit(z, split="_")[[1]]
        
        typ = ifelse(tok[1] == "phi", "quantitative", "categorical")
        rel = ifelse(tok[2] %in% c("e", "w"), "within", "between")
        idx = as.numeric(tok[3])
        
        
        y = c(idx, rel, typ, tok[1], tok[2], param_node[i])
        print(y)
        
        param_desc = rbind(param_desc, y)
    }
    
}