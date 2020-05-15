#!/usr/bin/env python3

import pandas as pd
import sys
from ete3 import Tree, TreeStyle, NodeStyle

file=sys.argv[1]
out=file.split('.')[0]+'_renamed.dnd'



def readTreesFromFile(file):
    try:
        f=open(file, 'r')
    except IOError:
        print ("Unknown file: "+file)
        sys.exit()

    trees = list()
    line = ""
    for l in f:
        t = Tree( l.strip())
        trees.append(t)
    f.close()
    return trees

trees = readTreesFromFile(file)


nameToNewName = dict()

index = 0
for leaf in trees[0].iter_leaves():
    nameToNewName[leaf.name] = "T_"+str(index)
    index = index + 1

for t in trees:
    for leaf in t.iter_leaves():
        leaf.name = nameToNewName[leaf.name]


with open(out, 'w') as fo:
    for t in trees:
        fo.write(t.write(format=1, dist_formatter='%0.6f') + "\n")
