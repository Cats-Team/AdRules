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

wait
# Create temporary folder
mkdir -p ./tmp/
cd tmp

# Start Download Filter File
echo 'Start Downloading...'

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
  "https://raw.githubusercontent.com/jdlingyu/ad-wars/master/hosts"
  #anti-windows-spy
  "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt"
  #Notarck-Malware
  "https://gitlab.com/quidsup/notrack-blocklists/-/raw/master/malware.hosts"
  #hostsVN
  "https://raw.githubusercontent.com/bigdargon/hostsVN/master/filters/adservers-all.txt"
  #StevenBlack
  "https://raw.githubusercontent.com/StevenBlack/hosts/master/data/StevenBlack/hosts"
  #SomeoneNewWhoCares
  "https://someonewhocares.org/hosts/zero/hosts"
  #Spam404
  "https://raw.githubusercontent.com/Spam404/lists/master/main-blacklist.txt"
  #SukkaW
  "https://raw.githubusercontent.com/SukkaW/Surge/master/Source/domainset/reject_sukka.conf"
  #Brave
  "https://raw.githubusercontent.com/brave/adblock-lists/master/brave-lists/brave-firstparty.txt"
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

#修复换行符问题
sed -i 's/\r//' ./content/*.txt

echo 'Finish'

exit
