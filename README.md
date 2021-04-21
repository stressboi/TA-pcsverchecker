# TA-pcsverchecker

Simple Splunk UF scanning script to harvest versions of Pulse Secure Connect appliances via curl. Refer to https://kb.pulsesecure.net/articles/Pulse_Security_Advisories/SA44784/.

History:

0.1: initial release

0.2: moved the input file of appliances to a lookup, thank you mnatkin@splunk.com!

This scripted input iterates through a local lookup of IP addresses (appliance_ips.csv) and sequentially pulls down the version information from each encountered Pulse Secure Connect appliance via curl. Please only include IP addresses of PCS appliances in the lookup.

This can be used on any Splunk Universal Forwarder running on a Linux server or endpoint. 

Simply drop it into the /etc/apps directory on a Universal Forwarder (or use deployment server or your favorite distribution method to get it there). By default it runs once an hour and outputs key/value pairs "pcs_version" and "dest_ip" to tell you what the version of that particular PCS appliance is. Use these versions to determine your next mitigation/workaround steps as described in the security advisory linked above.

21APR21

brodsky@splunk.com
