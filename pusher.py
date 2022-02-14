# -*- coding: UTF-8 -*-
import requests
import json
import os

PUSH_TOKEN = os.environ["SCKEY"]
#TG_TOKEN = os.environ["TG_TOKEN"]
#CHAT_ID = os.environ["CHAT_ID"]

def iter_count(file_name):
    from itertools import (takewhile, repeat)
    buffer = 1024 * 1024
    with open(file_name, 'r', encoding='utf-8') as f:
        buf_gen = takewhile(lambda x: x, (f.read(buffer) for _ in repeat(None)))
        return sum(buf.count('\n') for buf in buf_gen)

count_a = iter_count("adguard.txt") -8
count_al = iter_count("allow.txt") -8
count_A = iter_count("adblock.txt") -8
count_d = iter_count("dns.txt") -8

CONTENT = 'AdRules规则更新完毕！ 来自Github~<br>allow.txt共计' + str(count_al) + '条规则，<br>adguard.txt共计' + str(count_a) + '条规则，<br>adblock共计' + str(count_A) + '条规则，<br>dns.txt共计' + str(count_d) + '条规则。'

#def post_tg(message):
#    telegram_message = f"{message}"
#    params = (
#        ('chat_id', CHAT_ID),
#        ('text', telegram_message),
#        ('parse_mode', "Html"),
#        ('disable_web_page_preview', "yes")
#    )
#    telegram_url = "https://api.telegram.org/bot" + TG_TOKEN + "/sendMessage"
#    telegram_req = requests.post(telegram_url, params=params)
#    telegram_status = telegram_req.status_code
#    if telegram_status == 200:
#        print(f"INFO: Telegram Message sent")
#    else:
#        print(telegram_status)

def post_pp():
    TITLE = 'AdRules'
    url = 'http://pushplus.hxtrip.com/send'
    data = {
		  "token":PUSH_TOKEN,
		  "title":TITLE,
		  "content":CONTENT
        }
    body = json.dumps(data).encode(encoding = 'utf-8')
    headers = {'Content-Type':'application/json'}
    requests.post(url, data=body, headers=headers)

#post_tg(CONTENT)
post_pp()
