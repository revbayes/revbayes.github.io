#!/usr/bin/env python3

import pandas as pd
import sys
from ete3 import Tree, TreeStyle, NodeStyle

file=sys.argv[1]
out=file.split('.')[0]+'_unrooted.dnd'



def readTreeFromFile(file):
    try:
        f=open(file, 'r')
    except IOError:
        print ("Unknown file: "+file)
        sys.exit()

    line = ""
    for l in f:
        line += l.strip()

    f.close()
    t = Tree( line )
    return t

t = readTreeFromFile(file)
t.unroot()
t.write(format=1, outfile=out)
