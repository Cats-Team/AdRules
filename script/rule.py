import os
import sys

gpus = sys.argv[1]
result = []

# 读取文件内容，注意指定newline参数为LF
with open(gpus, "r+", encoding="utf8", newline='') as ffo:
    result = list(set(ffo.readlines()))
    result.sort()

# 重新写入文件，注意指定newline参数为LF
with open(gpus, "w", encoding="utf8", newline='') as ffo:
    ffo.writelines(result)
