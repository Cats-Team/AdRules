#!/bin/sh
set -euo pipefail  # 严格模式
LC_ALL='C'

# 日志函数
log_info() {
  echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S') - $*"
}
log_warn() {
  echo "[WARN] $(date '+%Y-%m-%d %H:%M:%S') - $*"
}
log_error() {
  echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S') - $*"
}

cd "$(dirname "${BASH_SOURCE[0]}")/.."

download_file() {
  local url="$1"
  local directory="$2"
  local filename
  filename=$(basename "$url")
  local filepath="$directory/$filename"
  local retries=3

  while [ $retries -gt 0 ]; do
    if curl -sS -L -o "$filepath" "$url"; then
      # 插入来源注释
      sed -i "1i\\! url: $url" "$filepath"
      #log_info "下载成功: $url -> $filepath"
      return 0
    else
      retries=$((retries - 1))
      log_warn "下载失败，重试（$retries剩余）: $url"
      sleep 1
    fi
  done

  log_error "下载最终失败: $url"
  # 记录失败的链接
  echo "$url" >> ../download_failed.log
  return 1
}

log_info "开始下载规则..."

mkdir -p ./tmp
cd tmp
mkdir -p ./content ./dns

# 规则链接数组
content_urls=(  
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
  "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/annoyances-others.txt" 
  #ubo privacy
  "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/privacy.txt" 
  #adg base
  "https://filters.adtidy.org/windows/filters/2.txt" 
  #adg privacy
  "https://filters.adtidy.org/windows/filters/3.txt" 
  #adg cn
  #"https://filters.adtidy.org/windows/filters/224.txt" 
  #adg annoyance
  "https://filters.adtidy.org/windows/filters/14.txt" 
)

dns_urls=(
  #Ultimate Ad Filter
  #"https://filters.adavoid.org/ultimate-ad-filter.txt"
  #Ultimate Privacy Filter
  #"https://filters.adavoid.org/ultimate-privacy-filter.txt"
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
  #"https://filters.adtidy.org/windows/filters/224.txt" 
  #Fuck Tracking
  "https://easylist-downloads.adblockplus.org/easyprivacy.txt"
  "https://filters.adtidy.org/windows/filters/3.txt"
  #anti-coin
  "https://raw.githubusercontent.com/hoshsadiq/adblock-nocoin-list/master/nocoin.txt"
  #scam
  "https://raw.githubusercontent.com/durablenapkin/scamblocklist/master/adguard.txt"
  #damengzhu
  "https://raw.githubusercontent.com/damengzhu/banad/main/jiekouAD.txt"
  #xinggsf
  "https://raw.githubusercontent.com/xinggsf/Adblock-Plus-Rule/master/mv.txt" 
  #uBO
  "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/annoyances-others.txt" 
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
  #hosts
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
  #Brave
  "https://raw.githubusercontent.com/brave/adblock-lists/master/brave-lists/brave-firstparty.txt"
  #Me
  "https://raw.githubusercontent.com/Cats-Team/dns-filter/main/abp.txt"
)

# 清空失败日志
> ../download_failed.log

# 并发下载
for url in "${content_urls[@]}"; do
  download_file "$url" "./content" &
done

for url in "${dns_urls[@]}"; do
  download_file "$url" "./dns" &
done

wait

# 换行符处理
convert_line_endings() {
  dir=$1
  file_count=0
  if ls "$dir"/*.txt >/dev/null 2>&1; then
    if command -v dos2unix >/dev/null 2>&1; then
      for file in "$dir"/*.txt; do
        dos2unix "$file" >/dev/null 2>&1
        file_count=$((file_count+1))
      done
    else
      for file in "$dir"/*.txt; do
        [ -f "$file" ] && sed -i 's/\r$//' "$file"
        file_count=$((file_count+1))
      done
    fi
  fi
  log_info "$dir 转换了 $file_count 个文件"
}

convert_line_endings "content"
convert_line_endings "dns"

# 显示失败链接
if [ -s ../download_failed.log ]; then
  log_error "下载失败链接如下："
  cat ../download_failed.log >&2
  rm -f ../download_failed.log
fi

log_info "全部完成 ✅"
exit 0
