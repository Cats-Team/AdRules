#!/bin/bash
cd AdKillRules/src

# Start Download
wget -O i1.txt https://raw.githubusercontent.com/o0HalfLife0o/list/master/ad-pc.txt
wget -O i2.txt https://raw.githubusercontent.com/o0HalfLife0o/list/master/ad-edentw.txt
wget -O i3.txt https://raw.githubusercontent.com/banbendalao/ADgk/master/ADgk.txt
#wget -O i4.txt https://file.trli.club/dns/hosts.txt
wget -O i5.txt https://raw.githubusercontent.com/banbendalao/ADgk/master/kill-baidu-ad.txt
wget -O i6.txt https://raw.githubusercontent.com/xinggsf/Adblock-Plus-Rule/master/rule.txt
wget -O i7.txt https://raw.githubusercontent.com/uniartisan/adblock_list/master/adblock.txt
wget -O i8.txt https://raw.githubusercontent.com/uniartisan/adblock_list/master/adblock_lite.txt
#wget -O i9.txt https://raw.githubusercontent.com/uniartisan/adblock_list/master/adblock_plus.txt
wget -O i10.txt https://raw.githubusercontent.com/uniartisan/adblock_list/master/adblock_privacy.txt
#wget -O i11.txt https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/annoyances.txt
#wget -O i12.txt https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/badware.txt
#wget -O i13.txt https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters.txt
#wget -O i14.txt https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/privacy.txt
wget -O i15.txt https://raw.githubusercontent.com/Noyllopa/NoAppDownload/master/NoAppDownload.txt


# Start Merge and Duplicate Removal
cat i*.txt > mergd.txt
cat mergd.txt | grep -v '^!' | grep -v '^！' | grep -v '^# ' | grep -v '^# ' | grep -v '^\[' | grep -v '^\【' > tmpp.txt
sort tmpp.txt | uniq > tmp.txt


# Start Count Rules
num=`cat tmp.txt | wc -l`

# Start Add title and date
echo "! Version: `date +"%Y-%m-%d %H:%M:%S"`" >> tpdate.txt
echo "! Total count: $num" >> tpdate.txt
cat title.dd tpdate.txt tmp.txt > final.txt

mv final.txt ../../../adblock.txt
rm *.txt
cd ../../
exit
