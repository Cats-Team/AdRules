#!/bin/bash
set -euo pipefail

# 导入工具函数
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

# 项目根目录
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
TMP_DIR="${ROOT_DIR}/tmp"
FAILED_LOG="${ROOT_DIR}/download_failed.log"

# 检查依赖
check_deps curl sed xargs

# 准备目录
mkdir -p "${TMP_DIR}/content" "${TMP_DIR}/dns"
> "$FAILED_LOG"

# 下载任务处理函数
do_download() {
    local url="$1"
    local target_dir="$2"
    
    # 为重名文件添加缓解措施：使用 URL 的 MD5 哈希作为前缀
    local url_hash=$(echo -n "$url" | md5sum | cut -d' ' -f1 | cut -c1-8)
    local original_filename=$(basename "$url")
    local filename="${url_hash}_${original_filename}"
    
    local filepath="${target_dir}/${filename}"
    local tmp_filepath="${filepath}.tmp"
    
    if download_file "$url" "$tmp_filepath"; then
        # 插入来源注释
        sed -i "1i\\! url: $url" "$tmp_filepath"
        # 换行符转换
        sed -i 's/\r$//' "$tmp_filepath"
        # 原子性移动，确保文件完整
        mv "$tmp_filepath" "$filepath"
    else
        rm -f "$tmp_filepath"
        echo "$url" >> "$FAILED_LOG"
    fi
}

export -f do_download
export -f download_file
export -f log_info
export -f log_warn
export -f log_error
export NC GREEN YELLOW RED

# 规则链接
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
  #StevenBlack
  "https://raw.githubusercontent.com/StevenBlack/hosts/master/data/StevenBlack/hosts"
  #SomeoneNewWhoCares
  "https://someonewhocares.org/hosts/zero/hosts"
  #Brave
  "https://raw.githubusercontent.com/brave/adblock-lists/master/brave-lists/brave-firstparty.txt"
  #Me
  "https://raw.githubusercontent.com/Cats-Team/dns-filter/main/abp.txt"
)

log_info "开始并发下载规则..."

# 使用 xargs 控制并发数为 8
printf "%s\n" "${content_urls[@]}" | xargs -I {} -P 8 bash -c "do_download '{}' '${TMP_DIR}/content'"
printf "%s\n" "${dns_urls[@]}" | xargs -I {} -P 8 bash -c "do_download '{}' '${TMP_DIR}/dns'"

if [ -s "$FAILED_LOG" ]; then
    log_error "以下链接下载失败:"
    cat "$FAILED_LOG"
fi

log_info "下载任务完成。"
