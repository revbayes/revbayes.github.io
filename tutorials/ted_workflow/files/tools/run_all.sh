#!/bin/bash

# mcmc analyses
echo "running MCMC analyses"
mkdir -p logs/MCMC
rb headers/MCMC/epochal_Mk.Rev  > logs/MCMC/epochal_Mk.txt &
rb headers/MCMC/strict_Mk.Rev   > logs/MCMC/strict_Mk.txt &
rb headers/MCMC/UCE_Mk.Rev      > logs/MCMC/UCE_Mk.txt &
rb headers/MCMC/UCLN_Mk.Rev     > logs/MCMC/UCLN_Mk.txt &
rb headers/MCMC/UCLN_F81Mix.Rev > logs/MCMC/UCLN_F81Mix.txt;
wait;

# power posterior analyses
echo "running power-posterior analyses"
mkdir -p logs/PowerPosterior
rb headers/PowerPosterior/epochal_Mk.Rev  > logs/PowerPosterior/epochal_Mk.txt &
rb headers/PowerPosterior/strict_Mk.Rev   > logs/PowerPosterior/strict_Mk.txt &
rb headers/PowerPosterior/UCE_Mk.Rev      > logs/PowerPosterior/UCE_Mk.txt &
rb headers/PowerPosterior/UCLN_Mk.Rev     > logs/PowerPosterior/UCLN_Mk.txt &
rb headers/PowerPosterior/UCLN_F81Mix.Rev > logs/PowerPosterior/UCLN_F81Mix.txt;
wait;

# posterior-predictive analyses
echo "running posterior-predictive analyses"
mkdir -p logs/PPS
rb headers/PPS/epochal_Mk.Rev  > logs/PPS/epochal_Mk.txt &
rb headers/PPS/strict_Mk.Rev   > logs/PPS/strict_Mk.txt &
rb headers/PPS/UCE_Mk.Rev      > logs/PPS/UCE_Mk.txt &
rb headers/PPS/UCLN_Mk.Rev     > logs/PPS/UCLN_Mk.txt &
rb headers/PPS/UCLN_F81Mix.Rev > logs/PPS/UCLN_F81Mix.txt;s
wait;
