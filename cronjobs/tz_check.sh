#!/bin/bash
#
##  The script checks the shard size and inserts the data into metadb.   
defaults_file=/root/.monitor.cnf
DATE=$(date +"%A %m-%d-%y %H:%M")
path=/usr/local/bin/dba/
#receiver="iribak@zendesk.com"
email_body=${path}/tz_check.txt
receiver="iribak@zendesk.com, kwunnava@zendesk.com,  dbateam@zendesk.com"

/opt/rbenv/shims/ruby /data/zendesk_dba/current/flexmaster_support/bin/zd_cluster show --pods=all | awk '{ if ($2=="Master") print $3; else print $4 }' | grep -v "Host" | grep -v account > hostlist ; sed -i '/^$/d' hostlist


for host in `cat hostlist`
do
 check=`mysql --defaults-file=${defaults_file} -h${host} -Ns -e"select count(*) from mysql.time_zone"`
 if [ $check -eq 0 ] 
 then
   echo "Please check TZ tables on ${host}" | mail  -s  " Please check TZ tables on ${host} - $DATE" _body $receiver
 fi
done
rm $email_body
