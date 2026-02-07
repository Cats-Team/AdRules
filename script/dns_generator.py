import json
import re
import requests
import argparse
from utils import read_file, write_file, format_bj_time

def generate_singbox(input_path, output_path):
    domains = read_file(input_path)
    rules = {
        "version": "3",
        "rules": [{"domain_suffix": domains}]
    }
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(rules, f, indent=4)
    print(f"Sing-box config generated: {output_path}")

def generate_surge(input_path, output_path):
    # 远程获取 BanAD 列表
    banad_url = "https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/BanAD.list"
    try:
        resp = requests.get(banad_url, timeout=10)
        resp.raise_for_status()
        banad_list = resp.text.splitlines()
    except Exception as e:
        print(f"Failed to fetch BanAD list: {e}")
        banad_list = []

    # 处理本地域名
    local_lines = read_file(input_path, skip_comments=False)
    pattern = re.compile(r"(?<=\|\|).+(?=\^)")
    
    surge_rules = []
    stats = {"WILDCARD": 0, "KEYWORD": 0, "SUFFIX": 0}

    # 统计远程列表中的 KEYWORD
    for line in banad_list:
        if line.startswith("DOMAIN-KEYWORD"):
            stats["KEYWORD"] += 1

    for line in local_lines:
        match = pattern.search(line)
        if match:
            domain = match.group(0)
            if '*' in domain:
                surge_rules.append(f"DOMAIN-WILDCARD,{domain}")
                stats["WILDCARD"] += 1
            else:
                surge_rules.append(f"DOMAIN-SUFFIX,{domain}")
                stats["SUFFIX"] += 1
    
    surge_rules.sort()

    # 写入文件
    content = [f"# Generated at {format_bj_time()}"]
    for k, v in stats.items():
        content.append(f"# DOMAIN-{k}: {v}")
    
    # 添加远程 KEYWORD 规则
    for line in banad_list:
        if line.startswith("DOMAIN-KEYWORD"):
            content.append(line)
            
    content.extend(surge_rules)
    write_file(output_path, content)
    print(f"Surge config generated: {output_path}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Generate DNS configs for different platforms")
    parser.add_argument("--type", choices=["singbox", "surge", "all"], default="all")
    parser.add_argument("--input", default="domain.txt")
    args = parser.parse_args()

    if args.type in ["singbox", "all"]:
        generate_singbox(args.input, "adrules-singbox.json")
    if args.type in ["surge", "all"]:
        # Surge 脚本原逻辑使用 dns.txt 作为输入，这里保持灵活性
        generate_surge("dns.txt", "adrules-surge.conf")
