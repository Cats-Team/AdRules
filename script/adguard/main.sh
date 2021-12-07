#!/bin/bash
cd script/adguard/src

# Start Download
curl -o i1.txt https://filters.adtidy.org/android/filters/2_optimized.txt
curl -o i2.txt https://filters.adtidy.org/android/filters/11_optimized.txt
curl -o i3.txt https://filters.adtidy.org/android/filters/3_optimized.txt
curl -o i4.txt https://filters.adtidy.org/android/filters/224_optimized.txt
curl -o i5.txt https://filters.adtidy.org/android/filters/14_optimized.txt
curl -o i6.txt https://filters.adtidy.org/android/filters/5_optimized.txt
curl -o i7.txt https://filters.adtidy.org/android/filters/4_optimized.txt

# Start Merge and Duplicate Removal
cat i*.txt > mergd.txt
cat mergd.txt | grep -v '^!' | grep -v '^！' | grep -v '^# ' | grep -v '^# ' | grep -v '^\[' | grep -v '^\【' > tmpp.txt
sort tmpp.txt | uniq > tmp.txt
sort -n tmp.txt > tmmp.txt


# Start Count Rules
num=`cat tmmp.txt | wc -l`

# Start Add title and date
echo "[Adblock Plus 2.0]
! Title: AdRules (For AdGuard)
! Homepage: https://github.com/Cats-Team/AdRules
! Powerd by CatsTeam
! Expires: 12 Hours
! Description: 该规则合并自AdGuard广告过滤器，AdGuard移动设备过滤器，AdGuard隐私保护过滤器，AdGuardURL跟踪保护器，AdGuard社交过滤器，AdGuard烦人过滤器，AdGuard中文过滤器，AdGuard实验过滤器
" >> title.txt
echo "! Version: `date +"%Y-%m-%d %H:%M:%S"`" >> tpdate.txt
echo "! Total count: $num" >> tpdate.txt
cat title.dd tpdate.txt tmmp.txt > final.txt

mv final.txt ../../../adguard.txt
rm *.txt
cd ../../
exit