#!/bin/bash
cd script/adguard/src

# Start Download
echo "开始更新AdRules（For AdGuard）"
adguard=(
  "https://filters.adtidy.org/android/filters/2_optimized.txt"
  "https://filters.adtidy.org/android/filters/11_optimized.txt"
  "https://filters.adtidy.org/android/filters/3_optimized.txt"
  "https://filters.adtidy.org/android/filters/224_optimized.txt"
  "https://filters.adtidy.org/android/filters/14_optimized.txt"
  "https://filters.adtidy.org/android/filters/5_optimized.txt"
  "https://filters.adtidy.org/android/filters/4_optimized.txt"
)

for i in "${!adguard[@]}"
do
  echo "开始下载 easylist${i}..."
  curl -o "easylist${i}.txt" --connect-timeout 60 -s "${adguard[$i]}"
  # shellcheck disable=SC2181
done

# Start Merge and Duplicate Removal
cat easy*.txt | grep -v '^!' | grep -v '^！' | grep -v '^# ' | grep -v '^# ' | grep -v '^\[' | grep -v '^\【' |sort -n | uniq | awk '!a[$0]++'> tmp.txt
echo "开始处理规则"

# Start Count Rules
num=`cat tmp.txt | wc -l`

# Start Add title and date
echo "! Version: $(TZ=UTC-8 date +'%Y-%m-%d %H:%M:%S')（北京时间） " >> tpdate.txt
echo "! Total count: $num" >> tpdate.txt
cat title.dd tpdate.txt tmp.txt > final.txt
echo "规则处理完毕"
mv final.txt ../../adguard.txt
rm *.txt
cd ../../
exit
