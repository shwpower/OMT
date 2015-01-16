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
  ## Not set PORT, use the default port 1521
  [ -n $PORT] && PORT=1521
  
  echo "## TNS for $DNS" >> $TNS_FILE
  echo "$DNS=" >> $TNS_FILE
  echo "(DESCRIPTION = " >> $TNS_FILE
  echo "  (CONNECT_DATA =" >> $TNS_FILE
  echo "   (SID = $SID )" >> $TNS_FILE
  echo "   (SERVER = DEDICATED) " >> $TNS_FILE
  echo "   )" >> $TNS_FILE
  echo -e ")\n" >> $TNS_FILE
done < $TNS_FILE

echo "## tnsnames.ora built finished on $(date '+%Y/%m/%d %H:%M:%S')" >> $TNS_FILE

  


