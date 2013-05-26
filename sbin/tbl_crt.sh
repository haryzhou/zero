#!/bin/bash

cd $ZIXAPP_HOME/sql/table;

db2 connect to $DB_NAME user $DB_USER using $DB_PASS;
set current schema $DB_SCHEMA;
for file in `find -type f`; do
    db2 -tvf $file;
done

