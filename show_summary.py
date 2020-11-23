#!/usr/bin/env python3
import csv
import sys
with open(sys.argv[1]) as fh:
    summary = csv.DictReader(fh)
    for row in summary:
        for key, value in row.items():
            print("%30s : %20s" % (key, value))
