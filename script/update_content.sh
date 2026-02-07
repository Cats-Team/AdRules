#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
TMP_DIR="${ROOT_DIR}/tmp"
MOD_DIR="${ROOT_DIR}/mod"
CONTENT_DIR="${TMP_DIR}/content"

# 检查依赖
check_deps python grep sort uniq wc cat

# 标题映射
declare -A TITLES=(
    ["lite"]="adblock_lite-title.txt"
    ["normal"]="adblock-title.txt"
    ["plus"]="adblock_plus-title.txt"
)

# 处理单个版本的函数
process_version() {
    local version=$1
    local output_file=$2
    shift 2
    local input_files=("$@")

    log_info "正在处理 ${version} 版本..."
    
    local temp_pre="${TMP_DIR}/${version}_pre.txt"
    local temp_final="${TMP_DIR}/${version}_final.txt"

    # 合并输入文件
    > "$temp_pre"
    for f in "${input_files[@]}"; do
        if [[ -f "$f" ]]; then
            cat "$f" >> "$temp_pre"
        fi
    done

    # 基础过滤、去重、排序
    # 排除注释行 (! 或 [)
    # 优化：如果文件很大，sort -u 已经足够，grep 也可以并行或更高效
    grep -Ev "^(\!).*" "$temp_pre" > "$temp_final"

    # 应用移除规则 (如果有)
    local remove_list="${MOD_DIR}/rules/adblock-need-remove.txt"
    if [[ -f "$remove_list" ]]; then
        local temp_removed="${TMP_DIR}/${version}_removed.txt"
        # 优化：使用 LC_ALL=C 提升 grep 速度
        LC_ALL=C grep -vxFf "$remove_list" "$temp_final" > "$temp_removed" || true
        mv "$temp_removed" "$temp_final"
    fi

    # 运行 Python 进一步处理 (去重排序)
    # 优化：Python 处理大文件较慢，如果只是去重排序，shell 的 sort -u 更快
    # 但如果 sort.py 有特殊逻辑则保留。目前看 sort.py 只是去重排序。
    # 我们先尝试在 shell 层完成去重排序
    sort -u "$temp_final" -o "$temp_final"
    python "${SCRIPT_DIR}/sort.py" "$temp_final"

    # 生成最终文件
    local count=$(wc -l < "$temp_final")
    {
        cat "${MOD_DIR}/title/${TITLES[$version]}"
        echo "! Version: $(get_timestamp)(GMT+8)"
        echo "! Total count: $count"
        cat "$temp_final"
    } > "${ROOT_DIR}/${output_file}"

    log_info "${version} 处理完成: ${count} 条规则"
}

# 1. Lite 版本
lite_files=(
    "${MOD_DIR}/rules/adblock-rules.txt"
    ${CONTENT_DIR}/*_jiekouAD.txt
    ${CONTENT_DIR}/*_224.txt
    ${CONTENT_DIR}/*_NoAppDownload.txt
    ${CONTENT_DIR}/*_cjx-annoyance.txt
    ${CONTENT_DIR}/*_anti-adblock-killer-filters.txt
    ${CONTENT_DIR}/*_antiadblockfilters.txt
    ${CONTENT_DIR}/*_abp-filters-anti-cv.txt
)
process_version "lite" "adblock_lite.txt" "${lite_files[@]}"

# 2. Normal 版本 (基于 Lite)
normal_files=(
    "${ROOT_DIR}/adblock_lite.txt"
    ${CONTENT_DIR}/*_3.txt
    ${CONTENT_DIR}/*_clear_urls_uboified.txt
    ${CONTENT_DIR}/*_easyprivacy.txt
)
process_version "normal" "adblock.txt" "${normal_files[@]}"

# 3. Plus 版本 (包含所有)
plus_files=("${ROOT_DIR}/adblock.txt")
# 添加 content 目录下所有 txt
for f in "${CONTENT_DIR}"/*.txt; do
    plus_files+=("$f")
done
process_version "plus" "adblock_plus.txt" "${plus_files[@]}"

log_info "Content 规则更新完成。"
