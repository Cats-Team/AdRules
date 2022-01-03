#!/bin/bash
cd script/allow/src

# Start Download
curl -o i1.txt https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt
curl -o i2.txt https://raw.githubusercontent.com/Potterli20/hosts/main/ad-allow.txt
curl -o i3.txt https://adaway.org/hosts.txt
curl -o i4.txt https://raw.githubusercontent.com/banbendalao/ADgk/master/ADgk.txt
curl -o i5.txt https://raw.githubusercontent.com/o0HalfLife0o/list/master/ad-pc.txt
curl -o i6.txt https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/ChineseFilter/sections/whitelist.txt
curl -o i7.txt https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/GermanFilter/sections/whitelist.txt 
curl -o i8.txt https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/TurkishFilter/sections/whitelist.txt 
curl -o i9.txt https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/SpywareFilter/sections/whitelist.txt
curl -o i10.txt https://trli.coding.net/p/file/d/allow/git/lfs/master/allow.txt

# Start Merge and Duplicate Removal
cat i*.txt > mergd.txt
cat mergd.txt | grep '^@' > allow.txt
cat allow.txt > tmpp.txt
sort -n tmpp.txt | uniq > tmp.txt


# Start Count Rules
num=`cat tmp.txt | wc -l`

# Start Add title and date
echo "! Title: Allowlist" >> tpdate.txt
echo "! Version: `date +"%Y-%m-%d %H:%M:%S"`" >> tpdate.txt
echo "! Total count: $num" >> tpdate.txt
cat tpdate.txt frules.dd tmp.txt > final.txt

mv final.txt ../../allow.txt
rm *.txt
cd ../../
exit
