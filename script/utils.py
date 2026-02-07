import os
import re
import sys
from datetime import datetime, timezone, timedelta

def read_file(file_path, skip_comments=True):
    """读取文件并返回行列表"""
    if not os.path.exists(file_path):
        return []
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            lines = [line.strip() for line in f if line.strip()]
            if skip_comments:
                lines = [l for l in lines if not l.startswith(('#', '!', '['))]
            return lines
    except Exception as e:
        print(f"Error reading {file_path}: {e}")
        return []

def write_file(file_path, lines):
    """将行列表写入文件"""
    try:
        with open(file_path, 'w', encoding='utf-8', newline='\n') as f:
            for line in lines:
                f.write(line + '\n')
    except Exception as e:
        print(f"Error writing {file_path}: {e}")

def get_bj_time():
    """获取北京时间"""
    bj_tz = timezone(timedelta(hours=8))
    return datetime.now(bj_tz)

def format_bj_time(fmt='%Y-%m-%d %H:%M:%S'):
    """格式化北京时间"""
    return get_bj_time().strftime(fmt)
