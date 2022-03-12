#!/bin/sh

# Create temporary folder
mkdir -p ./tmp/
cd tmp

# Start Download Filter File

easylist=(
  "https://easylist-downloads.adblockplus.org/abp-filters-anti-cv.txt"
  "https://easylist-downloads.adblockplus.org/antiadblockfilters.txt"
  "https://easylist-downloads.adblockplus.org/easylistchina+easylistchina_compliance+easylist.txt"
  "https://raw.githubusercontent.com/banbendalao/ADgk/master/ADgk.txt"
  "https://raw.githubusercontent.com/banbendalao/ADgk/master/kill-baidu-ad.txt"
  "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/LegitimateURLShortener.txt"
  "https://raw.githubusercontent.com/xinggsf/Adblock-Plus-Rule/master/mv.txt"
  "https://raw.githubusercontent.com/Noyllopa/NoAppDownload/master/NoAppDownload.txt"
  "https://raw.githubusercontent.com/damengzhu/banad/main/jiekouAD.txt"
  "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/ClearURLs%20for%20uBo/clear_urls_uboified.txt"
  "https://raw.githubusercontent.com/o0HalfLife0o/list/master/ad-pc.txt"
  "https://raw.githubusercontent.com/o0HalfLife0o/list/master/ad-edentw.txt"
)

easylist_plus=(
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
)

adguard=(
  "https://filters.adtidy.org/android/filters/2_optimized.txt"
  "https://filters.adtidy.org/android/filters/11_optimized.txt"
  "https://filters.adtidy.org/android/filters/3_optimized.txt"
  "https://filters.adtidy.org/android/filters/224_optimized.txt"
  "https://filters.adtidy.org/android/filters/14_optimized.txt"
  "https://filters.adtidy.org/android/filters/5_optimized.txt"
  "https://filters.adtidy.org/android/filters/4_optimized.txt"
)

allow=(
  "https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt"
  "https://raw.githubusercontent.com/banbendalao/ADgk/master/ADgk.txt"
  "https://raw.githubusercontent.com/o0HalfLife0o/list/master/ad-pc.txt"
  "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/ChineseFilter/sections/whitelist.txt"
  "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/GermanFilter/sections/whitelist.txt"
  "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/TurkishFilter/sections/whitelist.txt"
  "https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/SpywareFilter/sections/whitelist.txt"
)

dns=(
  "https://easylist-downloads.adblockplus.org/abp-filters-anti-cv.txt"
  "https://easylist.to/easylist/fanboy-annoyance.txt"
  "https://raw.githubusercontent.com/reek/anti-adblock-killer/master/anti-adblock-killer-filters.txt"
  "https://raw.githubusercontent.com/cjx82630/cjxlist/master/cjx-annoyance.txt"
  "https://raw.githubusercontent.com/cjx82630/cjxlist/master/cjxlist.txt"
  "https://easylist-downloads.adblockplus.org/antiadblockfilters.txt"
  "https://easylist-downloads.adblockplus.org/easyprivacy.txt"
  "https://easylist-downloads.adblockplus.org/easylistchina+easylistchina_compliance+easylist.txt"
  "https://raw.githubusercontent.com/banbendalao/ADgk/master/ADgk.txt"
  "https://raw.githubusercontent.com/banbendalao/ADgk/master/kill-baidu-ad.txt"
  "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/LegitimateURLShortener.txt"
  "https://raw.githubusercontent.com/xinggsf/Adblock-Plus-Rule/master/mv.txt"
  "https://raw.githubusercontent.com/Noyllopa/NoAppDownload/master/NoAppDownload.txt"
  "https://raw.githubusercontent.com/damengzhu/banad/main/jiekouAD.txt"
  "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/ClearURLs%20for%20uBo/clear_urls_uboified.txt"
  "https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt"
  "https://raw.githubusercontent.com/o0HalfLife0o/list/master/ad-pc.txt"
  "https://adaway.org/hosts.txt"
)

hosts=(
  "https://adaway.org/hosts.txt"
)

ad_damain=(
  "https://raw.githubusercontent.com/damengzhu/banad/main/jiekouAD.txt"
)

allow_damain=(
  "https://raw.githubusercontent.com/privacy-protection-tools/dead-horse/master/anti-ad-white-list.txt"
)


for i in "${!easylist[@]}" "${!easylist_plus[@]}" "${!adguard[@]}" "${!allow[@]}" "${!hosts[@]}" "${!dns[@]}" "${!ad_damain[@]}"  "${!allow_damain[@]}"
do
  curl --parallel --parallel-immediate -k -L -C - -o "easylist${i}.txt" --connect-timeout 60 -s "${easylist[$i]}"
  curl --parallel --parallel-immediate -k -L -C - -o "plus-easylist${i}.txt" --connect-timeout 60 -s "${easylist_plus[$i]}"
  curl --parallel --parallel-immediate -k -L -C - -o "adguard${i}.txt" --connect-timeout 60 -s "${adguard[$i]}"
  curl --parallel --parallel-immediate -k -L -C - -o "allow${i}.txt" --connect-timeout 60 -s "${allow[$i]}"
  curl --parallel --parallel-immediate -k -L -C - -o "dns${i}.txt" --connect-timeout 60 -s "${dns[$i]}"
  curl --parallel --parallel-immediate -k -L -C - -o "hosts${i}.txt" --connect-timeout 60 -s "${hosts[$i]}"
  curl --parallel --parallel-immediate -k -L -C - -o "ad-damain${i}.txt" --connect-timeout 60 -s "${ad_damain[$i]}"
  curl --parallel --parallel-immediate -k -L -C - -o "allow-damain${i}.txt" --connect-timeout 60 -s "${allow_damain[$i]}"
  # shellcheck disable=SC2181
