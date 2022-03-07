#!/bin/bash
cd script/dns/src
#cd ./src
# Start Download
easylist=(
  "https://easylist-downloads.adblockplus.org/abp-filters-anti-cv.txt"
  "https://raw.githubusercontent.com/cjx82630/cjxlist/master/cjx-annoyance.txt"
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
)

for i in "${!easylist[@]}"
do
  echo "开始下载 easylist${i}..."
  curl -o "easylist${i}.txt" --connect-timeout 60 -s "${easylist[$i]}"
  # shellcheck disable=SC2181
  fi
done

## Other filter
curl -o i1.txt https://adaway.org/hosts.txt
wget https://raw.githubusercontent.com/damengzhu/banad/main/jiekouAD.txt

# Start Merge and Duplicate Removal
cat i*.txt easy*.txt > mergd.txt
cat mergd.txt | grep '^||' | grep -v './' | grep -Ev "([0-9]{1,3}.){3}[0-9]{1,3}" | grep -v '.\$' | sed '/^$/d' > adblock0.txt 
cat mergd.txt | grep '^@@||' | grep -v './' | grep -v '.\$' > adblock1.txt
cat adblock*.txt > adblock.txt #abp规则处理合并
cat mergd.txt | grep '^[0-9]' | grep -v '^#' | grep -v 'local'> host.txt #hosts规则处理
cat host.txt | sed 's/127.0.0.1 /||/' | sed 's/0.0.0.0 /||/' | sed "s/$/&^/g" | sed '/^$/d' > hosts.txt #hosts转abp规则
cat jiekouAD.txt | grep -Ev '#|\$|@|!|/|\\|\*'| sed "s/^/||&/g" |sed "s/$/&^/g" >> damian.txt #大萌主规则处理
cat adblock.txt hosts.txt brules.dd damian.txt > new.txt
cat new.txt | grep '|\|@' | grep -v '.#' | grep -v '.?' | grep -v '.=' | grep -v '.]'| grep -v '^!' | grep -v 'local' | grep -v '/' | grep -v '\^|' | grep -v '\^\*'| sed '/^$/d' > tmpp.txt
sort -n tmpp.txt | uniq > tmmp.txt

# Remove Error Rules
cat tmmp.txt errdamian.dd > ttmp.txt 
sort -n ttmp.txt | uniq -u > tmp.txt

# Start Count Rules
num=`cat tmp.txt | wc -l`

# Start Add title and date
echo "! Version: $(TZ=UTC-8 date +'%Y-%m-%d %H:%M:%S')（北京时间） " >> tpdate.txt
echo "! Total count: $num" >> tpdate.txt
cat title.dd tpdate.txt tmp.txt > final.txt

mv final.txt ../../dns.txt
rm *.txt
cd ../../
exit
