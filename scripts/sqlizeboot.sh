#!/bin/sh

DB_NAME=$1
SRC_DIR=$2

mkdir -p $(dirname $DB_NAME)

echo ""
find ${SRC_DIR} -name *.csv | while read -r fname; do
  tblname=$(basename $fname '.csv');
  sqlite3 ${DB_NAME} <<SQL_HERE
.bail on
.mode csv
.import ${fname} ${tblname}
.mode column
SELECT 'table "${tblname}" has ' || COUNT(1) || ' rows, imported from: ${fname}'
FROM ${tblname};
SQL_HERE

done

echo "--- Open database with this command:"
echo ""
echo "      " open ${DB_NAME}
