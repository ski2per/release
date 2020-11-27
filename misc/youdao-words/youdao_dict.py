#!/usr/bin/env python3

import re

with open("ungrouped.txt", "r") as f:
    merged = []
    for line in f:
        m = re.match("^[0-9]+,(.+)\[.*", line)
        if m:
            word = m.group(1).strip()

            if len(merged) == 4:
                #print("\t\t\t".join(merged))
                print("{:<20}{:<20}{:<20}{:<20}".format(*merged))
                merged = []
            else:
                merged.append(word)


