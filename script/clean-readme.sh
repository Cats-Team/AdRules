#!/bin/sh
num_adg=`sed -n 's/^! Total count: //p' adguard.txt`
num_adgf=`sed -n 's/^! Total count: //p' adguard-full.txt`
num_al=`sed -n 's/^! Total count: //p' allow.txt`
num_adb=`sed -n 's/^! Total count: //p' adblock.txt`
num_adp=`sed -n 's/^! Total count: //p' adblock_plus.txt`
num_dns=`sed -n 's/^! Total count: //p' dns.txt`
num_hosts=`sed -n 's/^# Total count: //p' hosts.txt`
num_domains=`sed -n 's/^! Total count: //p' ad-domains.txt`

time=$(TZ=UTC-8 date +'%Y-%m-%d %H:%M:%S')
sed -i "s/^更新时间:.*/更新时间: $time （北京时间） /g" README.md
sed -i 's/^AdRules AdBlock List 规则数量.*/AdRules AdBlock List 规则数量: '$num_adb' /g' README.md
sed -i 's/^AdRules AdGuard Filter List 规则数量.*/AdRules AdGuard Filter List 规则数量: '$num_adg' /g' README.md
sed -i 's/^AdRules DNS List 规则数量.*/AdRules DNS List 规则数量: '$num_dns' /g' README.md
sed -i 's/^AdRules Hosts List 规则数量.*/AdRules Hosts List 规则数量: '$num_hosts' /g' README.md
sed -i 's/^AdRules Allowlist 规则数量.*/AdRules Allowlist 规则数量: '$num_al' /g' README.md
sed -i 's/^AdRules Ad Domains List 数量.*/AdRules Ad Domains List 数量: '$num_domains' /g' README.md
sed -i 's/^AdRules AdBlock Full List 规则数量.*/AdRules AdBlock Full List 规则数量: '$num_adp' /g' README.md
sed -i 's/^AdRules AdGuard Full List 规则数量.*/AdRules AdGuard Full List 规则数量: '$num_adgf' /g' README.md
exit
