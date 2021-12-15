#!/usr/bin/env python3

# This script takes an ultrametric tree as input and changes its branch lengths by traversing it.
# The starting rate is 1.0 and then with some rate it is changed along the branches.
# There are two types of rate changes:
# - minor change, with a high rate
# - major change, with a low rate

from ete3 import Tree, TreeStyle, NodeStyle
import numpy.random as npr
import pandas as pd
import sys

def scaleBranch ( list_of_rates, list_of_times ):
    new_length = 0.0
    for i in range (1, len(list_of_times)):
        new_length += list_of_rates[i-1] * (list_of_times[i]-list_of_times[i-1])
    return new_length


###########################################
###########################################
################### MAIN ##################
###########################################
###########################################

# Example use:
# python alterBranchLengths.py example.tree 0.5 0.01 5 0.3 example_changed.tree n


if (len(sys.argv) < 7):
    print("\n\tUsage: python alterBranchLengths.py example.tree 0.5 0.01 5 0.3 0.01 example_changed.tree y \n")
    print("\tWith example.tree a Newick tree file,")
    print("\t0.5 the scale (1/rate) of small changes,")
    print("\t0.01 the variance of the lognormal multipliers for small changes,")
    print("\t5 the scale (1/rate) of big changes,")
    print("\t0.3 the variance of the lognormal multipliers for big changes,")
    print("\t0.01 the minimum allowed branch length,")
    print("\texample_changed.tree the output tree file,")
    print("\ty whether the probability of a rate change should be proportional to the branch length (y by default).\n\n")
    exit(-1)


treefile=sys.argv[1] # ultrametric tree
rate_small = float(sys.argv[2]) # scale parameter of small changes
multiplier_small = float(sys.argv[3]) # variance of lognormal distribution from which are drawn small rate multipliers
rate_big = float(sys.argv[4]) # scale parameter of large changes
multiplier_big = float(sys.argv[5]) # variance of lognormal distribution from which are drawn large rate multipliers
minimum_value = float(sys.argv[6]) #minimum allowed branch length
outputfile = sys.argv[7] # output file
if len(sys.argv)>8:
    prop=sys.argv[8] # whether the probability of a rate change should be proportional to the branch length (y by default)

try:
    f=open(treefile, 'r')
except IOError:
    print ("Unknown file: ", treefile)
    sys.exit()

line = ""
for l in f:
    line = line + l
f.close()

# Starting ultrametric tree
ultra_tree = Tree(line, format=0 )

use_bl = True
if prop=="n":
    use_bl = False

rates=dict()
rates[ultra_tree.get_tree_root()] = 1.0

number_of_small_changes_per_branch = dict()
number_of_big_changes_per_branch = dict()


average_dist = 0.0
n_branches = 0
for n in ultra_tree.traverse(strategy= "preorder"):
    if n != ultra_tree.get_tree_root():
        d = n.dist
        average_dist += d
        n_branches += 1

average_dist = average_dist/n_branches

for n in ultra_tree.traverse(strategy= "preorder"):
    if n != ultra_tree.get_tree_root():
        d = 1.0
        normalizing_factor = 1.0
        if use_bl:
            d = n.dist
            normalizing_factor = 1.0
        else:
            d = average_dist
            normalizing_factor = n.dist / average_dist
        event_time = 0.0
        list_of_rates = list()
        list_of_times = list()
        list_of_rates.append(rates[n.up])
        list_of_times.append(0.0)
        latest = 0.0
        rate_multiplier = 1.0
        number_of_small_changes_per_branch[n]=0
        number_of_big_changes_per_branch[n]=0
        while event_time < d:
            t_small = npr.exponential(scale=rate_small)
            t_big = npr.exponential(scale=rate_big)
            if t_small < t_big:
                event_time = latest + t_small
                rate_multiplier = npr.lognormal(mean=0, sigma=multiplier_small)
                #print(rate_multiplier)
                number_of_small_changes_per_branch[n]+=1
            else :
                event_time = latest + t_big
                rate_multiplier = npr.lognormal(mean=0, sigma=multiplier_big)
                number_of_big_changes_per_branch[n]+=1
            if event_time < d:
                list_of_times.append(event_time * normalizing_factor)
                latest_rate = list_of_rates[-1]
                list_of_rates.append(latest_rate * rate_multiplier)
            latest = event_time
        list_of_times.append(d* normalizing_factor)
        # We've generated all the change points along the branch, let's scale the branch accordingly.
        new_branch_length = scaleBranch (list_of_rates, list_of_times)
        print("Number of small changes on branch of length "+str(n.dist)+" : " + str(number_of_small_changes_per_branch[n]))
        print("Number of big changes on branch of length "+str(n.dist)+" : " + str(number_of_big_changes_per_branch[n]))
        print("\t\tOld vs new distance: " + str(n.dist) + " <-> " + str(new_branch_length) + "\n")
        n.dist = new_branch_length
        # Let's set the rate for the current node
        rates[n] = list_of_rates[-1]


# Additional tree traversal: we do not want branch lengths under some value.
# We also compute statistics on the branches
blAfter=list()
for n in ultra_tree.traverse(strategy= "preorder"):
    if n.is_root():
        pass
    else:
        if n.dist < minimum_value:
            n.dist = minimum_value
        blAfter.append(n.dist)

blAfterDF = pd.DataFrame (blAfter, columns=["blAfter"])
print(blAfterDF.describe())

# Saving the non-ultrametric tree
ultra_tree.write(format=5, outfile=outputfile)
