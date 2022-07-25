# -*- coding:utf-8 -*-
import os
import sys
gpus = sys.argv[1]
result = []
ffo = open(gpus,"r+",encoding="utf8")
result=list(set(ffo.readlines()))
result.sort()
ffo.seek(0)
ffo.truncate(0)
ffo.writelines(result)
ffo.close()
