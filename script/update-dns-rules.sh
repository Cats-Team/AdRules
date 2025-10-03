#!/bin/bash

# 配置和常量
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly TMP_DIR="${SCRIPT_DIR}/tmp"
readonly DNS_DIR="${TMP_DIR}/dns"
readonly OUTPUT_DIR="${SCRIPT_DIR}"
readonly TOOLS_DIR="${TMP_DIR}/tools"

# 文件路径
readonly DNS_TXT="dns.txt"
readonly DOMAIN_TXT="domain.txt"
readonly QX_CONF="qx.conf"
readonly SMART_DNS_CONF="smart-dns.conf"
readonly ADRULES_LIST="adrules.list"
readonly ADRULES_DOMAINSET="adrules_domainset.txt"
readonly MOSDNS_ADRULES="mosdns_adrules.txt"

# 下载URL
readonly MIHOMO_RELEASES_URL="https://github.com/MetaCubeX/mihomo/releases/download/Prerelease-Alpha"

# 错误处理
set -euo pipefail
trap cleanup EXIT

# 日志函数
log_info() {
    echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S') - $*" >&2
}

log_error() {
    echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S') - $*" >&2
}

log_warn() {
    echo "[WARN] $(date '+%Y-%m-%d %H:%M:%S') - $*" >&2
}

# 清理函数
cleanup() {
    local exit_code=$?
    if [[ $exit_code -ne 0 ]]; then
        log_error "脚本执行失败，退出码: $exit_code"
    fi
    
    # 清理临时文件
    [[ -f "dns-output.txt" ]] && rm -f "dns-output.txt"
    [[ -f "total.txt" ]] && rm -f "total.txt"
    [[ -f "version.txt" ]] && rm -f "version.txt"
    # [[ -f "$DOMAIN_TXT" ]] && rm -f "$DOMAIN_TXT"
    [[ -d "$TOOLS_DIR" ]] && rm -rf "$TOOLS_DIR"
    
    log_info "清理完成"
}

# 检查必要的命令
check_dependencies() {
    local deps=("grep" "sort" "uniq" "sed" "wget" "python" "gzip" "chmod")
    local missing=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing+=("$dep")
        fi
    done
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        log_error "缺少必要的依赖: ${missing[*]}"
        exit 1
    fi
}

# 检查必要的文件和目录
check_files() {
    local required_dirs=("./mod/rules" "./script")
    local required_files=("./script/dns-rules-config.json" "./script/remove.py" "./script/rule.py")
    
    for dir in "${required_dirs[@]}"; do
        if [[ ! -d "$dir" ]]; then
            log_error "目录不存在: $dir"
            exit 1
        fi
    done
    
    for file in "${required_files[@]}"; do
        if [[ ! -f "$file" ]]; then
            log_error "文件不存在: $file"
            exit 1
        fi
    done
}

# 创建必要的目录
setup_directories() {
    mkdir -p "$DNS_DIR" "$TOOLS_DIR"
}

# 生成时间戳
generate_timestamp() {
    TZ=UTC-8 date +'%Y-%m-%d %H:%M:%S'
}

