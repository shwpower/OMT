#!/bin/env ksh

## The script is to generate the tnsnames.ora which is used on Oracle client/server 
## It depend on the config file - default: ora.lst
## The ora.lst file content example:
##    <Oracle server IP/DNS> <Oracle SID> [Oracle Port:default 1521]
##  e.g.  testdb1 test  
##        testdb2 tst 1522


PN=$(basename $0)
PP=$(dirname $0)
TNS_CONFIg=$PP/ora.lst
TNS_FILE=$PP/tnsnames.ora

if [ ! -f $TNS_CONFIG ]; then
  echo "$TNS_CONFIG not found. exit"
  exit 1
fi

if [ -f $TNS_FILE ]; then
  echo "Backup the $TNS_FILE"
  mv $TNS_FILE $TNS_FILE.$(date +%s)
fi

echo "## tnsnames.ora built from $PN on $(date '+%Y/%m/%d %H:%M:%S')" >$TNS_FILE

while read DNS SID PORT
do
  if [ -n $DNS -o -n $SID ]; then
    
  


