#!/bin/bash
cd script/adblock/src

# Start Download
curl -o i1.txt https://raw.githubusercontent.com/o0HalfLife0o/list/master/ad-pc.txt
curl -o i2.txt https://raw.githubusercontent.com/o0HalfLife0o/list/master/ad-edentw.txt
curl -o i3.txt https://raw.githubusercontent.com/banbendalao/ADgk/master/ADgk.txt
curl -o i4.txt https://raw.githubusercontent.com/banbendalao/ADgk/master/kill-baidu-ad.txt
curl -o i5.txt https://raw.githubusercontent.com/xinggsf/Adblock-Plus-Rule/master/rule.txt
curl -o i6.txt https://raw.githubusercontent.com/uniartisan/adblock_list/master/adblock.txt
curl -o i7.txt https://raw.githubusercontent.com/uniartisan/adblock_list/master/adblock_lite.txt
#curl -o i9.txt https://raw.githubusercontent.com/uniartisan/adblock_list/master/adblock_plus.txt
curl -o i8.txt https://raw.githubusercontent.com/uniartisan/adblock_list/master/adblock_privacy.txt
curl -o i11.txt https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/annoyances.txt
curl -o i12.txt https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/badware.txt
#curl -o i13.txt https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters.txt
curl -o i14.txt https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/privacy.txt
curl -o i15.txt https://raw.githubusercontent.com/Noyllopa/NoAppDownload/master/NoAppDownload.txt
curl -o i16.txt https://raw.githubusercontent.com/damengzhu/banad/main/jiekouAD.txt

# Start Merge and Duplicate Removal
cat i*.txt > mergd.txt
cat mergd.txt | grep -v '^!' | grep -v '^！' | grep -v '^# ' | grep -v '^# ' | grep -v '^\[' | grep -v '^\【' > tmpp.txt
grep '$' user-rules.dd > u.dd #安卓设备请去除-v
sort -n tmpp.txt | uniq > tmp.txt


# Start Count Rules
num=`cat tmp.txt | wc -l`

# Start Add title and date
echo "! Version: $(TZ=UTC-8 date +'%Y-%m-%d %H:%M:%S')（北京时间） " >> tpdate.txt
echo "! Total count: $num" >> tpdate.txt
cat title.dd tpdate.txt u.dd tmp.txt > final.txt

mv final.txt ../../adblock.txt
rm *.txt
cd ../../
exit
