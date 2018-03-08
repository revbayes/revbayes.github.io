#!/usr/bin/env python
import sys
import bibtexparser
from bibtexparser.bwriter import BibTexWriter

filename = sys.argv[1]
citations = sys.argv[2]

with open(citations) as f:
    content = f.readlines()

content = [x.strip() for x in content] 

with open(filename) as bibtex_file:
    bibliography = bibtexparser.load(bibtex_file)

writer = BibTexWriter()
writer.indent = '    '     # indent entries with 4 spaces instead of one

entries = []

for i,entry in enumerate(bibliography.entries):
	if entry["ID"] in content:
		entries.append(entry)

print(len(bibliography.entries))
bibliography.entries = entries
print(len(entries))
print(writer.write(bibliography))
