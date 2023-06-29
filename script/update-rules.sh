#!/bin/sh
LC_ALL='C'
AA="Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_3_2 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8H7 Safari/6533.18.5 Quark/2.4.2.986"
rm *.txt
rm -rf md5 tmp
wait
# Create temporary folder
mkdir -p ./tmp/
cd tmp

# Start Download Filter File
echo 'Downloading...'
easylist_lite=(  
  #xinggsf
  "https://raw.githubusercontent.com/xinggsf/Adblock-Plus-Rule/master/mv.txt" 
  #damengzhu
  "https://raw.githubusercontent.com/damengzhu/banad/main/jiekouAD.txt" 
  #Noyllopa NoAppDownload
  "https://raw.githubusercontent.com/Noyllopa/NoAppDownload/master/NoAppDownload.txt" 
  #china
  "https://filters.adtidy.org/extension/ublock/filters/224.txt" 
  #cjx
  "https://raw.githubusercontent.com/cjx82630/cjxlist/master/cjx-annoyance.txt"
  #anti-anti-ad
  "https://raw.githubusercontent.com/reek/anti-adblock-killer/master/anti-adblock-killer-filters.txt"
  "https://easylist-downloads.adblockplus.org/antiadblockfilters.txt"
  "https://easylist-downloads.adblockplus.org/abp-filters-anti-cv.txt"
  #秋风のとおり道
  "https://raw.githubusercontent.com/TG-Twilight/AWAvenue-Adblock-Rule/main/AWAvenue-Adblock-Rule.txt"
)

easylist=( 
  #Clean Url
  "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/ClearURLs%20for%20uBo/clear_urls_uboified.txt" 
  #privacy
  "https://filters.adtidy.org/extension/ublock/filters/3_optimized.txt"
  #english opt
  "https://filters.adtidy.org/extension/ublock/filters/2_optimized.txt"
)

easylist_plus=(
  #ubo annoyance
  "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/annoyances.txt" 
  #ubo privacy
  "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/privacy.txt" 
  #adg base
  "https://filters.adtidy.org/windows/filters/2.txt" 
  #adg phone
  "https://filters.adtidy.org/windows/filters/11.txt" 
  #adg privacy
  "https://filters.adtidy.org/windows/filters/3.txt" 
  #adg cn
  "https://filters.adtidy.org/windows/filters/224.txt" 
  #adg annoyance
  "https://filters.adtidy.org/windows/filters/14.txt" 
  #adg social
  "https://filters.adtidy.org/windows/filters/4.txt" 
  #adg URL
  "https://filters.adtidy.org/windows/filters/17.txt"  
)

dns=(
  #Ultimate Ad Filter
  "https://filters.adavoid.org/ultimate-ad-filter.txt"
  #Ultimate Privacy Filter
  "https://filters.adavoid.org/ultimate-privacy-filter.txt"
  #秋风のとおり道
  "https://raw.githubusercontent.com/TG-Twilight/AWAvenue-Adblock-Rule/main/AWAvenue-Adblock-Rule.txt"
  #Social
  "https://filters.adtidy.org/windows/filters/4.txt"
  #Annoying
  "https://filters.adtidy.org/windows/filters/14.txt"
  "https://easylist-downloads.adblockplus.org/fanboy-annoyance.txt"
  #Mobile Ads
  "https://filters.adtidy.org/windows/filters/11.txt"
  #Chinese and English
  "https://filters.adtidy.org/windows/filters/2.txt"
  "https://easylist-downloads.adblockplus.org/easylistchina+easylist.txt"
  "https://filters.adtidy.org/windows/filters/224.txt" 
  #Fuck Tracking
  "https://easylist-downloads.adblockplus.org/easyprivacy.txt"
  "https://filters.adtidy.org/windows/filters/3.txt"
  #anti-coin
  "https://raw.githubusercontent.com/hoshsadiq/adblock-nocoin-list/master/nocoin.txt"
  #scam
  "https://raw.githubusercontent.com/durablenapkin/scamblocklist/master/adguard.txt"
  #damengzhu
  "https://raw.githubusercontent.com/damengzhu/banad/main/jiekouAD.txt"
  #adgk
  "https://raw.githubusercontent.com/banbendalao/ADgk/master/ADgk.txt"
  #xinggsf
  "https://raw.githubusercontent.com/xinggsf/Adblock-Plus-Rule/master/mv.txt" 
  #uBO
  "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/annoyances.txt" 
  "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/badware.txt" 
  "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters.txt"
  "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/privacy.txt"
  #cjx
  "https://raw.githubusercontent.com/cjx82630/cjxlist/master/cjx-annoyance.txt"
  #anti-anti-ad
  "https://raw.githubusercontent.com/reek/anti-adblock-killer/master/anti-adblock-killer-filters.txt"
  "https://easylist-downloads.adblockplus.org/antiadblockfilters.txt"
  "https://easylist-downloads.adblockplus.org/abp-filters-anti-cv.txt"
  #HostsVN
  "https://raw.githubusercontent.com/bigdargon/hostsVN/master/filters/adservers-all.txt"
  #Smart-TV
  "https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/SmartTV-AGH.txt"
)

