sed -i.bak 's/generations=20000/generations=1/g' scripts/MCMC_dating_ex2.Rev
${rb_exec} -b scripts/MCMC_dating_ex2.Rev
res="$?"
mv scripts/MCMC_dating_ex2.Rev.bak scripts/MCMC_dating_ex2.Rev
rm -rf output
exit $res
