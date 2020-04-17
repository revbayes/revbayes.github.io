sed -i.bak 's/generations=10000/generations=1/g' scripts/mcmc_CEFBDP_Specimens.Rev
${rb_exec} -b scripts/mcmc_CEFBDP_Specimens.Rev
if [ ! -d "output" ]; then
     exit 1
fi
