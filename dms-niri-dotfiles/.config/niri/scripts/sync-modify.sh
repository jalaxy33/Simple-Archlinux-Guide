#!/usr/bin/env bash

# Git 外部仓库同步脚本
# 用途：将上游更新同步到本地，同时保留自定义修改
#      可以在任何 git 仓库目录下运行

set -e

CUSTOM_BRANCH="my-custom"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

info() { echo -e "${GREEN}>>>${NC} $1"; }
warn() { echo -e "${YELLOW}!!!${NC} $1"; }
error() { echo -e "${RED}xxx${NC} $1"; }
blue() { echo -e "${BLUE}...${NC} $1"; }

# 检查是否在 git 仓库中
check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        error "当前目录不是 git 仓库"
        echo ""
        echo "用法: cd <仓库目录> && $(basename "$0")"
        echo "     或: $(basename "$0") <仓库路径>"
        exit 1
    fi
}

# 显示仓库信息
show_repo_info() {
    REPO_ROOT=$(git rev-parse --show-toplevel)
    REPO_NAME=$(basename "$REPO_ROOT")
    CURRENT_BRANCH=$(git branch --show-current)
    REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "无")

    # 获取所有本地分支
    BRANCHES=$(git branch --format='%(refname:short)')

    echo ""
    blue "仓库信息:"
    echo "  路径: $REPO_ROOT"
    echo "  名称: $REPO_NAME"
    echo "  当前分支: $CURRENT_BRANCH"
    echo "  远程仓库: $REMOTE_URL"
    echo "  本地分支:"
    echo "$BRANCHES" | sed 's/^/    /'
    echo ""
}

# 询问用户确认
confirm() {
    local prompt="$1"
    local response

    echo -n "$prompt [y/N] "
    read -r response
    [[ "$response" =~ ^[Yy]$ ]]
}

# 询问用户输入
ask() {
    local prompt="$1"
    local default="$2"
    local response

    if [[ -n "$default" ]]; then
        echo -ne "\033[0;34m...\033[0m $prompt [$default] " >&2
        read -r response
        echo "${response:-$default}"
    else
        echo -ne "\033[0;34m...\033[0m $prompt " >&2
        read -r response
        echo "$response"
    fi
}

# 获取仓库根目录
get_repo_root() {
    git rev-parse --show-toplevel
}

# 切换到仓库根目录
cd_to_repo_root() {
    cd "$(get_repo_root)" || exit 1
}

# 初始化自定义分支
init_custom_branch() {
    local UPSTREAM_BRANCH=$1

    warn "自定义分支 '$CUSTOM_BRANCH' 不存在，开始初始化..."
    echo ""

    # 保存当前状态
    if [[ -n $(git status --porcelain) ]]; then
        info "保存当前修改..."
        git stash push -m "初始化前的临时保存"
    fi

    # 确保在上游分支且与远程同步
    info "同步 '$UPSTREAM_BRANCH' 分支到远程..."
    git checkout "$UPSTREAM_BRANCH" 2>/dev/null || git checkout -b "$UPSTREAM_BRANCH" "origin/$UPSTREAM_BRANCH"
    git fetch origin
    git reset --hard "origin/$UPSTREAM_BRANCH"

    # 创建自定义分支
    info "创建自定义分支 '$CUSTOM_BRANCH'..."
    git checkout -b "$CUSTOM_BRANCH"

    # 恢复之前保存的修改
    if git stash list | grep -q "初始化前的临时保存"; then
        git stash pop
    fi

    # 提交所有修改（包括未跟踪的文件）
    if [[ -n $(git status --porcelain) ]]; then
        info "提交你的自定义配置..."

        # 显示将要提交的文件
        echo ""
        blue "将要提交的文件:"
        git status --short
        echo ""

        git add -A
        git commit -m "My custom configurations

- 本地自定义配置
- 颜色主题/快捷键等个人设置"
    else
        warn "没有检测到本地修改，创建空的自定义分支..."
    fi

    echo ""
    info "自定义分支已创建: $CUSTOM_BRANCH (基于 $UPSTREAM_BRANCH)"
    echo ""
}

