import argparse
import os
from datetime import datetime

def log(message):
    """格式化日志输出"""
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"[INFO] {timestamp} - {message}")

def process_rule(file_path):
    if not os.path.exists(file_path):
        log(f"错误: 文件未找到 - {file_path}")
        return

    try:

        # 读取文件
        with open(file_path, 'r', encoding='utf-8') as f:
            lines = f.readlines()

        raw_count = len(lines)
        if raw_count == 0:
            log("文件为空，跳过处理。")
            return

        # 核心逻辑：去重并排序
        unique_lines = sorted(set(lines))
        final_count = len(unique_lines)
        removed_count = raw_count - final_count

        # 写入结果
        with open(file_path, 'w', encoding='utf-8') as f:
            f.writelines(unique_lines)

        # 输出统计结果
        log(f"排序完成 - {raw_count} > {final_count} (移除 {removed_count} 重复项)")

    except Exception as e:
        log(f"处理异常: {e}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="规则去重工具")
    parser.add_argument("file", help="需处理的规则文件路径")
    args = parser.parse_args()

    process_rule(args.file)