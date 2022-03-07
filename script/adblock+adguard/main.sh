#!/bin/bash
set LC_ALL='C'
cd script/adblock+adguard/src

# Start Download
echo "更新Full"
easylist=(
"https://raw.githubusercontent.com/o0HalfLife0o/list/master/ad-pc.txt"
"https://raw.githubusercontent.com/o0HalfLife0o/list/master/ad-edentw.txt"
"https://raw.githubusercontent.com/banbendalao/ADgk/master/ADgk.txt"
"https://raw.githubusercontent.com/banbendalao/ADgk/master/kill-baidu-ad.txt"
"https://raw.githubusercontent.com/xinggsf/Adblock-Plus-Rule/master/rule.txt"
"https://raw.githubusercontent.com/uniartisan/adblock_list/master/adblock.txt"
"https://raw.githubusercontent.com/uniartisan/adblock_list/master/adblock_lite.txt"
"https://raw.githubusercontent.com/uniartisan/adblock_list/master/adblock_plus.txt"
"https://raw.githubusercontent.com/uniartisan/adblock_list/master/adblock_privacy.txt"
"https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/annoyances.txt"
"https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/badware.txt"
"https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters.txt"
"https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/privacy.txt"
"https://raw.githubusercontent.com/Noyllopa/NoAppDownload/master/NoAppDownload.txt"
"https://raw.githubusercontent.com/damengzhu/banad/main/jiekouAD.txt"
"https://filters.adtidy.org/android/filters/2.txt"
"https://filters.adtidy.org/android/filters/11.txt"
"https://filters.adtidy.org/android/filters/3.txt"
"https://filters.adtidy.org/android/filters/224.txt"
"https://filters.adtidy.org/android/filters/14.txt"
"https://filters.adtidy.org/android/filters/5.txt"
"https://filters.adtidy.org/android/filters/4.txt"
"https://raw.githubusercontent.com/Cats-Team/AdRule/main/url-filter.txt"
"https://raw.githubusercontent.com/Cats-Team/AdRule/main/rules-admin.txt"
"https://raw.githubusercontent.com/Cats-Team/AdRules/main/script/adblock/src/user-rules.dd"
)

for i in "${!easylist[@]}"
do
  echo "开始下载 easylist${i}..."
  curl -o "easylist${i}.txt" --connect-timeout 60 -s "${easylist[$i]}"
  # shellcheck disable=SC2181
done
# Start Merge and Duplicate Removal
cat i*.txt > mergd.txt
cat mergd.txt | grep -v '^!' | grep -v '^！' | grep -v '^# ' | grep -v '^# ' | grep -v '^\[' | grep -v '^\【' > tmpp.txt
sort -n tmpp.txt | uniq > tmmp.txt
awk '!a[$0]++' tmmp.txt > tmp.txt



# Start Count Rules
num=`cat tmp.txt | wc -l`

# Start Add title and date
echo "! Version: `date +"%Y-%m-%d %H:%M:%S"`" >> tpdate.txt
echo "! Total count: $num" >> tpdate.txt
cat title.dd tpdate.txt tmp.txt > final.txt
echo "更新完毕"
mv final.txt ../../adblock+adguard.txt
rm *.txt
cd ../../
exit
