#!/bin/sh
# Pulse Secure Version Grabber 
# 
# brodsky@splunk.com 
# 21 APR 2021

VERSION=0.2-SplunkUF
# 0.2 moves the text file to a lookup, thank you mnatkin@splunk.com

# set a date format so we can output a date for each line
DATETIME=$(date '+%Y-%m-%d %H:%M:%S %Z')

# what's the IP address of the machine?
IPADD=$(hostname -I)

# where is the list of PCS Appliance IPs?
IP_FILE="$SPLUNK_HOME/etc/apps/TA-pcsverchecker/lookups/appliance_ips.csv" # The file with the IP addresses
if [[ ! -f ${IP_FILE} ]]; then
   echo "No list of IP addresses found. Update the appliance_ips.csv lookup file for this app."
   exit 1
fi

for IP_ADDRESS in $(cat $IP_FILE); do
   OUTPUT1=$(curl -connect-timeout 1 --max-time 2 -s -k https://$IP_ADDRESS/dana-na/nc/nc_gina_ver.txt | grep ProductVersion | grep -v ALL_PARAMS | grep -v Download | sed -n 's/.*VALUE="\(.*\)">/\1/p')
   DATETIME=$(date '+%Y-%m-%d %H:%M:%S %Z')
   if [[ $OUTPUT1 =~ ^[0-9] ]]; then
        echo "$DATETIME src_ip=$IPADD dest_ip=$IP_ADDRESS pcs_version=$OUTPUT1"
   else
        echo "$DATETIME src_ip=$IPADD dest_ip=$IP_ADDRESS pcs_version='UNKNOWN OR NO CONNECTION'"
   fi 
done
