#!/bin/env ksh

## The script is to generate the tnsnames.ora which is used on Oracle client/server 
## It depend on the config file - default: ora.lst
## The ora.lst file content example:
##    <TNS Description>,<Oracle server IP/HOST/DNS>,<Oracle SID>,[Oracle Port:default 1521]
##  e.g.  tst1,testdb1,test,1521  
##        tst2,192.168.1.1,tst,1522


PN=$(basename $0)
PP=$(dirname $0)
TNS_CONFIG=$PP/ora.lst
TNS_FILE=$PP/tnsnames.ora

if [ ! -f $TNS_CONFIG ]; then
  echo "File $TNS_CONFIG not found. exit"
  exit 1
fi

if [ -f $TNS_FILE ]; then
  echo "Backup the $TNS_FILE"
  mv $TNS_FILE $TNS_FILE.$(date +%s)
fi

echo -e "## tnsnames.ora built from $PN on $(date '+%Y/%m/%d %H:%M:%S')\n" >$TNS_FILE

IFS_ORG=$IFS
IFS=,
while read TNS HOST SID PORT
do
  ## Not set PORT, use the default port 1521
  [ -n $PORT] && PORT=1521
  
  echo "## TNS for $TNS from $HOST with SID=$SID" >> $TNS_FILE
  echo "$TNS =" >> $TNS_FILE
  echo "(DESCRIPTION = " >> $TNS_FILE
  echo "  (ADDRESS_LIST = " >> $TNS_FILE
  echo "    (ADDRESS = (PROTOCOL = TCP)(HOST = ${HOST} ) (PORT = $PORT ))" >>$TNS_FILE
  echo "  ) " >>$TNS_FILE
  echo "  (CONNECT_DATA = " >> $TNS_FILE
  echo "   (SID = $SID )" >> $TNS_FILE
  echo "   (SERVER = DEDICATED) " >> $TNS_FILE
  echo "   )" >> $TNS_FILE
  echo -e ")\n" >> $TNS_FILE
done < $TNS_CONFIG

IFS=IFS_ORG

echo "## tnsnames.ora built finished on $(date '+%Y/%m/%d %H:%M:%S')" >> $TNS_FILE

