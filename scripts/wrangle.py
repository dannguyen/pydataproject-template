#!/usr/bin/env python

import csv
from datetime import date
from pathlib import Path
from sys import stderr

SRC_PATH = Path('data/fused/helloworld.csv')
DEST_PATH = Path('data/wrangled/helloworld.csv')

OUTPUT_HEADERS = ('source', 'last_name', 'first_name', 'current_age', 'birthdate', 'birthplace',)

def calc_age(datestr, now):
    """
    datestr: is a date string in iso8601 format
    now: is the reference date object
    Returns: integer representing age
    """
    dx = date.fromisoformat(datestr)
    age = now.year - dx.year

    return age if now.isoformat()[5:] >= datestr[5:] else age - 1



def fix_date(datestr):
    """datestr is a string in this format M/D/Y
       Returns: a string properly formatted as iso8601, i.e.  YYYY-MM-DD"""
    m, d, y = datestr.split("/")
    return '-'.join([y,
                     m.rjust(2, '0'),
                     d.rjust(2, '0'),])

def wrangle_data(srcpath):
    data = []
    today = date.today()
    for row in csv.DictReader(open(srcpath)):
        d = {}
        d['source'] = row['source']
        d['birthplace'] = row['birthplace']
        d['last_name'], d['first_name'] = row['full_name'].split(', ')
        d['birthdate'] = fix_date(row['birthdate'])
        d['current_age'] = calc_age(d['birthdate'], today)
        data.append(d)

    return data


def main():
    DEST_PATH.parent.mkdir(exist_ok=True, parents=True)
    with open(DEST_PATH, 'w') as w:
        outs = csv.DictWriter(w, fieldnames=OUTPUT_HEADERS)
        outs.writeheader()
        data = sorted(wrangle_data(SRC_PATH), key=lambda d: d['last_name'])
        outs.writerows(data)

    stderr.write(f"Wrangled {len(data)} rows from {SRC_PATH}\n")
    stderr.write(f"Wrote to {DEST_PATH}\n")


if __name__ == '__main__':
    main()
