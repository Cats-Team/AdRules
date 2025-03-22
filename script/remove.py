import re

# 从文件中读取黑名单
with open('./dns.txt', 'r', encoding='utf-8') as f:
    blacklist = [line.strip() for line in f.readlines() if line.strip() and not line.startswith("#")]

# 从文件中读取白名单
with open('./script/allowlist.txt', 'r', encoding='utf-8') as f:
    whitelist = [line.strip() for line in f.readlines() if line.strip() and not line.startswith("#")]

# 新的黑名单
new_blacklist = blacklist

# 遍历白名单
for white_item in whitelist:
    # 判断白名单项是否为正则表达式
    try:
        re.compile(white_item)
        is_regex = True
    except re.error:
        is_regex = False

    # 根据白名单项是正则表达式还是子字符串进行处理
    if is_regex:
        # 如果是正则表达式，添加前缀和后缀
        white_item = r'^\|\|' + white_item + r'\^$'
        new_blacklist = [domain for domain in new_blacklist if not re.match(white_item, domain)]
    else:
        new_blacklist = [domain for domain in new_blacklist if domain != white_item]

# 将新的黑名单写入到文件中
with open('./dns.txt', 'w', encoding='utf-8') as f:
    for domain in new_blacklist:
        f.write(domain + '\n')
