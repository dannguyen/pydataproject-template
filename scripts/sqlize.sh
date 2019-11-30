#!/bin/sh

DB_NAME=$1
SRC_DIR=$2
PREFIX=$3

mkdir -p $(dirname $DB_NAME)

echo ""
find ${SRC_DIR} -name *.csv | while read -r fname; do
    stem=$(basename $fname '.csv')
    if [  -z "${PREFIX}" ]; then
        tblname=${stem}
    else
        tblname=${PREFIX}_${stem};
    fi
    sqlite3 ${DB_NAME} <<SQL_HERE
.bail on
.mode csv
.import ${fname} ${tblname}
.mode column
SELECT 'table "${tblname}" has ' || COUNT(1) || ' rows, imported from: ${fname}'
FROM ${tblname};
SQL_HERE

done