# 处理DNS规则
process_dns_rules() {
    log_info "开始处理 DNS 规则..."
    
    # 复制规则文件
    if ! cp ./mod/rules/*rule* "$DNS_DIR/" 2>/dev/null; then
        log_warn "没有找到规则文件，或复制失败"
    fi
    
    # 处理DNS文件
    if ls "$DNS_DIR"/* &>/dev/null; then
        cat "$DNS_DIR"/* | \
            grep -Ev '[A-Z]' | \
            grep -vE '@|:|\?|\$|\#|\!|/' | \
            sort | uniq > "$DNS_TXT"
    else
        log_warn "DNS 目录为空，创建空的 dns.txt"
        touch "$DNS_TXT"
    fi
    
    log_info "DNS规则预处理完成"
}

# 编译hostlist
compile_hostlist() {
    log_info "编译 hostlist..."
    
    if command -v hostlist-compiler &> /dev/null; then
        if hostlist-compiler -c ./script/dns-rules-config.json -o dns-output.txt; then
            grep -P "^\|\|[a-z0-9\.\-\*]+\^$" dns-output.txt > "$DNS_TXT" || log_warn "hostlist 编译结果为空"
        else
            log_warn "hostlist-compiler 执行失败，跳过此步骤"
        fi
    else
        log_warn "hostlist-compiler 未安装，跳过此步骤"
    fi
}

# 运行Python脚本
run_python_scripts() {
    log_info "运行 Python 处理脚本..."
    
    if [[ -f "./script/remove.py" ]]; then
        python ./script/remove.py || log_warn "remove.py 执行失败"
    fi
    
    # 添加首要DNS规则
    if [[ -f "./mod/rules/first-dns-rules.txt" ]]; then
        cat ./mod/rules/first-dns-rules.txt >> "$DNS_TXT"
    fi
    
    if [[ -f "./script/rule.py" ]]; then
        python ./script/rule.py "$DNS_TXT" || log_warn "rule.py 执行失败"
    fi
}

# 生成最终的DNS文件
generate_final_dns() {
    log_info "生成最终 DNS 文件..."
    
    local update_time
    update_time="$(generate_timestamp)(GMT+8)"
    local count
    count=$(wc -l < "$DNS_TXT" 2>/dev/null || echo "0")
    
    # 创建总计信息
    {
        echo "! Total count: $count"
        echo "! Update: $update_time"
    } > total.txt
    
    # 合并文件并清理空行
    {
        [[ -f "./mod/title/dns-title.txt" ]] && cat ./mod/title/dns-title.txt
        cat total.txt
        cat "$DNS_TXT"
    } | sed '/^$/d' > tmp.txt && mv tmp.txt "$DNS_TXT"
    
    log_info "DNS 文件生成完成，共 $count 条规则"
}

# 生成各种格式的配置文件
generate_configs() {
    log_info "生成各种格式的配置文件..."
    
    local update_time
    update_time="$(generate_timestamp)(GMT+8)"
    
    # 初始化配置文件
    {
        echo "# Title:AdRules Quantumult X List"
        echo "# Update: $update_time"
    } > "$QX_CONF"
    
    {
        echo "# Title:AdRules SmartDNS List"
        echo "# Update: $update_time"
    } > "$SMART_DNS_CONF"
    
    {
        echo "# Title:AdRules List"
        echo "# Update: $update_time"
    } > "$ADRULES_LIST"
    
    {
        echo "# Update: $update_time"
    } > "$ADRULES_DOMAINSET"
    
    # 提取域名
    grep -vE '(@|\*)' "$DNS_TXT" | \
        grep -Po "(?<=\|\|).+(?=\^)" | \
        grep -v "\*" > "$DOMAIN_TXT" || {
            log_warn "域名提取失败，创建空域名文件"
            touch "$DOMAIN_TXT"
        }
    
    # 生成不同格式
    if [[ -s "$DOMAIN_TXT" ]]; then
        # Quantumult X 格式
        sed 's/^/host-suffix,/g; s/$/,reject/g' "$DOMAIN_TXT" >> "$QX_CONF"
        
        # SmartDNS 格式
        sed 's/^/address \//g; s/$/\/#/g' "$DOMAIN_TXT" >> "$SMART_DNS_CONF"
        
        # mosdns 格式
        sed 's/^/domain:/g' "$DOMAIN_TXT" > "$MOSDNS_ADRULES"
        
        # domainset 格式
        sed 's/^/\+\./g' "$DOMAIN_TXT" >> "$ADRULES_DOMAINSET"
        
        # adrules 格式
        sed 's/^/DOMAIN-SUFFIX,/g' "$DOMAIN_TXT" >> "$ADRULES_LIST"
        
        log_info "配置文件生成完成"
    else
        log_warn "域名文件为空，配置文件可能不完整"
    fi
}

# 运行附加Python脚本
run_additional_scripts() {
    log_info "运行附加处理脚本..."
    
    [[ -f "./script/dns-script/singbox.py" ]] && {
        python ./script/dns-script/singbox.py || log_warn "singbox.py 执行失败"
    }
    
    [[ -f "./script/dns-script/surge.py" ]] && {
        python ./script/dns-script/surge.py || log_warn "surge.py 执行失败"
    }
}

# 下载并使用sing-box
process_with_singbox() {
    log_info "处理 sing-box 规则转换..."
    
    local singbox_version="1.11.11"
    local singbox_archive="sing-box-${singbox_version}-linux-amd64.tar.gz"
    local download_url="https://github.com/SagerNet/sing-box/releases/download/v${singbox_version}/${singbox_archive}"
    local singbox_dir="$TOOLS_DIR/sing-box-${singbox_version}-linux-amd64"
    local singbox_bin="$TOOLS_DIR/sing-box"
    
    # 下载 sing-box
    log_info "下载 sing-box v${singbox_version}..."
    if wget -q --timeout=60 -P "$TOOLS_DIR" "$download_url"; then
        # 解压到工具目录
        if tar -zxf "$TOOLS_DIR/$singbox_archive" -C "$TOOLS_DIR"; then
            # 移动可执行文件
            if [[ -f "$singbox_dir/sing-box" ]]; then
                mv "$singbox_dir/sing-box" "$singbox_bin"
                chmod +x "$singbox_bin"
                
                # 转换规则
                log_info "转换规则文件..."
                if "$singbox_bin" rule-set convert "$DNS_TXT" -t adguard; then
                    # 移动生成的文件
                    if [[ -f "dns.srs" ]]; then
                        mv "dns.srs" "adrules-singbox.srs"
                        log_info "sing-box 规则文件已生成: adrules-singbox.srs"
                    else
                        log_warn "未找到生成的 dns.srs 文件"
                    fi
                else
                    log_warn "sing-box 规则转换失败"
                fi
            else
                log_error "sing-box 可执行文件不存在"
            fi
        else
            log_error "sing-box 解压失败"
        fi
    else
        log_error "下载 sing-box 失败"
    fi
}

# 下载并使用mihomo
process_with_mihomo() {
    log_info "下载并使用 mihomo..."
    
    local version_file="$TOOLS_DIR/version.txt"
    local mihomo_gz="$TOOLS_DIR/mihomo.gz"
    local mihomo_bin="$TOOLS_DIR/mihomo"
    
    if wget -q -O "$version_file" "${MIHOMO_RELEASES_URL}/version.txt"; then
        local version
        version=$(cat "$version_file")
        
        if wget -q -O "$mihomo_gz" "${MIHOMO_RELEASES_URL}/mihomo-linux-amd64-${version}.gz"; then
            if gzip -d "$mihomo_gz"; then
                local mihomo_extracted="${mihomo_gz%.gz}"
                chmod +x "$mihomo_extracted"
                
                if "$mihomo_extracted" convert-ruleset domain text "$ADRULES_DOMAINSET" adrules-mihomo.mrs; then
                    log_info "mihomo 处理完成"
                else
                    log_warn "mihomo 转换失败"
                fi
            else
                log_warn "mihomo 解压失败"
            fi
        else
            log_warn "mihomo 下载失败"
        fi
    else
        log_warn "mihomo 版本信息获取失败"
    fi
}

# 主函数
main() {
    log_info "开始执行 DNS 规则生成脚本..."
    
    # 设置环境
    export LC_ALL=C
    
    # 检查依赖和文件
    check_dependencies
    check_files
    setup_directories
    
    # 处理流程
    process_dns_rules
    compile_hostlist
    run_python_scripts
    generate_final_dns
    generate_configs
    run_additional_scripts
    process_with_singbox
    process_with_mihomo
    
    log_info "脚本执行完成！"
}

# 执行主函数
main "$@"