# 执行同步
do_sync() {
    local UPSTREAM_BRANCH=$1
    local ORIGINAL_BRANCH=$(git branch --show-current)

    # 检查自定义分支是否存在
    if ! git show-ref --verify --quiet "refs/heads/$CUSTOM_BRANCH"; then
        if confirm "是否要初始化自定义分支 '$CUSTOM_BRANCH'?"; then
            init_custom_branch "$UPSTREAM_BRANCH"
        else
            error "取消操作"
            exit 1
        fi
    fi

    info "开始从 '$UPSTREAM_BRANCH' 同步上游更新..."
    echo ""

    # 检查当前是否在自定义分支
    local CURRENT_BRANCH=$(git branch --show-current)
    if [[ "$CURRENT_BRANCH" != "$CUSTOM_BRANCH" ]]; then
        blue "切换到 '$CUSTOM_BRANCH' 分支..."
        git checkout "$CUSTOM_BRANCH"
    fi

    # 检查是否有未提交的修改
    local NEED_STASH_POP=false
    if [[ -n $(git status --porcelain) ]]; then
        info "检测到未提交的修改，临时保存到 stash..."
        git stash push -m "同步前的临时保存 $(date +%Y-%m-%d.%H%M%S)"
        NEED_STASH_POP=true
    fi

    # 更新上游分支
    info "更新 '$UPSTREAM_BRANCH' 分支到最新远程..."
    git checkout "$UPSTREAM_BRANCH" > /dev/null 2>&1
    git fetch origin
    local UPSTREAM_HEAD=$(git rev-parse HEAD)
    local ORIGIN_UPSTREAM=$(git rev-parse "origin/$UPSTREAM_BRANCH" 2>/dev/null || echo "$UPSTREAM_HEAD")

    if [[ "$UPSTREAM_HEAD" == "$ORIGIN_UPSTREAM" ]]; then
        info "'$UPSTREAM_BRANCH' 分支已是最新，无需更新"
    else
        local NEW_COMMITS=$(git log --oneline "$UPSTREAM_HEAD..$ORIGIN_UPSTREAM" 2>/dev/null | wc -l)
        info "已获取 $NEW_COMMITS 个新提交"
        git reset --hard "origin/$UPSTREAM_BRANCH"
    fi

    # Rebase 自定义分支
    info "正在 rebase '$CUSTOM_BRANCH' 到最新的 '$UPSTREAM_BRANCH'..."
    git checkout "$CUSTOM_BRANCH" > /dev/null 2>&1

    if git rebase "$UPSTREAM_BRANCH"; then
        echo ""
        info "Rebase 成功！"
        echo ""

        # 显示更新内容
        if [[ "$UPSTREAM_HEAD" != "$ORIGIN_UPSTREAM" ]]; then
            info "本次更新的内容："
            git log --oneline "$UPSTREAM_BRANCH~1..$UPSTREAM_BRANCH" --no-decorate 2>/dev/null || echo "  (无法获取更新日志)"
            echo ""
        fi

        # 恢复暂存的修改
        if $NEED_STASH_POP; then
            info "恢复之前暂存的修改..."
            git stash pop
        fi

        # 检查是否有未提交的修改
        if [[ -n $(git status --porcelain) ]]; then
            info "检测到未提交的修改，准备提交..."
            echo ""
            blue "未提交的文件:"
            git status --short
            echo ""

            if confirm "是否要提交这些修改到 '$CUSTOM_BRANCH' 本地分支?"; then
                git add -A
                git commit -m "Update local modification $(date +%Y-%m-%d)"
                info "提交成功！"
                echo ""
            else
                warn "跳过提交，保留未提交状态"
                echo ""
            fi
        fi

        info "同步完成！"
        echo ""
        echo "当前分支: $CUSTOM_BRANCH"
        echo "上游分支: $UPSTREAM_BRANCH ($(git log -1 --format='%h %s' "$UPSTREAM_BRANCH"))"
        echo ""

    else
        echo ""
        error "Rebase 过程中遇到冲突，需要手动解决"
        echo ""
        echo "冲突文件："
        git status --short | grep "^UU" || git status --short
        echo ""
        echo "解决冲突的步骤："
        echo "  1. 编辑冲突文件，解决冲突"
        echo "  2. 添加已解决的文件: ${GREEN}git add <文件>${NC}"
        echo "  3. 继续 rebase: ${GREEN}git rebase --continue${NC}"
        echo ""
        echo "如果想放弃本次同步："
        echo "  ${GREEN}git rebase --abort${NC}"
        echo "  ${GREEN}git checkout $ORIGINAL_BRANCH${NC}"
        echo ""
        exit 1
    fi

    # 可选：返回原始分支
    if [[ "$ORIGINAL_BRANCH" != "$CUSTOM_BRANCH" ]] && [[ -n "$ORIGINAL_BRANCH" ]]; then
        if confirm "是否切换回原始分支 '$ORIGINAL_BRANCH'?"; then
            info "切换回原始分支: $ORIGINAL_BRANCH"
            git checkout "$ORIGINAL_BRANCH" > /dev/null 2>&1 || true
        fi
    fi
}

# ===== 主程序 =====

# 支持传入仓库路径参数
if [[ -n "$1" ]]; then
    if [[ -d "$1" ]]; then
        cd "$1" || { error "无法进入目录: $1"; exit 1; }
    else
        error "目录不存在: $1"
        exit 1
    fi
fi

check_git_repo
show_repo_info

if ! confirm "是否要同步此仓库?"; then
    echo "取消操作"
    exit 0
fi

# 询问要同步的分支
echo ""
UPSTREAM_BRANCH=$(ask "请输入要同步的上游分支名称" "main")

# 验证分支是否存在
if ! git show-ref --verify --quiet "refs/heads/$UPSTREAM_BRANCH" && ! git ls-remote --heads origin "$UPSTREAM_BRANCH" | grep -q "$UPSTREAM_BRANCH"; then
    warn "分支 '$UPSTREAM_BRANCH' 不存在（本地或远程）"
    if confirm "是否仍然继续（将创建该分支）?"; then
        : # 继续
    else
        error "取消操作"
        exit 1
    fi
fi

cd_to_repo_root
do_sync "$UPSTREAM_BRANCH"
