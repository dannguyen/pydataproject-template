#!/usr/bin/env python

import csv
from pathlib import Path
from sys import stderr

SRC_DIR = Path('data/collected')
DEST_PATH = Path('data/compiled/helloworld.csv')

RENAMED_HEADERS = ('full_name', 'birthdate', 'birthplace',)
OUTPUT_HEADERS = ('source', 'full_name', 'birthdate', 'birthplace',)

def gather_data(srcpath):
    """returns list of dicts"""
    data = []
    with open(srcpath) as src:
        records = list(csv.reader(open(srcpath), delimiter="\t"))

    for row in records[1:]:
        # basically, renaming the headers
        d = {key: row[i] for i, key in enumerate(RENAMED_HEADERS)}
        d['source'] = srcpath.stem
        data.append(d)

    return data


def main():
    DEST_PATH.parent.mkdir(exist_ok=True, parents=True)
    with open(DEST_PATH, 'w') as w:
        outs = csv.DictWriter(w, fieldnames=OUTPUT_HEADERS)
        outs.writeheader()
        for src in sorted(SRC_DIR.glob('*.txt')):
            data = gather_data(src)
            outs.writerows(data)

            stderr.write(f"compiled {len(data)} rows from {src}\n")

    stderr.write(f"Wrote to {DEST_PATH}\n")

if __name__ == '__main__':
    main()
