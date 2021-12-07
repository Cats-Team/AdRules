#!/bin/bash
cd script/hosts/src

# Start Download
curl -o i1.txt https://raw.githubusercontent.com/r-a-y/mobile-hosts/master/AdguardDNS.txt 
curl -o i2.txt https://raw.githubusercontent.com/r-a-y/mobile-hosts/master/AdguardMobileSpyware.txt
curl -o i3.txt https://adaway.org/hosts.txt
curl -o i4.txt https://raw.githubusercontent.com/r-a-y/mobile-hosts/master/AdguardApps.txt
curl -o i5.txt https://raw.githubusercontent.com/r-a-y/mobile-hosts/master/AdguardMobileAds.txt
curl -o i6.txt https://raw.githubusercontent.com/badmojr/1Hosts/master/mini/hosts.txt

# Start Merge and Duplicate Removal
cat i*.txt > mergd.txt
cat mergd.txt | grep '^1'  > 1.txt
cat mergd.txt | grep '^0'  > 0.txt
cat 1.txt 0.txt > tmpp.txt
sort tmpp.txt | uniq > tmp.txt


# Start Count Rules
num=`cat tmp.txt | wc -l`

# Start Add title and date
echo "! Version: `date +"%Y-%m-%d %H:%M:%S"`" >> tpdate.txt
echo "! Total count: $num" >> tpdate.txt
cat title.dd tpdate.txt tmp.txt > final.txt

mv final.txt ../../hosts.txt
rm *.txt
cd ../../
exit
