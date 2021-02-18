#!/usr/bin/env python3

import pandas as pd
import sys
from ete3 import Tree, TreeStyle, NodeStyle

fn = sys.argv[1]
out = fn.split('.')[0]+'_renamed.dnd'


def read_trees_from_file(file_name):
    with open(file_name) as file_object:
        trs = list()
        for line in file_object:
            tree = Tree(line.strip())
            trs.append(tree)
        return trs


trees = read_trees_from_file(fn)


nameToNewName = dict()

INDEX = 0
for leaf in trees[0].iter_leaves():
    nameToNewName[leaf.name] = "T" + str(INDEX)
    INDEX += 1

for t in trees:
    for leaf in t.iter_leaves():
        leaf.name = nameToNewName[leaf.name]

with open(out, 'w') as fo:
    for t in trees:
        fo.write(t.write(format=1, dist_formatter='%0.6f') + "\n")
