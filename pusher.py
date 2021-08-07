import requests
import json

token = ${{ secrets.PP_KEY }}
title = 'AdRules'
content = 'AdRules规则更新完毕，来自github~'
url = 'http://pushplus.hxtrip.com/send'
data = {
		"token":token,
		"title":title,
		"content":content
}
body = json.dumps(data).encode(encoding = 'utf-8')
headers = {'Content-Type':'application/json'}
requests.post(url, data=body, headers=headers)