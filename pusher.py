# -*- coding: UTF-8 -*-
import requests
import json

def iter_count(file_name):
    from itertools import (takewhile, repeat)
    buffer = 1024 * 1024
    with open(file_name) as f:
        buf_gen = takewhile(lambda x: x, (f.read(buffer) for _ in repeat(None)))
        return sum(buf.count('\n') for buf in buf_gen)

def iter_count(file_name):
    from itertools import (takewhile, repeat)
    buffer = 1024 * 1024
    with open(file_name) as f:
        buf_gen = takewhile(lambda x: x, (f.read(buffer) for _ in repeat(None)))
        return sum(buf.count('\n') for buf in buf_gen)

count_a = iter_count(adguard)
count_A = iter_count(AdKillRules)
token = 'c2e9e551adbc46029d98b06ec0e1c77c'
title = 'AdRules'
content = 'AdRules规则更新完毕，来自Github~ <br>adguard.txt共计' + str(count_a) + '条规则，<br>AdKillRules' + str(count_A) + '条规则。'

url = 'http://pushplus.hxtrip.com/send'
data = {
		"token":token,
		"title":title,
		"content":content
}
body = json.dumps(data).encode(encoding = 'utf-8')
headers = {'Content-Type':'application/json'}
requests.post(url, data=body, headers=headers)
