#!/bin/bash
cd ./src

# Start Download
curl -o i1.txt https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt
curl -o i2.txt https://raw.githubusercontent.com/Potterli20/hosts/main/ad-allow.txt
curl -o i3.txt https://adaway.org/hosts.txt
curl -o i4.txt https://raw.githubusercontent.com/banbendalao/ADgk/master/ADgk.txt
curl -o i5.txt https://raw.githubusercontent.com/o0HalfLife0o/list/master/ad-pc.txt
curl -o 16.txt https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/ChineseFilter/sections/whitelist.txt
curl -o i7.txt https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/GermanFilter/sections/whitelist.txt 
curl -o i8.txt https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/TurkishFilter/sections/whitelist.txt 
curl -o i9.txt https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/SpywareFilter/sections/whitelist.txt

# Start Merge and Duplicate Removal
cat i*.txt > mergd.txt
cat mergd.txt | grep '^@' > allow.txt
cat allow.txt > tmpp.txt
sort -n tmpp.txt | uniq > tmp.txt


# Start Count Rules
num=`cat tmp.txt | wc -l`

# Start Add title and date
echo "! Version: `date +"%Y-%m-%d %H:%M:%S"`" >> tpdate.txt
echo "! Total count: $num" >> tpdate.txt
cat frules.dd tpdate.txt tmp.txt > final.txt

mv final.txt ../../../allow.txt
rm *.txt
cd ../../
exit