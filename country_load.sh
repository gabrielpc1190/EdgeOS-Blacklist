#!/bin/bash
sleep 60
#Set the country two digits code ALL-IN-CAPS
countryList="CR"
firewallGroupName=countries_allowed

#mkdir /config/user-data
function loadcountry () {
        firewallGroupName=$1
        country=$2

        logger -s "Downloading country definition for $country..."
        sudo curl -o /config/user-data/${country}.cidr.tmp http://www.iwik.org/ipcountry/${country}.cidr
        sudo tail -n +2 "/config/user-data/${country}.cidr.tmp" > "/config/user-data/${country}.cidr" && sudo rm "/config/user-data/${country}.cidr.tmp"
        logger -s "Adding rules to firewall group $firewallGroupName..."
        for rule in `cat /config/user-data/${country}.cidr`; do
            sudo ipset add $firewallGroupName $rule
        done
}

sudo ipset -F $firewallGroupName
for country in $countryList; do
        loadcountry $firewallGroupName $country
done
logger -s "country-load.sh has been executed"
