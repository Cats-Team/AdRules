#!/bin/bash
cd script/allow/src

# Start Download
echo "开始更新Allowlist"
wget -q -O i1.txt https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt
wget -q -O i2.txt https://raw.githubusercontent.com/Potterli20/hosts/main/ad-allow.txt
wget -q -O i3.txt https://adaway.org/hosts.txt
wget -q -O i4.txt https://raw.githubusercontent.com/banbendalao/ADgk/master/ADgk.txt
wget -q -O i5.txt https://raw.githubusercontent.com/o0HalfLife0o/list/master/ad-pc.txt
wget -q -O i6.txt https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/ChineseFilter/sections/whitelist.txt
wget -q -O i7.txt https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/GermanFilter/sections/whitelist.txt 
wget -q -O i8.txt https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/TurkishFilter/sections/whitelist.txt 
wget -q -O i9.txt https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/SpywareFilter/sections/whitelist.txt
wget -q -O damianlist1.txt https://raw.githubusercontent.com/privacy-protection-tools/dead-horse/master/anti-ad-white-list.txt

# Start Merge and Duplicate Removal
cat damianlist*.txt | sed "s/^/@@||&/g" |sed "s/$/&^/g" >> iw.txt
cat i*.txt > mergd.txt
cat mergd.txt | grep '^@' > allow.txt
cat allow.txt > tmpp.txt
sort -n tmpp.txt | uniq > tmp.txt
echo "开始处理规则"
# Start Count Rules
num=`cat tmp.txt | wc -l`

# Start Add title and date
echo "! Title: Allowlist" >> tpdate.txt
echo "! Version: $(TZ=UTC-8 date +'%Y-%m-%d %H:%M:%S')（北京时间） " >> tpdate.txt
echo "! Total count: $num" >> tpdate.txt
cat tpdate.txt frules.dd tmp.txt > final.txt
echo "规则处理完毕"
mv final.txt ../../allow.txt
rm *.txt
cd ../../
exit
