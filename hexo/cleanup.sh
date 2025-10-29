#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$repo_root"

# 添加并提交 .gitignore 文件
git add .gitignore hexo/.gitignore
git commit -m "chore: add .gitignore for node_modules and build outputs" || true

# 从索引移除常见已被跟踪的生成文件（仅移除缓存，不删除本地文件）
git rm -r --cached node_modules || true
git rm -r --cached hexo/node_modules || true
git rm -r --cached hexo/public || true
git rm -r --cached hexo/.deploy_git || true
git rm -r --cached hexo/db.json || true
git rm -r --cached themes/*/node_modules || true

git add -A
git commit -m "chore: remove tracked build artifacts and node_modules from repo" || true

echo "清理完成。请检查 git 状态并手动推送变更（git push）。"