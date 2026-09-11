#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="$(pwd)"
TOOLS="all"
DRY_RUN=false
SKILL_NAME="inexphone-sms-integration-skill"
BACKUP_MANIFEST=""

usage() {
    cat <<EOF
Usage:
  ./install.sh [options]

Options:
  --target PATH       Project directory to install into (default: current directory)
  --tools LIST        Tools to install:
                      codex,claude,cursor,gemini,junie,opencode
                      or all (default: all)
  --dry-run           Show what would be installed without changing files
  --help              Show this help message

Examples:
  ./install.sh
  ./install.sh --tools claude
  ./install.sh --tools codex,gemini
  ./install.sh --tools all --dry-run
EOF
}

contains_tool() {
    local list="$1"
    local tool="$2"

    [[ ",$list," == *",$tool,"* ]]
}

backup_file() {
    local file="$1"

    if [[ ! -e "$file" ]]; then
        return
    fi

    local timestamp
    timestamp="$(date +%Y%m%d%H%M%S)"

    local backup="${file}.backup.${timestamp}"

    echo "Backing up: $file"
    echo "        -> $backup"

    if [[ "$DRY_RUN" == false ]]; then
        mv "$file" "$backup"

        if [[ -n "$BACKUP_MANIFEST" ]]; then
            printf '%s|%s\n' "$file" "$backup" >> "$BACKUP_MANIFEST"
        fi
    fi
}

backup_directory() {
    local dir="$1"

    if [[ ! -d "$dir" ]]; then
        return
    fi

    local timestamp
    timestamp="$(date +%Y%m%d%H%M%S)"

    local backup="${dir}.backup.${timestamp}"

    echo "Backing up directory: $dir"
    echo "                    -> $backup"

    if [[ "$DRY_RUN" == false ]]; then
        mv "$dir" "$backup"

        if [[ -n "$BACKUP_MANIFEST" ]]; then
            printf '%s|%s\n' "$dir" "$backup" >> "$BACKUP_MANIFEST"
        fi
    fi
}

copy_file() {
    local source="$1"
    local destination="$2"

    echo "Installing: $destination"

    if [[ "$DRY_RUN" == true ]]; then
        return
    fi

    mkdir -p "$(dirname "$destination")"
    cp "$source" "$destination"
}

copy_directory_contents() {
    local source="$1"
    local destination="$2"

    echo "Installing shared skill:"
    echo "  $destination"

    if [[ "$DRY_RUN" == true ]]; then
        while IFS= read -r -d '' file; do
            local relative
            relative="${file#$source/}"

            echo "Installing: $destination/$relative"
        done < <(find "$source" -type f -print0)

        return
    fi

    mkdir -p "$destination"

    while IFS= read -r -d '' file; do
        local relative
        relative="${file#$source/}"

        mkdir -p "$destination/$(dirname "$relative")"
        cp "$file" "$destination/$relative"

        echo "Installing: $destination/$relative"
    done < <(find "$source" -type f -print0)
}

install_shared_skill() {
    local destination="$1"

    echo "Installing shared skill:"
    echo "  $destination"

    if [[ -d "$destination" ]]; then
        backup_directory "$destination"
    fi

    if [[ "$DRY_RUN" == false ]]; then
        mkdir -p "$destination"
    fi

    copy_file \
        "$SCRIPT_DIR/SKILL.md" \
        "$destination/SKILL.md"

    copy_directory_contents \
        "$SCRIPT_DIR/docs" \
        "$destination/docs"

    copy_directory_contents \
        "$SCRIPT_DIR/examples" \
        "$destination/examples"
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --target)
            if [[ -z "${2:-}" ]]; then
                echo "Error: --target requires a path."
                exit 1
            fi

            TARGET="$2"
            shift 2
            ;;

        --tools)
            if [[ -z "${2:-}" ]]; then
                echo "Error: --tools requires a list."
                exit 1
            fi

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

if [[ "$DRY_RUN" == false ]]; then
    BACKUP_MANIFEST="$TARGET/.inexphone-sms-backups"
    : > "$BACKUP_MANIFEST"
fi


# --------------------------------------------------
# Validate repository files
# --------------------------------------------------

echo "Checking package knowledge files..."

required_files=(
    "$SCRIPT_DIR/SKILL.md"
    "$SCRIPT_DIR/docs/installation.md"
    "$SCRIPT_DIR/docs/sms.md"
    "$SCRIPT_DIR/docs/otp.md"
    "$SCRIPT_DIR/docs/blacklist.md"
    "$SCRIPT_DIR/examples/sms.md"
    "$SCRIPT_DIR/examples/otp.md"
    "$SCRIPT_DIR/examples/blacklist.md"
)

for file in "${required_files[@]}"; do
    if [[ ! -f "$file" ]]; then
        echo "Error: required file is missing:"
        echo "$file"
        exit 1
    fi
done

echo "All required files found."
echo

# --------------------------------------------------
# Start
# --------------------------------------------------

echo "=========================================="
echo "InexPhone SMS AI - Installer"
echo "=========================================="
echo
echo "Source: $SCRIPT_DIR"
echo "Target: $TARGET"
echo "Tools:  $TOOLS"
echo "Dry run: $DRY_RUN"
echo

# --------------------------------------------------
# Shared .agents skill
# Used by Codex and Gemini.
# --------------------------------------------------

if [[ "$TOOLS" == "all" ]] ||
   contains_tool "$TOOLS" "codex" ||
   contains_tool "$TOOLS" "gemini"; then

    install_shared_skill \
        "$TARGET/.agents/skills/$SKILL_NAME"
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

    install_shared_skill \
        "$TARGET/.claude/skills/$SKILL_NAME"

    backup_file "$TARGET/CLAUDE.md"

    copy_file \
        "$SCRIPT_DIR/agents/CLAUDE.md" \
        "$TARGET/CLAUDE.md"
else
    echo "[Claude Code] Skipped."
fi

echo

# --------------------------------------------------
# Cursor
# --------------------------------------------------

if [[ "$TOOLS" == "all" ]] || contains_tool "$TOOLS" "cursor"; then
    echo "[Cursor]"

    copy_file \
        "$SCRIPT_DIR/agents/cursor-rules.md" \
        "$TARGET/.cursor/rules/$SKILL_NAME.mdc"

    install_shared_skill \
        "$TARGET/.cursor/inexphone-sms"
else
    echo "[Cursor] Skipped."
fi

echo

# --------------------------------------------------
# Gemini CLI
# --------------------------------------------------

if [[ "$TOOLS" == "all" ]] || contains_tool "$TOOLS" "gemini"; then
    echo "[Gemini CLI]"

    copy_file \
        "$SCRIPT_DIR/agents/GEMINI.md" \
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

    copy_file \
        "$SCRIPT_DIR/agents/JUNIE.md" \
        "$TARGET/.junie/AGENTS.md"
else
    echo "[Junie] Skipped."
fi

echo

# --------------------------------------------------
# OpenCode
# --------------------------------------------------

if [[ "$TOOLS" == "all" ]] || contains_tool "$TOOLS" "opencode"; then
    echo "[OpenCode]"

    install_shared_skill \
        "$TARGET/.opencode/skills/$SKILL_NAME"
else
    echo "[OpenCode] Skipped."
fi

echo
echo "=========================================="

if [[ "$DRY_RUN" == true ]]; then
    echo "Dry run complete. No files were changed."
else
    echo "Installation complete."
fi

echo "=========================================="
