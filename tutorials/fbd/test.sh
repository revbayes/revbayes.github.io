sed -i.bak 's/generations=10000/generations=1/g' scripts/mcmc_CEFBDP_Specimens.Rev
${rb_exec} -b scripts/mcmc_CEFBDP_Specimens.Rev
res="$?"
mv scripts/mcmc_CEFBDP_Specimens.Rev.bak scripts/mcmc_CEFBDP_Specimens.Rev
rm -rf output
exit $res
