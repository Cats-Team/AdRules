#!/bin/sh
LC_ALL='C'

download_file() {
  url=$1
  directory=$2
  filename=$(basename $url)
  filepath="$directory/$filename"
  retries=3
  while [ $retries -gt 0 ]; do
    if curl -sS -o $filepath $url; then
      echo "Downloaded $url successfully"
      return  
    else
      echo "Failed to download $url, retrying..."
      retries=$((retries-1))
    fi
  done
  echo "Failed to download $url after 3 retries, exiting script."
  exit 1  
}

rm *.txt
rm -rf md5 tmp
wait
# Create temporary folder
mkdir -p ./tmp/
cd tmp

# Start Download Filter File
echo 'Downloading...'

content=(  
  #damengzhu
  "https://raw.githubusercontent.com/damengzhu/banad/main/jiekouAD.txt" 
  #Noyllopa NoAppDownload
  "https://raw.githubusercontent.com/Noyllopa/NoAppDownload/master/NoAppDownload.txt" 
  #china
  #"https://filters.adtidy.org/extension/ublock/filters/224.txt" 
  #cjx
  "https://raw.githubusercontent.com/cjx82630/cjxlist/master/cjx-annoyance.txt"
  #anti-anti-ad
  "https://raw.githubusercontent.com/reek/anti-adblock-killer/master/anti-adblock-killer-filters.txt"
  "https://easylist-downloads.adblockplus.org/antiadblockfilters.txt"
  "https://easylist-downloads.adblockplus.org/abp-filters-anti-cv.txt"
  #--normal
  #Clean Url
  "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/ClearURLs%20for%20uBo/clear_urls_uboified.txt" 
  #english opt
  "https://filters.adtidy.org/extension/ublock/filters/2_optimized.txt"
  #EasyListPrvacy
  "https://easylist-downloads.adblockplus.org/easyprivacy.txt"
  #--plus
  #ubo annoyance
  "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/annoyances.txt" 
  #ubo privacy
  "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/privacy.txt" 
  #adg base
  "https://filters.adtidy.org/windows/filters/2.txt" 
  #adg privacy
  "https://filters.adtidy.org/windows/filters/3.txt" 
  #adg cn
  "https://filters.adtidy.org/windows/filters/224.txt" 
  #adg annoyance
  "https://filters.adtidy.org/windows/filters/14.txt" 
)

dns=(
  #Ultimate Ad Filter
  "https://filters.adavoid.org/ultimate-ad-filter.txt"
  #Ultimate Privacy Filter
  "https://filters.adavoid.org/ultimate-privacy-filter.txt"
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
  #d3ward
  "https://raw.githubusercontent.com/d3ward/toolz/master/src/d3host.adblock"
  #hosts
  #ad-wars
  "https://raw.githubusercontent.com/jdlingyu/ad-wars/master/sha_ad_hosts"
  #anti-windows-spy
  "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt"
  #Notarck-Malware
  "https://gitlab.com/quidsup/notrack-blocklists/-/raw/master/malware.hosts"
  #hostsVN
  "https://raw.githubusercontent.com/bigdargon/hostsVN/master/filters/adservers-all.txt"
  #StevenBlack
  "https://raw.githubusercontent.com/StevenBlack/hosts/master/data/StevenBlack/hosts"
  #URLHANS
  "https://urlhaus.abuse.ch/downloads/hostfile/"
  #SomeoneNewWhoCares
  "https://someonewhocares.org/hosts/zero/hosts"
  #Spam404
  "https://raw.githubusercontent.com/Spam404/lists/master/main-blacklist.txt"
  #Me
  "https://raw.githubusercontent.com/Cats-Team/dns-filter/main/abp.txt"
)

mkdir -p content
mkdir -p dns

for content in "${content[@]}"
do
  download_file $content "content"
done

for dns in "${dns[@]}" 
do
  download_file $dns "dns"
done


curl -s https://raw.githubusercontent.com/Loyalsoldier/clash-rules/release/reject.txt \
 | grep -Po "(?<=\'\+\.).+(?=\')" | sort > ./dns/dns99.txt

#修复换行符问题
sed -i 's/\r//' ./content/*.txt

echo 'Finish'


# Start Merge and Duplicate Removal

echo Start Merge

rules=(
  jiekouAD.txt
  224.txt
  NoAppDownload.txt
  cjx-annoyance.txt
  anti-adblock-killer-filters.txt
  antiadblockfilters.txt
  abp-filters-anti-cv.txt
)

#Lite
echo " " > pre-lite.txt

for file in "${rules[@]}"
do
  cat "./content/$file" >> pre-lite.txt
done

echo "! Version: $(TZ=UTC-8 date +'%Y-%m-%d %H:%M:%S')(GMT+8) " > tpdate.txt 
cat ../mod/title/adblock_lite-title.txt .././mod/rules/adblock-rules.txt pre-lite.txt \
 | grep -Ev "^((\!)|(\[)).*" | sort -n | uniq > adblock_lite.txt
 
python ../script/rule.py adblock_lite.txt
echo "! Total count: $(wc -l < adblock_lite.txt)" > total.txt
cat ../mod/title/adblock_lite-title.txt tpdate.txt total.txt adblock_lite.txt > tmp.txt && mv tmp.txt adblock_lite.txt


#Normal
cat ../mod/title/adblock_lite-title.txt adblock_lite.txt ./content/{3.txt,clear_urls_uboified.txt,easyprivacy.txt}\
 | grep -Ev "^((\!)|(\[)).*" | sort -n | uniq > adblock.txt  

python ../script/rule.py adblock.txt
echo "! Total count: $(wc -l < adblock.txt)" > total.txt
cat ../mod/title/adblock-title.txt tpdate.txt total.txt adblock.txt > tmp.txt && mv tmp.txt adblock.txt


#Plus
cat adblock.txt ./content/*.txt \
 | grep -Ev "^((\!)|(\[)).*" | sort -n | uniq  > adblock_plus.txt  


python ../script/rule.py adblock_plus.txt
echo "! Total count: $(wc -l < adblock_plus.txt)" > total.txt
cat ../mod/title/adblock_plus-title.txt tpdate.txt total.txt adblock_plus.txt > tmp.txt && mv tmp.txt adblock_plus.txt


#DNS
bash ../script/rebuilt-dns-list.sh
echo "! Total count: $(wc -l < ../dns.txt)" > total.txt
cat ../mod/title/dns-title.txt tpdate.txt total.txt ../dns.txt | sed '/^$/d' > tmp.txt && mv tmp.txt ../dns.txt


# Move to Pre Filter
cd ../
mv ./tmp/adblock*.txt ./
rm -rf ./script/origin-files

