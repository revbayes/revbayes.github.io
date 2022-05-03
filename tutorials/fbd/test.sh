sed -i.bak 's/generations=10000/generations=1/g' scripts/mcmc_CEFBDP.Rev
${rb_exec} -b scripts/mcmc_CEFBDP.Rev
res="$?"
mv scripts/mcmc_CEFBDP.Rev.bak scripts/mcmc_CEFBDP.Rev
rm -rf output
exit $res
