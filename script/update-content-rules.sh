#!/bin/bash
set -euo pipefail  # 严格模式

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

# 配置
LC_ALL='C'
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="${SCRIPT_DIR}/tmp"
MOD_DIR="${SCRIPT_DIR}/mod"
CONTENT_DIR="${TMP_DIR}/content"
SCRIPT_PATH="${SCRIPT_DIR}/script"

declare -A TITLES=(
    ["lite"]="adblock_lite-title.txt"
    ["normal"]="adblock-title.txt"
    ["plus"]="adblock_plus-title.txt"
)

# 清理函数
cleanup() {
    local exit_code=$?
    log_info "清理临时文件..."
    rm -f "${TMP_DIR}"/adblock*pre.txt "${TMP_DIR}"/pre-*.txt "${TMP_DIR}"/tpdate.txt "${TMP_DIR}"/total.txt "${TMP_DIR}"/*_temp.txt
    exit $exit_code
}

trap cleanup EXIT INT TERM

# 检查依赖
check_dependencies() {
    local deps=("python" "grep" "sort" "uniq" "wc" "cat")
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" >/dev/null 2>&1; then
            log_error "缺少依赖 $dep"
            exit 1
        fi
    done
}

# 生成时间戳
generate_timestamp() {
    echo "! Version: $(TZ=UTC-8 date +'%Y-%m-%d %H:%M:%S')(GMT+8)"
}

# 运行Python规则处理
run_python_script() {
    local file="$1"
    if [[ -f "${SCRIPT_PATH}/rule.py" ]]; then
        python "${SCRIPT_PATH}/rule.py" "$file" || {
            log_warn "Python脚本执行失败"
        }
    fi
}

# 应用移除规则
apply_remove_rules() {
    local input_file="$1"
    local output_file="$2"
    
    if [[ -f "${MOD_DIR}/rules/adblock-need-remove.txt" ]]; then
        grep -vxFf "${MOD_DIR}/rules/adblock-need-remove.txt" "$input_file" > "$output_file"
    else
        cp "$input_file" "$output_file"
    fi
}

# 生成最终文件格式
finalize_file() {
    local version="$1"
    local input_file="$2"
    local output_file="$3"
    
    # 创建临时文件进行处理
    local temp_file="${input_file}_temp.txt"
    cp "$input_file" "$temp_file"
    
    run_python_script "$temp_file"
    
    local count=$(wc -l < "$temp_file")
    {
        cat "${MOD_DIR}/title/${TITLES[$version]}"
        generate_timestamp
        echo "! Total count: $count"
        cat "$temp_file"
    } > "$output_file"
    
    # 清理临时文件
    rm -f "$temp_file"
    
    log_info "${version} 版本处理完成，共 $count 条规则"
}

# 主函数
main() {
    log_info "开始合并和去重处理..."
    
    check_dependencies
    
    cd "$TMP_DIR" || {
        log_error "无法切换到目录 $TMP_DIR"
        exit 1
    }
    log_info "当前工作目录: $(pwd)"
    
    # 处理lite版本
    log_info "处理 lite 版本..."
    local lite_rules=(
        jiekouAD.txt
        224.txt
        NoAppDownload.txt
        cjx-annoyance.txt
        anti-adblock-killer-filters.txt
        antiadblockfilters.txt
        abp-filters-anti-cv.txt
    )
    
    echo " " > pre-lite.txt
    for file in "${lite_rules[@]}"; do
        local full_path="${CONTENT_DIR}/${file}"
        if [[ -f "$full_path" ]]; then
            cat "$full_path" >> pre-lite.txt
        else
            log_warn "文件不存在 $full_path"
        fi
    done
    
    {
        if [[ -f "${MOD_DIR}/title/${TITLES[lite]}" ]]; then
            cat "${MOD_DIR}/title/${TITLES[lite]}"
        fi
        if [[ -f "${MOD_DIR}/rules/adblock-rules.txt" ]]; then
            cat "${MOD_DIR}/rules/adblock-rules.txt"
        fi
        cat pre-lite.txt
    } | grep -Ev "^((\!)|(\[)).*" | sort -n | uniq > adblock_lite_pre.txt
    
    apply_remove_rules adblock_lite_pre.txt adblock_lite_temp.txt
    finalize_file "lite" adblock_lite_temp.txt adblock_lite.txt
    
    # 处理normal版本
    log_info "处理 normal 版本..."
    if [[ ! -f "adblock_lite.txt" ]]; then
        log_error "adblock_lite.txt 不存在"
        exit 1
    fi
    
    {
        cat "${MOD_DIR}/title/${TITLES[normal]}"
        cat adblock_lite.txt
        
        for file in 3.txt clear_urls_uboified.txt easyprivacy.txt; do
            local full_path="${CONTENT_DIR}/${file}"
            if [[ -f "$full_path" ]]; then
                cat "$full_path"
            else
                log_warn "文件不存在 $full_path"
            fi
        done
    } | grep -Ev "^((\!)|(\[)).*" | sort -n | uniq > adblock_pre.txt
    
    apply_remove_rules adblock_pre.txt adblock_temp.txt
    finalize_file "normal" adblock_temp.txt adblock.txt
    
    # 处理plus版本
    log_info "处理 plus 版本..."
    if [[ ! -f "adblock.txt" ]]; then
        log_error "adblock.txt 不存在"
        ls -la adblock*
        exit 1
    fi
    
    {
        cat adblock.txt
        for file in "${CONTENT_DIR}"/*.txt; do
            if [[ -f "$file" ]]; then
                cat "$file"
            fi
        done
    } | grep -Ev "^((\!)|(\[)).*" | sort -n | uniq > adblock_plus_pre.txt
    
    apply_remove_rules adblock_plus_pre.txt adblock_plus_temp.txt
    finalize_file "plus" adblock_plus_temp.txt adblock_plus.txt
    
    log_info "清理临时文件并移动最终文件..."
    rm -f adblock*pre.txt pre-lite.txt adblock*_temp.txt
    
    for file in adblock_lite.txt adblock.txt adblock_plus.txt; do
        if [[ -f "$file" ]]; then
            mv "$file" ../
            log_info "已移动 $file 到上级目录"
        fi
    done
    
    log_info "所有版本处理完成！"
}

main "$@"
