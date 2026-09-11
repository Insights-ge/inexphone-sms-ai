#!/usr/bin/env bash

set -e

TARGET="$(pwd)"
TOOLS="all"
DRY_RUN=false
SKILL_NAME="inexphone-sms-integration-skill"
BACKUP_MANIFEST=""

usage() {
    cat <<EOF
Usage:
  ./uninstall.sh [options]

Options:
  --target PATH       Project directory to uninstall from (default: current directory)
  --tools LIST        Tools to uninstall:
                      codex,claude,cursor,gemini,junie,opencode
                      or all (default: all)
  --dry-run           Show what would be removed without changing files
  --help              Show this help message

Examples:
  ./uninstall.sh
  ./uninstall.sh --tools claude
  ./uninstall.sh --tools codex,gemini
  ./uninstall.sh --tools all --dry-run
EOF
}

contains_tool() {
    local list="$1"
    local tool="$2"

    [[ ",$list," == *",$tool,"* ]]
}

remove_file() {
    local file="$1"

    if [[ ! -e "$file" ]]; then
        return
    fi

    echo "Removing: $file"

    if [[ "$DRY_RUN" == true ]]; then
        return
    fi

    rm -f "$file"

    if [[ ! -f "$BACKUP_MANIFEST" ]]; then
        return
    fi

    local backup
    backup="$(awk -F'|' -v target="$file" '$1 == target { print $2; exit }' "$BACKUP_MANIFEST")"

    if [[ -n "$backup" && -e "$backup" ]]; then
        echo "Restoring backup: $backup"
        mv "$backup" "$file"
    fi
}

remove_directory() {
    local dir="$1"

    if [[ ! -d "$dir" ]]; then
        return
    fi

    echo "Removing directory: $dir"

    if [[ "$DRY_RUN" == true ]]; then
        return
    fi

    rm -rf "$dir"
}

remove_empty_parent() {
    local dir="$1"

    if [[ ! -d "$dir" ]]; then
        return
    fi

    if [[ -z "$(find "$dir" -mindepth 1 -maxdepth 1 -print -quit)" ]]; then
        echo "Removing empty directory: $dir"

        if [[ "$DRY_RUN" == false ]]; then
            rmdir "$dir"
        fi
    fi
}

should_remove_shared_agents_skill() {
    if [[ "$TOOLS" == "all" ]]; then
        return 0
    fi

    local codex_selected=false
    local gemini_selected=false

    if contains_tool "$TOOLS" "codex"; then
        codex_selected=true
    fi

    if contains_tool "$TOOLS" "gemini"; then
        gemini_selected=true
    fi

    [[ "$codex_selected" == true && "$gemini_selected" == true ]]
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --target)
            TARGET="$2"
            shift 2
            ;;

        --tools)
            TOOLS="$2"
            shift 2
            ;;

        --dry-run)
            DRY_RUN=true
            shift
            ;;

        --help|-h)
            usage
            exit 0
            ;;

        *)
            echo "Unknown option: $1"
            echo
            usage
            exit 1
            ;;
    esac
done

if [[ "$TARGET" != /* ]]; then
    TARGET="$(cd "$TARGET" && pwd)"
fi

if [[ ! -d "$TARGET" ]]; then
    echo "Error: target directory does not exist:"
    echo "$TARGET"
    exit 1
fi

BACKUP_MANIFEST="$TARGET/.inexphone-sms-backups"

echo "=========================================="
echo "InexPhone SMS AI - Uninstaller"
echo "=========================================="
echo
echo "Target: $TARGET"
echo "Tools:  $TOOLS"
echo "Dry run: $DRY_RUN"
echo

# --------------------------------------------------
# Shared .agents skill
# Used by Codex and Gemini.
# --------------------------------------------------

if should_remove_shared_agents_skill; then
    echo "[Shared .agents skill]"

    remove_directory \
        "$TARGET/.agents/skills/$SKILL_NAME"

    remove_empty_parent "$TARGET/.agents/skills"
    remove_empty_parent "$TARGET/.agents"
else
    echo "[Shared .agents skill]"
    echo "Keeping shared skill because both Codex and Gemini were not selected."
fi

echo

# --------------------------------------------------
# Codex
# --------------------------------------------------

if [[ "$TOOLS" == "all" ]] || contains_tool "$TOOLS" "codex"; then
    echo "[Codex]"
    echo "Codex uses the shared .agents skill."
else
    echo "[Codex] Skipped."
fi

echo

# --------------------------------------------------
# Claude Code
# --------------------------------------------------

if [[ "$TOOLS" == "all" ]] || contains_tool "$TOOLS" "claude"; then
    echo "[Claude Code]"

    remove_directory \
        "$TARGET/.claude/skills/$SKILL_NAME"

    remove_file \
        "$TARGET/CLAUDE.md"

    remove_empty_parent "$TARGET/.claude/skills"
    remove_empty_parent "$TARGET/.claude"
else
    echo "[Claude Code] Skipped."
fi

echo

# --------------------------------------------------
# Cursor
# --------------------------------------------------

if [[ "$TOOLS" == "all" ]] || contains_tool "$TOOLS" "cursor"; then
    echo "[Cursor]"

    remove_file \
        "$TARGET/.cursor/rules/$SKILL_NAME.mdc"

    remove_directory \
        "$TARGET/.cursor/inexphone-sms"

    remove_empty_parent "$TARGET/.cursor/rules"
    remove_empty_parent "$TARGET/.cursor"
else
    echo "[Cursor] Skipped."
fi

echo

# --------------------------------------------------
# Gemini CLI
# --------------------------------------------------

if [[ "$TOOLS" == "all" ]] || contains_tool "$TOOLS" "gemini"; then
    echo "[Gemini CLI]"

    remove_file \
        "$TARGET/GEMINI.md"

    echo "Gemini CLI uses the shared .agents skill."
else
    echo "[Gemini CLI] Skipped."
fi

echo

# --------------------------------------------------
# Junie
# --------------------------------------------------

if [[ "$TOOLS" == "all" ]] || contains_tool "$TOOLS" "junie"; then
    echo "[Junie]"

    remove_file \
        "$TARGET/.junie/AGENTS.md"

    remove_empty_parent "$TARGET/.junie"
else
    echo "[Junie] Skipped."
fi

echo

# --------------------------------------------------
# OpenCode
# --------------------------------------------------

if [[ "$TOOLS" == "all" ]] || contains_tool "$TOOLS" "opencode"; then
    echo "[OpenCode]"

    remove_directory \
        "$TARGET/.opencode/skills/$SKILL_NAME"

    remove_empty_parent "$TARGET/.opencode/skills"
    remove_empty_parent "$TARGET/.opencode"
else
    echo "[OpenCode] Skipped."
fi

echo
echo "=========================================="

if [[ "$DRY_RUN" == true ]]; then
    echo "Dry run complete. No files were changed."
else
    echo "Uninstallation complete."
fi

if [[ "$DRY_RUN" == false && -f "$BACKUP_MANIFEST" ]]; then
    rm -f "$BACKUP_MANIFEST"
fi

echo "=========================================="
