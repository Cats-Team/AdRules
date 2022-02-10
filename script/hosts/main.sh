#!/bin/bash
cd script/hosts/src

# Start Download
curl -o i1.txt https://raw.githubusercontent.com/r-a-y/mobile-hosts/master/AdguardDNS.txt 
curl -o i2.txt https://raw.githubusercontent.com/r-a-y/mobile-hosts/master/AdguardMobileSpyware.txt
curl -o i3.txt https://adaway.org/hosts.txt
curl -o i4.txt https://raw.githubusercontent.com/r-a-y/mobile-hosts/master/AdguardApps.txt
curl -o i5.txt https://raw.githubusercontent.com/r-a-y/mobile-hosts/master/AdguardMobileAds.txt
#curl -o i6.txt https://raw.githubusercontent.com/badmojr/1Hosts/master/mini/hosts.txt
wget https://raw.githubusercontent.com/Cats-Team/AdRules/main/dns.txt
cat dns.txt | grep '^|' | grep -v '\*'| grep -Ev "([0-9]{1,3}.){3}[0-9]{1,3}" |sed 's/||/0.0.0.0 /' | sed 's/\^//' | grep -v "^|" > hosts.txt

# Start Merge and Duplicate Removal
cat i*.txt > mergd.txt
cat mergd.txt | grep '^1'  > 1.txt
cat mergd.txt | grep '^0'  > 0.txt
cat 1.txt 0.txt hosts.txt > tmpp.txt
cat tmpp.txt | sed 's/127.0.0.1 /0.0.0.0 /' >temp.txy
sort temp.txt | uniq > tmp.txt

# Create ad damian
cat tmp.txt | sed 's/0.0.0.0 //' > damian-init.txt

# Start Count Rules
num=`cat tmp.txt | wc -l`

# Start Add title and date
echo "# Version: `date +"%Y-%m-%d %H:%M:%S"`" >> tpdate.txt
echo "# Total count: $num" >> tpdate.txt
cat title.dd tpdate.txt tmp.txt > final.txt
cat damian-init.txt tpdate.txt >> damian.txt

mv final.txt ../../hosts.txt
mv damian.txt ../../../damian.txt
rm *.txt
cd ../../
exit
