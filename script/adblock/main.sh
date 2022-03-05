#!/bin/bash
cd script/adblock/src

# Start Download
curl -o i1.txt https://raw.githubusercontent.com/hacamer/Adblist/master/ad-pc.txt
curl -o i3.txt https://raw.githubusercontent.com/banbendalao/ADgk/master/ADgk.txt
curl -o i4.txt https://raw.githubusercontent.com/banbendalao/ADgk/master/kill-baidu-ad.txt
curl -o i5.txt https://raw.githubusercontent.com/DandelionSprout/adfilt/master/LegitimateURLShortener.txt
wget -O i6.txt https://easylist-downloads.adblockplus.org/easylistchina+easylistchina_compliance+easylist.txt
#curl -o i6.txt https://raw.githubusercontent.com/uniartisan/adblock_list/master/adblock.txt
#curl -o i7.txt https://raw.githubusercontent.com/uniartisan/adblock_list/master/adblock_lite.txt
#curl -o i9.txt https://raw.githubusercontent.com/uniartisan/adblock_list/master/adblock_plus.txt
#curl -o i8.txt https://raw.githubusercontent.com/uniartisan/adblock_list/master/adblock_privacy.txt
#curl -o i11.txt https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/annoyances.txt
#curl -o i12.txt https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/badware.txt
#curl -o i13.txt https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters.txt
#curl -o i14.txt https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/privacy.txt
curl -o i15.txt https://raw.githubusercontent.com/Noyllopa/NoAppDownload/master/NoAppDownload.txt
curl -o i16.txt https://raw.githubusercontent.com/damengzhu/banad/main/jiekouAD.txt
curl -o i17.txt https://raw.githubusercontent.com/DandelionSprout/adfilt/master/ClearURLs%20for%20uBo/clear_urls_uboified.txt

# Start Merge and Duplicate Removal
cat i*.txt user-rules.dd > mergd.txt
cat mergd.txt | grep -v '^!' | grep -v '^！' | grep -v '^# ' | grep -v '^# ' | grep -v '^\[' | grep -v '^\【' | grep -v 'local.adguard.org' > tmpp.txt
sort -n tmpp.txt | uniq > tmmp.txt

# Remove Error Rules
cat tmmp.txt err-rules.dd > ttmp.txt 
sort -n ttmp.txt | uniq -u > tmp.txt

# Start Count Rules
num=`cat tmp.txt | wc -l`

# Start Add title and date
echo "! Version: $(TZ=UTC-8 date +'%Y-%m-%d %H:%M:%S')（北京时间） " >> tpdate.txt
echo "! Total count: $num" >> tpdate.txt
cat title.dd tpdate.txt tmp.txt > final.txt

mv final.txt ../../adblock.txt
rm *.txt
cd ../../
exit
