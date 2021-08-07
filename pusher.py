import requests
import json

adguard = r"./adguard.txt"
AdKillRules = r"./AdKillRules.txt"
count_a = -1
for count_a, line in enumerate(open(adguard, 'r').readlines()):
	count_a += 1
	
count_A = -1
for count_A, line in enumerate(open(AdKillRules, 'r').readlines()):
	count_A += 1

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
