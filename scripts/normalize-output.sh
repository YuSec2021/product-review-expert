#!/usr/bin/env bash
set -euo pipefail

# product-review-expert 输出规范化脚本
# 当前版本：占位实现，不修改 Claude 输出，只保留为后续扩展入口。
# 后续可扩展能力：
# 1. 自动检查输出中是否包含 P0/P1/P2
# 2. 自动补全缺失标题
# 3. 自动记录评审日志到 ${CLAUDE_PLUGIN_DATA}
# 4. 输出评审统计信息

LOG_DIR="${CLAUDE_PLUGIN_DATA:-/tmp}/product-review-expert"
mkdir -p "$LOG_DIR"

echo "$(date '+%Y-%m-%d %H:%M:%S') normalize-review-output executed" >> "$LOG_DIR/hook.log"

exit 0