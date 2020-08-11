#!/bin/bash
#Set the country two digits code ALL-IN-CAPS
countryList="US"
firewallGroupName=countries_allowed

#mkdir /config/user-data
function loadcountry () {
        firewallGroupName=$1
        country=$2

        echo "Downloading country definition for $country..." >> /var/log/country-load
        curl -o /config/user-data/${country}.cidr http://www.iwik.org/ipcountry/${country}.cidr
        echo "Adding rules to firewall group $firewallGroupName..." >> /var/log/country-load
        for rule in `cat /config/user-data/${country}.cidr`; do
                ipset add $firewallGroupName $rule
        done
}

ipset -F $firewallGroupName
for country in $countryList; do
        loadcountry $firewallGroupName $country
done
