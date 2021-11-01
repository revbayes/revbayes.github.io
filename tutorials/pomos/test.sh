sed -i.bak 's/generations=10000/generations=1/g' scripts/mcmc_GTR_Gamma_Inv.Rev
${rb_exec} -b scripts/mcmc_GTR_Gamma_Inv.Rev
res="$?"
mv scripts/mcmc_GTR_Gamma_Inv.Rev.bak scripts/mcmc_GTR_Gamma_Inv.Rev
rm -rf output
exit $res
