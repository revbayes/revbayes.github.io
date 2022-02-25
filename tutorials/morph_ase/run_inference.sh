#!/bin/bash


# diet 6
# mating_system 4
# terrestrially 2
# solitariness 2
# males 3
# habitat 2
# activity_period 2

#rb scripts/mcmc_ase_mk.Rev --args "diet" 6
#rb scripts/mcmc_ase_mk.Rev --args "mating_system" 4
#rb scripts/mcmc_ase_mk.Rev --args "terrestrially" 2
#rb scripts/mcmc_ase_mk.Rev --args "solitariness" 2
#rb scripts/mcmc_ase_mk.Rev --args "males" 3
#rb scripts/mcmc_ase_mk.Rev --args "habitat" 2
#rb scripts/mcmc_ase_mk.Rev --args "activity_period" 2

#rb scripts/mcmc_ase_freeK.Rev --args "diet" 6
#rb scripts/mcmc_ase_freeK.Rev --args "mating_system" 4
#rb scripts/mcmc_ase_freeK.Rev --args "terrestrially" 2
#rb scripts/mcmc_ase_freeK.Rev --args "solitariness" 2
#rb scripts/mcmc_ase_freeK.Rev --args "males" 3
#rb scripts/mcmc_ase_freeK.Rev --args "habitat" 2
#rb scripts/mcmc_ase_freeK.Rev --args "activity_period" 2

#rb scripts/mcmc_ase_freeK_RJ.Rev --args "diet" 6
#rb scripts/mcmc_ase_freeK_RJ.Rev --args "mating_system" 4
#rb scripts/mcmc_ase_freeK_RJ.Rev --args "terrestrially" 2
#rb scripts/mcmc_ase_freeK_RJ.Rev --args "solitariness" 2
#rb scripts/mcmc_ase_freeK_RJ.Rev --args "males" 3
#rb scripts/mcmc_ase_freeK_RJ.Rev --args "habitat" 2
#rb scripts/mcmc_ase_freeK_RJ.Rev --args "activity_period" 2

rb scripts/mcmc_ase_hrm.Rev --args "solitariness" 2 2
rb scripts/mcmc_ase_hrm.Rev --args "terrestrially" 2 2
rb scripts/mcmc_ase_hrm.Rev --args "habitat" 2 2
rb scripts/mcmc_ase_hrm.Rev --args "activity_period" 2 2
rb scripts/mcmc_ase_hrm.Rev --args "males" 3 2
rb scripts/mcmc_ase_hrm.Rev --args "mating_system" 4 2
rb scripts/mcmc_ase_hrm.Rev --args "diet" 6 2
