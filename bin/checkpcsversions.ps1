# Pulse Secure Version Grabber 
# UF Version (Windows)
# brodsky@splunk.com 
# 22 APR 2021

#VERSION=0.1-SplunkUF-WINDOWS

$MYNAME = [System.Net.Dns]::GetHostName()
try
{
	$inputfile=Get-Content "C:\Program Files\SplunkUniversalForwarder\etc\apps\TA-pcsverchecker\lookups\appliance_ips.csv" -ErrorAction Stop
}
catch
{
	echo "No list of IP addresses found. Update the appliance_ips.csv lookup file for this app."
}
foreach($line in $inputfile)
{
       $timevar = Get-Date -UFormat "%Y-%m-%d %H:%M:%S %Z"
	   $curloutput = Invoke-Webrequest -UseBasicParsing -URI https://$line/dana-na/nc/nc_gina_ver.txt
	   if($?){
			
			$splitoutput = $curloutput.Content -split "`n"
			foreach($item in $splitoutput)
			{
				if ($item -like '*"ProductVersion"*')
				{
					$versionstring=select-string "VALUE=`"(.*)`"" -inputobject $item
					$version = $versionstring.matches.groups[1].value
					echo "$timevar src_ip=$MYNAME dest_ip=$line pcs_version=$VERSION"
				}
			}
		} else {
		
		echo "$timevar src_ip=$MYNAME dest_ip=$line pcs_version='UNKNOWN OR NO CONNECTION'"
		}
}