hosts=(
  #adaway
  "https://adaway.org/hosts.txt"
  #ad-wars
  "https://raw.githubusercontent.com/jdlingyu/ad-wars/master/hosts"
  #anti-windows-spy
  "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt"
  #Notarck-Malware
  "https://gitlab.com/quidsup/notrack-blocklists/-/raw/master/malware.hosts"
  #hostsVN
  "https://raw.githubusercontent.com/bigdargon/hostsVN/master/hosts"
  #StevenBlack
  "https://raw.githubusercontent.com/StevenBlack/hosts/master/data/StevenBlack/hosts"
  #URLHANS
  "https://urlhaus.abuse.ch/downloads/hostfile/"
  #SomeoneNewWhoCares
  "https://someonewhocares.org/hosts/zero/hosts"
  #Spam404
  "https://raw.githubusercontent.com/Spam404/lists/master/main-blacklist.txt"
)



for i in "${!easylist[@]}" "${!easylist_lite[@]}" "${!easylist_plus[@]}" "${!hosts[@]}" "${!dns[@]}" 
do
  curl --parallel --parallel-immediate -k -L -C - -o "easylist${i}.txt" --connect-timeout 30 -s "${easylist[$i]}" &
  curl --parallel --parallel-immediate -k -L -C - -o "plus-easylist${i}.txt" --connect-timeout 30 -s "${easylist_plus[$i]}"  &
  curl --parallel --parallel-immediate -k -L -C - -o "lite-easylist${i}.txt" --connect-timeout 30 -s "${easylist_lite[$i]}"  &
  curl --parallel --parallel-immediate -k -L -C - -o "dns${i}.txt" --connect-timeout 30 -s "${dns[$i]}" &
  curl --parallel --parallel-immediate -k -L -C - -o "hosts${i}.txt" --connect-timeout 30 -s "${hosts[$i]}" &
done
wait

echo 'Finish'

# 添加空格
file="$(ls|sort -u)"
for i in $file; do
  echo -e '\n\n\n' >> $i &
done
wait

# Start Merge and Duplicate Removal

echo Start Merge

#Normal
cat .././mod/rules/adblock-rules.txt easylist*.txt lite-*.txt \
 | grep -Ev "^((\!)|(\[)).*" | grep -Pv "^(@@)?\|\|[a-z]*(?:(?!\^|\/|\$).)*$" \
 | grep -P '^[@|\[\]~#$:/a-z0-9.*]' | grep -Pv '^\.[a-z0-9]*\^$' \
 | sort -n | uniq > tmp-adblock.txt  

#Plus
cat tmp-adblock.txt plus*easylist*.txt \
 | grep -Ev "^((\!)|(\[)).*" | grep -Pv "^(@@)?\|\|[a-z]*(?:(?!\^|\/|\$).)*$" \
 | grep -P '^[@|\[\]~#$:/a-z0-9.*]' | grep -Pv '^\.[a-z0-9]*\^$' \
 | sort -n | uniq > tmp-adblock_plus.txt  

#Lite
cat .././mod/rules/adblock-rules.txt lite-*.txt \
 | grep -Ev "^((\!)|(\[)).*" | grep -Pv "^(@@)?\|\|[a-z]*(?:(?!\^|\/|\$).)*$" \
 | grep -P '^[@|\[\]~#$:/a-z0-9.*]' | grep -Pv '^\.[a-z0-9]*\^$' \
 | sort -n | uniq > tmp-adblock_lite.txt

#DNS
bash ../script/rebuilt-dns-list.sh
wait

cd ../tmp/
mv ../{dns.txt,hosts.txt,ad-domains.txt} ./
rename 's/^/tmp-/' dns.txt hosts.txt ad-domains.txt
sed -i 's/^\!.*//g' tmp-dns.txt tmp-hosts.txt tmp-ad-domains.txt
sed -i 's/^\#.*//g' tmp-dns.txt tmp-hosts.txt tmp-ad-domains.txt
sed -i '/^$/d' tmp-dns.txt tmp-hosts.txt tmp-ad-domains.txt
rm -f ../{dns.txt,hosts.txt,ad-domains.txt}

# Move to Pre Filter
cd ../
mkdir -p ./pre/
cp ./tmp/tmp-*.txt ./pre
cd ./pre


# Start Add title and date
diffFile="$(ls|sort -u)"
for i in $diffFile; do
 python .././script/rule.py $i
 n=`cat $i | wc -l` 
 echo "! Version: $(TZ=UTC-8 date +'%Y-%m-%d %H:%M:%S')(GMT+8) " >> tpdate.txt 
 new=$(echo "$i" |sed 's/tmp-//g') 
 echo "! Total count: $n" > $i-tpdate.txt 
 cat ./tpdate.txt ./$i-tpdate.txt ./$i |grep -Ev "^(\|)*(\.)?com(\^)?$" > ./$new 
 rm $i *tpdate.txt 
done

# Add Title and MD5
cd ../
mkdir -p ./md5/
diffFile="$(ls pre |sort -u)"
for i in $diffFile; do
 titleName=$(echo "$i" |sed 's#.txt#-title.txt#') 
 cat ./mod/title/$titleName ./pre/$i | awk '!a[$0]++'> ./$i 
 sed -i '/^$/d' $i 
 md5sum $i | sed "s/$i//" > ./md5/$i.md5 
 perl ./script/addchecksum.pl ./$i &
 iconv -t UTF-8 $i > tmp-$i
 mv -f tmp-$i $i
done
wait
sed -i 's/!/#/g' hosts.txt
rm -rf pre tmp
exit
