#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
TMP_DIR="${ROOT_DIR}/tmp"
TOOLS_DIR="${TMP_DIR}/tools"

# 检查依赖
check_deps grep sort uniq sed curl python gzip chmod

# 准备目录
mkdir -p "$TOOLS_DIR"
cd "$ROOT_DIR"

log_info "开始处理 DNS 规则..."

# 1. 预处理 DNS 规则
# 合并 mod/rules 下的规则
cat ./mod/rules/*rule* ./tmp/dns/* 2>/dev/null | \
    grep -P "^(?:\|\|([a-z0-9.*-]+)\^?|(?:\d{1,3}(?:\.\d{1,3}){3}|[0-9a-fA-F:]+)\s+((?:\*|(?:\*\.)?[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?)(?:\.[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?)+)|((?:\*|(?:\*\.)?[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?)(?:\.[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?)+))$" | \
    grep -vE '@|:|\?|\$|\#|\!|/' | \
    sort -u > dns.txt

# 2. 运行 Python 移除白名单和去重
log_info "正在压缩和去重 DNS 规则..."
python "${SCRIPT_DIR}/compressor.py" dns.txt -i --include-wildcards
log_info "正在应用白名单..."
python "${SCRIPT_DIR}/remove.py" --blacklist dns.txt --whitelist mod/rules/dns-allowlist.txt

# 3. 添加首要规则并再次去重
if [[ -f "./mod/rules/first-dns-rules.txt" ]]; then
    cat ./mod/rules/first-dns-rules.txt >> dns.txt
fi
python "${SCRIPT_DIR}/sort.py" dns.txt

# 4. 生成最终 dns.txt (带标题和统计)
count=$(wc -l < dns.txt)
{
    [[ -f "./mod/title/dns-title.txt" ]] && cat ./mod/title/dns-title.txt
    echo "! Total count: $count"
    echo "! Update: $(get_timestamp)(GMT+8)"
    cat dns.txt
} | sed '/^$/d' > dns.txt.tmp && mv dns.txt.tmp dns.txt

# 5. 提取域名并生成各种格式
log_info "生成多平台配置..."
grep -Po "(?<=\|\|).+(?=\^)" dns.txt | grep -v "\*" > domain.txt || touch domain.txt

# 使用 Python 生成 Sing-box 和 Surge 配置
python "${SCRIPT_DIR}/dns_generator.py" --type all --input domain.txt

# 生成其他格式 (QX, SmartDNS, MosDNS, Domainset)
update_time="$(get_timestamp)(GMT+8)"

# QX
{ echo "# Title:AdRules Quantumult X List"; echo "# Update: $update_time"; sed 's/^/host-suffix,/g; s/$/,reject/g' domain.txt; } > qx.conf
# SmartDNS
{ echo "# Title:AdRules SmartDNS List"; echo "# Update: $update_time"; sed 's/^/address \//g; s/$/\/#/g' domain.txt; } > smart-dns.conf
# MosDNS
sed 's/^/domain:/g' domain.txt > mosdns_adrules.txt
# Domainset
{ echo "# Update: $update_time"; sed 's/^/\+\./g' domain.txt; } > adrules_domainset.txt
# Surge Domainset
{ echo "# Update: $update_time"; sed 's/^/\./g' domain.txt; } > adrules_surge_domainset.txt
# AdRules List
{ echo "# Title:AdRules List"; echo "# Update: $update_time"; sed 's/^/DOMAIN-SUFFIX,/g' domain.txt; } > adrules.list

# 定义处理函数
download_tool() {
    local name=$1 url=$2 archive=$3 bin_in_archive=$4 bin_path=$5
    [[ -f "$bin_path" ]] && return 0
    log_info "下载 $name..."
    if download_file "$url" "$TOOLS_DIR/$archive"; then
        if [[ "$archive" == *.tar.gz ]]; then
            tar -zxf "$TOOLS_DIR/$archive" -C "$TOOLS_DIR"
            [[ -n "$bin_in_archive" ]] && mv "$TOOLS_DIR/$bin_in_archive" "$bin_path"
        elif [[ "$archive" == *.gz ]]; then
            gzip -d -c "$TOOLS_DIR/$archive" > "$bin_path"
        fi
        chmod +x "$bin_path"
        rm -rf "$TOOLS_DIR/$archive" "${TOOLS_DIR:?}/${bin_in_archive%/*}"
    else
        log_error "下载 $name 失败"
        return 1
    fi
}

process_with_singbox() {
    local version="1.11.11" bin="$TOOLS_DIR/sing-box"
    local url="https://github.com/SagerNet/sing-box/releases/download/v${version}/sing-box-${version}-linux-amd64.tar.gz"
    download_tool "sing-box" "$url" "sb.tar.gz" "sing-box-${version}-linux-amd64/sing-box" "$bin" || return 1
    "$bin" rule-set convert dns.txt -t adguard --output adrules-singbox.srs && \
        log_info "sing-box 转换完成" || log_warn "sing-box 转换失败"
}

process_with_mihomo() {
    local bin="$TOOLS_DIR/mihomo"
    # 获取版本号
    curl -sL -o "$TOOLS_DIR/version.txt" https://github.com/MetaCubeX/mihomo/releases/download/Prerelease-Alpha/version.txt
    local version=$(cat "$TOOLS_DIR/version.txt")
    local url="https://github.com/MetaCubeX/mihomo/releases/download/Prerelease-Alpha/mihomo-linux-amd64-${version}.gz"
    
    # 直接下载并流式解压，绕过文件名不匹配问题
    log_info "下载并配置 mihomo ($version)..."
    if curl -sL "$url" | gzip -d - > "$bin"; then
        chmod +x "$bin"
    else
        log_error "mihomo 下载失败"
        return 1
    fi

    "$bin" convert-ruleset domain text adrules_domainset.txt adrules-mihomo.mrs && \
        log_info "mihomo 转换完成" || log_warn "mihomo 转换失败"
}

process_with_singbox
process_with_mihomo

log_info "DNS 规则更新完成。"
