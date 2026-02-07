import argparse
import re
import sys
import os
import datetime

# ============================
# 日志格式化函数
# ============================
def log_info(message):
    """
    输出格式: [INFO] YYYY-MM-DD HH:MM:SS - 消息内容
    """
    current_time = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"[INFO] {current_time} - {message}")

# ============================
# 核心逻辑
# ============================

def get_args():
    parser = argparse.ArgumentParser(description="Remove whitelisted domains from ABP rules.")
    parser.add_argument("--blacklist", required=True, help="Path to the ABP blocklist file (target to clean)")
    parser.add_argument("--whitelist", required=True, help="Path to the whitelist file")
    return parser.parse_args()

def is_regex(line):
    """
    判断字符串是否包含正则表达式的特殊字符
    """
    # 常见的正则特殊字符，注意：点号 '.' 在域名中很常见，
    # 纯域名通常不包含 *, \, [, ], (, ), ^, $, {
    regex_chars = {'*', '\\', '[', ']', '(', ')', '^', '$', '{', '}'}
    return any(char in regex_chars for char in line)

def load_whitelist(file_path):
    plain_domains = set()
    regex_rules = []

    if not os.path.exists(file_path):
        log_info(f"错误: 找不到白名单文件: {file_path}")
        sys.exit(1)

    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            for line in f:
                line_content = line.strip()
                # 跳过空行和注释
                if not line_content or line_content.startswith('!') or line_content.startswith('#'):
                    continue
                
                if is_regex(line_content):
                    try:
                        # 编译正则，提高后续匹配效率
                        regex_rules.append(re.compile(line_content, re.IGNORECASE))
                    except re.error as e:
                        log_info(f"警告: 忽略无效的正则白名单: {line_content} ({e})")
                else:
                    plain_domains.add(line_content)
    except Exception as e:
        log_info(f"读取白名单失败: {e}")
        sys.exit(1)
    
    log_info(f"白名单加载完毕: 普通域名 {len(plain_domains)} 条, 正则规则 {len(regex_rules)} 条")
    return plain_domains, regex_rules

def clean_blacklist(blacklist_path, plain_wl, regex_wl):
    if not os.path.exists(blacklist_path):
        log_info(f"错误: 找不到黑名单文件: {blacklist_path}")
        sys.exit(1)
    
    original_count = 0
    removed_count = 0
    kept_lines = []
    
    # 预编译提取 ABP 域名的正则
    # 匹配模式: ||域名^
    abp_domain_pattern = re.compile(r'^\|\|([^\^]+)\^')

    try:
        with open(blacklist_path, 'r', encoding='utf-8') as f:
            lines = f.readlines()
            original_count = len(lines)

        for line in lines:
            stripped = line.strip()
            
            # 使用正则提取 ABP 规则中的域名部分
            match = abp_domain_pattern.match(stripped)
            
            should_remove = False
            
            if match:
                domain_in_rule = match.group(1)
                
                # 1. 检查普通白名单 (全等匹配，速度极快)
                if domain_in_rule in plain_wl:
                    should_remove = True
                    # log_info(f"移除 (精确匹配): {domain_in_rule}") # 调试用
                
                # 2. 检查正则白名单 (如果尚未匹配)
                if not should_remove and regex_wl:
                    for regex in regex_wl:
                        if regex.search(domain_in_rule):
                            should_remove = True
                            # log_info(f"移除 (正则匹配): {domain_in_rule} 匹配规则 {regex.pattern}") # 调试用
                            break
            
            if should_remove:
                removed_count += 1
            else:
                kept_lines.append(line)

        # 写回文件
        with open(blacklist_path, 'w', encoding='utf-8') as f:
            f.writelines(kept_lines)

        log_info(f"黑名单处理完成 - {original_count} > {len(kept_lines)}, 移除误杀数: {removed_count}")

    except Exception as e:
        log_info(f"处理黑名单时发生错误: {e}")
        sys.exit(1)

if __name__ == "__main__":
    # 解析命令行参数
    args = get_args()
    
    # 1. 加载白名单
    plain_whitelist, regex_whitelist = load_whitelist(args.whitelist)
    
    # 2. 清洗黑名单
    clean_blacklist(args.blacklist, plain_whitelist, regex_whitelist)