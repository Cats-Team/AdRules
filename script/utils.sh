#!/bin/bash

# 公共工具函数库

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${GREEN}[INFO]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $*" >&2
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $*" >&2
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $*" >&2
}

# 检查依赖
check_deps() {
    local missing=()
    for dep in "$@"; do
        if ! command -v "$dep" >/dev/null 2>&1; then
            missing+=("$dep")
        fi
    done
    if [ ${#missing[@]} -ne 0 ]; then
        log_error "缺少必要依赖: ${missing[*]}"
        exit 1
    fi
}

# 下载函数 (带重试和超时)
download_file() {
    local url="$1"
    local output="$2"
    local max_retries=5
    local timeout=30
    local retry_delay=5
    local count=0

    while [ $count -lt $max_retries ]; do
        log_info "正在下载 (尝试 $((count + 1))/$max_retries): $url"
        if curl -sS -L --connect-timeout "$timeout" --retry 3 -o "$output" "$url"; then
            # 简单校验：文件是否为空
            if [ -s "$output" ]; then
                return 0
            else
                log_warn "下载的文件为空: $url"
            fi
        else
            log_error "下载失败: $url"
        fi
        
        count=$((count + 1))
        if [ $count -lt $max_retries ]; then
            log_info "等待 ${retry_delay} 秒后重试..."
            sleep "$retry_delay"
        fi
    done

    return 1
}

# 生成时间戳
get_timestamp() {
    TZ=UTC-8 date +'%Y-%m-%d %H:%M:%S'
}
