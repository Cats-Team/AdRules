# -*- coding: UTF-8 -*-
import requests
import json

def iter_count(file_name):
    from itertools import (takewhile, repeat)
    buffer = 1024 * 1024
    with open(file_name, 'r', encoding='utf-8') as f:
        buf_gen = takewhile(lambda x: x, (f.read(buffer) for _ in repeat(None)))
        return sum(buf.count('\n') for buf in buf_gen)

count_a = iter_count("adguard.txt") -8
count_al = iter_count("allow.txt") -8
count_A = iter_count("AdKillRules.txt") -8
count_d = iter_count("dns.txt") -8

PUSH_TOKEN = env.PUSH_TOKEN
TITLE = 'AdRules'
CONTENT = 'AdRules规则更新完毕，来自Github~<br>allow.txt共计' + str(count_al) + '条规则，<br>adguard.txt共计' + str(count_a) + '条规则，<br>AdKillRules共计' + str(count_A) + '条规则，<br>dns.txt共计' + str(count_d) + '条规则。'

url = 'http://pushplus.hxtrip.com/send'
data = {
		"token":PUSH_TOKEN,
		"title":TITLE,
		"content":CONTENT
}
body = json.dumps(data).encode(encoding = 'utf-8')
headers = {'Content-Type':'application/json'}
requests.post(url, data=body, headers=headers)