done

echo '规则下载完成'

# Pre Fix rules

cat hosts*.txt| grep -Ev '#|\$|@|!|/|\\|\*'| sed 's/127.0.0.1 //' | sed 's/0.0.0.0 //' |sed "s/^/||&/g" |sed "s/$/&^/g"| sed '/^$/d'| grep -v '^#' | grep -v 'local' | sort -n | uniq | awk '!a[$0]++' > abp-hosts.txt  #Hosts规则转ABP规则

cat allow-damain*.txt | sed "s/^/@@||&/g" | sed "s/$/&^/g" >> pre-allow.txt  #将允许域名转换为ABP规则

# Start Merge and Duplicate Removal

cat .././mod/rules/adblock-rules.txt easylist*.txt | grep -v '^!' | grep -v '^！' | grep -v '^# ' | grep -v '^# ' | grep -v '^\[' | grep -v '^\【' | grep -v 'local.adguard.org' | sort -n | uniq | awk '!a[$0]++' > tmp-adblock.txt #处理主规则
cat .././mod/rules/adblock-rules.txt plus-easylist*.txt | grep -v '^!' | grep -v '^！' | grep -v '^# ' | grep -v '^# ' | grep -v '^\[' | grep -v '^\【' | grep -v 'local.adguard.org' | sort -n | uniq | awk '!a[$0]++' > tmp-adblock+adguard.txt #处理Plus规则
cat adguard*.txt | grep -v '^!' | grep -v '^！' | grep -v '^# ' | grep -v '^# ' | grep -v '^\[' | grep -v '^\【' | sort -n | uniq | awk '!a[$0]++' > tmp-adguard.txt #处理AdGuard的规则
cat .././mod/rules/dns-rules.txt dns*.txt abp-hosts.txt | grep '^|\|^@' | grep -v './' | grep -v '.\$'|grep -Ev "([0-9]{1,3}.){3}[0-9]{1,3}" | grep -v '^!' | sort -n | uniq | awk '!a[$0]++' > tmp-dns.txt  #处理DNS规则
cat dns*.txt abp-hosts.txt | grep '^|' | grep -v '\*'| grep -v './'| grep -v '.\$'|grep -Ev "([0-9]{1,3}.){3}[0-9]{1,3}" |sed 's/||/0.0.0.0 /' | sed 's/\^//' | grep -v "^|" | sort -n | uniq | awk '!a[$0]++' > tmp-hosts.txt  #处理Hosts规则
cat tmp-hosts.txt | sed 's/0.0.0.0 //' | sort -n | uniq | awk '!a[$0]++' > tmp-ad-damain.txt #处理广告域名
cat *allow*.txt | grep '^@' | sort -n | uniq | awk '!a[$0]++' > tmp-allow.txt #允许清单处理

# Move to Pre Filter
cd ../
mkdir -p ./pre/
mv ./tmp/tmp-*.txt ./pre
cd ./pre

# Start Count Rules
adblock_num=`cat tmp-adblock.txt | wc -l`
adblock_plus_num=`cat tmp-adblock+adguard.txt | wc -l`
adguard_num=`cat tmp-adguard.txt | wc -l`
dns_num=`cat tmp-dns.txt | wc -l`
hosts_num=`cat tmp-hosts.txt | wc -l`
ad_damain_num=`cat tmp-ad-damain.txt | wc -l`
allow_num=`cat tmp-allow.txt | wc -l`

# Start Add title and date
echo "! Version: $(TZ=UTC-8 date +'%Y-%m-%d %H:%M:%S')（北京时间） " >> tpdate.txt
echo "! Total count: $adblock_num" >> adblock-tpdate.txt
echo "! Total count: $adblock_plus_num" >> adblock+adguard-tpdate.txt
echo "! Total count: $adguard_num" >> adguard-tpdate.txt
echo "! Total count: $dns_num" >> dns-tpdate.txt
echo "! Total count: $hosts_num" >> hosts-tpdate.txt
echo "! Total count: $allow_num" >> allow-tpdate.txt
echo "! Total count: $ad_damain_num" >> ad-damain-tpdate.txt

# Start Marge Rules
cat tpdate.txt adblock-tpdate.txt tmp-adblock.txt > adblock.txt
cat tpdate.txt adblock+adguard-tpdate.txt tmp-adblock.txt > adblock+adguard.txt
cat tpdate.txt adguard-tpdate.txt tmp-adguard.txt > adguard.txt
cat tpdate.txt dns-tpdate.txt tmp-dns.txt > dns.txt
cat tpdate.txt hosts-tpdate.txt tmp-hosts.txt > hosts.txt
cat tpdate.txt allow-tpdate.txt tmp-allow.txt > allow.txt
cat tpdate.txt ad-damain-tpdate.txt tmp-ad-damain.txt > ad-damain.txt
rm tmp*.txt *tpdate.txt

# Add Title
cd ../
diffFile="$(ls pre |sort -u)"
for i in $diffFile; do
 titleName=$(echo "$i" |sed 's#.txt#-title.txt#')
 cat ./mod/title/$titleName ./pre/$i > ./$i
 sed -i '/^$/d' $i
 echo "合并${i}的标题中"
done
echo '规则处理完成'
rm -rf tmp pre
exit
