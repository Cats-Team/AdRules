import re
import requests
from datetime import datetime, timezone, timedelta

# 用于生成北京时间的 tzinfo
BJ = timezone(timedelta(hours=8))

url = "https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/BanAD.list"
response = requests.get(url)
banad_list = response.text.splitlines()

with open("adrules-surge.conf", "w") as surge_file:
    # 生成北京时间，并格式化输出
    now_bj = datetime.now(BJ)
    surge_file.write(f"# Generated at {now_bj.strftime('%Y-%m-%d %H:%M:%S')}\n")
    domain_wildcard_count = 0
    domain_keyword_count = 0
    domain_suffix_count = 0
    for line in banad_list:
        if line.startswith("DOMAIN-KEYWORD"):
            domain_keyword_count += 1

pattern = r"(?<=\|\|).+(?=\^)"
with open('dns.txt', 'r') as file:
    lines = file.readlines()

domains = []
for line in lines:
    line = line.strip()
    match = re.search(pattern, line)
    if match:
        domain = match.group(0)
        if '*' in domain:
            domains.append(f"DOMAIN-WILDCARD,{domain}")
            domain_wildcard_count += 1
        else:
            domains.append(f"DOMAIN-SUFFIX,{domain}")
            domain_suffix_count += 1

domains.sort()

# 追加写入统计和规则
with open('adrules-surge.conf', 'a') as output_file:
    output_file.write(f"# DOMAIN-WILDCARD: {domain_wildcard_count}\n")
    output_file.write(f"# DOMAIN-KEYWORD: {domain_keyword_count}\n")
    output_file.write(f"# DOMAIN-SUFFIX: {domain_suffix_count}\n")
    for line in banad_list:
        if line.startswith("DOMAIN-KEYWORD"):
            output_file.write(line + "\n")

    for domain in domains:
        output_file.write(domain + "\n")
