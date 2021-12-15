#!/bin/bash
#cd script/dns/src
cd ./src
# Start Download
curl -o i1.txt https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt
curl -o i4.txt https://raw.githubusercontent.com/jdlingyu/ad-wars/master/hosts
curl -o i5.txt https://raw.githubusercontent.com/badmojr/1Hosts/master/mini/adblock.txt
curl -o i6.txt https://raw.githubusercontent.com/xinggsf/Adblock-Plus-Rule/master/rule.txt
curl -o i7.txt https://raw.githubusercontent.com/o0HalfLife0o/list/master/ad-pc.txt
curl -o i8.txt https://raw.githubusercontent.com/o0HalfLife0o/list/master/ad-edentw.txt
curl -o i9.txt https://raw.githubusercontent.com/banbendalao/ADgk/master/ADgk.txt

# Start Merge and Duplicate Removal
cat i*.txt > mergd.txt
cat mergd.txt | grep '^|' | grep -v './' | grep -v '.\$' > block.txt
cat mergd.txt | grep '^@' | grep -v './' | grep -v '.\$' > allow.txt
cat block.txt allow.txt > tmpp.txt
sort -n tmpp.txt | uniq > tmp.txt


# Start Count Rules
num=`cat tmp.txt | wc -l`

# Start Add title and date
echo "! Version: `date +"%Y-%m-%d %H:%M:%S"`" >> tpdate.txt
echo "! Total count: $num" >> tpdate.txt
cat title.dd tpdate.txt tmp.txt > final.txt

mv final.txt ../../dns.txt
rm *.txt
cd ../../
exit
