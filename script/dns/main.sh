#!/bin/bash
cd script/dns/src

# Start Download
wget -O i1.txt https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt
wget -O i2.txt https://file.trli.club/dns/hosts.txt
wget -O i3.txt https://adaway.org/hosts.txt
wget -O i4.txt https://hblock.molinero.dev/hosts
wget -O i5.txt https://anti-ad.net/easylist.txt

# Start Merge and Duplicate Removal
cat i*.txt > mergd.txt
cat mergd.txt | grep ^|  > tmpp.txt
sort tmpp.txt | uniq > tmp.txt


# Start Count Rules
num=`cat tmp.txt | wc -l`

# Start Add title and date
echo "! Version: `date +"%Y-%m-%d %H:%M:%S"`" >> tpdate.txt
echo "! Total count: $num" >> tpdate.txt
cat title.dd tpdate.txt brules.dd tmp.txt > final.txt

mv final.txt ../../DNS.txt
rm *.txt
cd ../../
exit