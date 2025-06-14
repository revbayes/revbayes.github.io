#!/usr/bin/env sh

# args
REGION_NAMES="GNKOMHZ"

# files
RATE_FN="./example_input/results/divtime_timefig"  # no file extension
PHY_FN="./example_input/results/divtime_timefig.tre"
ANC_FN="./example_input/results/divtime_timefig.states.txt"
MODEL_FN="./example_input/results/divtime_timefig.model.txt"
RANGE_FN="./example_input/kadua_data/kadua_range_n7.nex"
LABEL_FN="./example_input/kadua_data/kadua_range_label.csv"
AGE_FN="./example_input/hawaii_data/age_summary.csv"
FEAT_FN="./example_input/hawaii_data/feature_summary.csv"
DESC_FN="./example_input/hawaii_data/feature_description.csv"
MCC_FN="./output/out.mcc.tre"
ASE_FN="./output/out.states.tre"

# Verify input files
FILE_MISSING=0
for i in $PHY_FN $ANC_FN $MODEL_FN $RANGE_FN $LABEL_FN; do
    if [ ! -f $i ]; then
        echo "ERROR: ${i} not found"
        FILE_MISSING=1
    fi
done

if [ $FILE_MISSING == 1 ]; then
    echo "ERROR: exit due to missing files"
    exit
fi


# Create RevBayes summary tree files
#
# Example:
# > rb --args ./example_input/results/divtime_timefig.tre ./example_input/results/divtime_timefig.states.txt --file ./scripts/make_tree.rev
echo "Making tree files"
rb --args ${PHY_FN} ${ANC_FN} --file ./scripts/make_tree.Rev


# Plot MCC tree
#
# Example: 
# > Rscript ./scripts/plot_mcc_tree.R ./output/out.mcc.tre

echo "Making MCC tree plot"
Rscript ./scripts/plot_mcc_tree.R ${MCC_FN}


# Plot States tree
#
# Example:
# > Rscript ./scripts/plot_states_tree.R
#           ./output/out.states.tre
#           ./example_input/kadua_data/kadua_range_label.csv
#           GNKOMHZ

echo "Making ancestral state tree plot"
Rscript ./scripts/plot_states_tree.R ${ASE_FN} ${MCC_FN} ${LABEL_FN} ${REGION_NAMES}


# Plot range and region counts
#
# Example:
# > Rscript ./scripts/plot_range_counts.R
#           ./example_input/kadua_data/kadua_range_n7.nex
#           ./example_input/kadua_data/kadua_range_label.csv
#           GNKOMHZ

echo "Making species richness histogram plots"
Rscript ./scripts/plot_range_counts.R ${RANGE_FN} ${LABEL_FN} ${REGION_NAMES}


# Plot FIG param posteriors
#
# > Rscript ./scripts/plot_model_posterior.R \
#           ./example_input/results/divtime_timefig.model.txt \
#           ./example_input/hawaii_data/feature_summary.csv \
#           ./example_input/hawaii_data/feature_description.csv

echo "Making process parameter plots"
Rscript ./scripts/plot_model_posterior.R ${MODEL_FN} ${FEAT_FN} ${DESC_FN}


# Plot RJ prob effects
# 
# Example:
# > Rscript ./scripts/plot_rj_effects.R \
#           ./example_input/results/divtime_timefig.model.txt \
#           ./example_input/hawaii_data/feature_description.csv

echo "Making process parameter reversible-jump probability plots"
Rscript ./scripts/plot_rj_effects.R ${MODEL_FN} ${DESC_FN}


# Plot region features vs. time
#
# Example:
# > Rscript ./scripts/plot_features_vs_time_grid.R \
#           ./example_input/hawaii_data/feature_summary.csv \
#           ./example_input/hawaii_data/age_summary.csv \
#           ./example_input/hawaii_data/feature_description.csv \
#           GNKOMHZ

echo "Making feature vs. time plots"
Rscript ./scripts/plot_features_vs_time_grid.R ${FEAT_FN} ${AGE_FN} ${DESC_FN} ${REGION_NAMES}


# Plot region rates vs. time
#
# Example:
# > Rscript ./scripts/plot_rates_vs_time_grid.R \
#           ./example_input/results/divtime_timefig \
#           ./example_input/hawaii_data/feature_summary.csv \
#           ./example_input/hawaii_data/age_summary.csv \
#           ./example_input/hawaii_data/feature_description.csv \
#           GNKOMHZ

echo "Making rate vs. time plots"
Rscript ./scripts/plot_rates_vs_time_grid.R ${RATE_FN} ${FEAT_FN} ${AGE_FN} ${DESC_FN} ${REGION_NAMES}


# Plot rate-feature network
#
# Example:
# > Rscript ./scripts/plot_feature_rate_network.R \
#           ./example_input/results/divtime_timefig.model.txt \
#           ./example_input/hawaii_data/feature_description.csv

echo "Making feature vs. rate network plot"
Rscript ./scripts/plot_feature_rate_network.R ${MODEL_FN} ${DESC_FN}

# ... more plots ...
