#!/bin/bash
# CoDeck - Project Scanner
# Outputs a structured JSON summary of the project for dashboard generation.
# Usage: bash scripts/scan_project.sh [project_root]

set -euo pipefail

PROJECT_ROOT="${1:-.}"
cd "$PROJECT_ROOT"

echo "{"

# Project name — from package.json, pyproject.toml, Cargo.toml, or directory name
PROJECT_NAME=""
if [ -f "package.json" ]; then
  PROJECT_NAME=$(python3 -c "import json; print(json.load(open('package.json')).get('name',''))" 2>/dev/null || echo "")
elif [ -f "pyproject.toml" ]; then
  PROJECT_NAME=$(grep -m1 '^name' pyproject.toml 2>/dev/null | sed 's/name *= *"\(.*\)"/\1/' || echo "")
elif [ -f "Cargo.toml" ]; then
  PROJECT_NAME=$(grep -m1 '^name' Cargo.toml 2>/dev/null | sed 's/name *= *"\(.*\)"/\1/' || echo "")
fi
if [ -z "$PROJECT_NAME" ]; then
  PROJECT_NAME=$(basename "$(pwd)")
fi
echo "  \"project_name\": \"$PROJECT_NAME\","

# Tech stack detection
echo "  \"tech_stack\": ["
STACK=()
[ -f "package.json" ] && STACK+=("\"Node.js\"")
[ -f "requirements.txt" ] || [ -f "pyproject.toml" ] || [ -f "setup.py" ] && STACK+=("\"Python\"")
[ -f "Cargo.toml" ] && STACK+=("\"Rust\"")
[ -f "go.mod" ] && STACK+=("\"Go\"")
[ -f "Gemfile" ] && STACK+=("\"Ruby\"")
[ -f "pom.xml" ] || [ -f "build.gradle" ] && STACK+=("\"Java\"")
[ -f "tsconfig.json" ] && STACK+=("\"TypeScript\"")
[ -f "next.config.js" ] || [ -f "next.config.mjs" ] || [ -f "next.config.ts" ] && STACK+=("\"Next.js\"")
[ -f "nuxt.config.js" ] || [ -f "nuxt.config.ts" ] && STACK+=("\"Nuxt\"")
[ -f "vite.config.js" ] || [ -f "vite.config.ts" ] && STACK+=("\"Vite\"")
[ -f "tailwind.config.js" ] || [ -f "tailwind.config.ts" ] && STACK+=("\"Tailwind CSS\"")
[ -f "docker-compose.yml" ] || [ -f "Dockerfile" ] && STACK+=("\"Docker\"")
[ -d "prisma" ] && STACK+=("\"Prisma\"")
[ -f ".env" ] || [ -f ".env.local" ] && STACK+=("\"Environment Config\"")

# Join array with commas
OLDIFS=$IFS
IFS=','
echo "    ${STACK[*]:-}"
IFS=$OLDIFS
echo "  ],"

# File tree (excluding common non-essential dirs)
echo "  \"file_tree\": ["
find . -type f \
  -not -path '*/node_modules/*' \
  -not -path '*/.git/*' \
  -not -path '*/dist/*' \
  -not -path '*/build/*' \
  -not -path '*/__pycache__/*' \
  -not -path '*/venv/*' \
  -not -path '*/.next/*' \
  -not -path '*/.nuxt/*' \
  -not -path '*/coverage/*' \
  -not -path '*/.cache/*' \
  -not -name '*.lock' \
  -not -name 'package-lock.json' \
  -not -name 'yarn.lock' \
  -not -name 'pnpm-lock.yaml' \
  2>/dev/null | sort | head -500 | while read -r f; do
    echo "    \"$f\","
done
echo "    \"__end__\""
echo "  ],"

# File count by extension
echo "  \"file_stats\": {"
find . -type f \
  -not -path '*/node_modules/*' \
  -not -path '*/.git/*' \
  -not -path '*/dist/*' \
  -not -path '*/build/*' \
  -not -path '*/__pycache__/*' \
  -not -path '*/venv/*' \
  2>/dev/null | sed 's/.*\.//' | sort | uniq -c | sort -rn | head -20 | while read -r count ext; do
    echo "    \".$ext\": $count,"
done
echo "    \"__end__\": 0"
echo "  },"

# TODO/FIXME/HACK count
TODO_COUNT=$(grep -r "TODO\|FIXME\|HACK\|XXX" --include='*.js' --include='*.ts' --include='*.py' --include='*.rb' --include='*.go' --include='*.rs' --include='*.jsx' --include='*.tsx' --include='*.vue' --include='*.svelte' . 2>/dev/null | grep -v node_modules | grep -v '.git' | wc -l || echo "0")
echo "  \"todo_count\": $TODO_COUNT,"

# Total file count
TOTAL_FILES=$(find . -type f -not -path '*/node_modules/*' -not -path '*/.git/*' -not -path '*/dist/*' -not -path '*/build/*' -not -path '*/__pycache__/*' -not -path '*/venv/*' 2>/dev/null | wc -l || echo "0")
echo "  \"total_files\": $TOTAL_FILES,"

# Dependency count
DEP_COUNT=0
if [ -f "package.json" ]; then
  DEP_COUNT=$(python3 -c "
import json
p = json.load(open('package.json'))
deps = len(p.get('dependencies', {})) + len(p.get('devDependencies', {}))
print(deps)
" 2>/dev/null || echo "0")
elif [ -f "requirements.txt" ]; then
  DEP_COUNT=$(grep -c -v '^#\|^$' requirements.txt 2>/dev/null || echo "0")
fi
echo "  \"dependency_count\": $DEP_COUNT,"

# Has tests?
HAS_TESTS="false"
[ -d "tests" ] || [ -d "test" ] || [ -d "__tests__" ] || [ -d "spec" ] && HAS_TESTS="true"
find . -name '*.test.*' -o -name '*.spec.*' -o -name 'test_*' 2>/dev/null | head -1 | grep -q . && HAS_TESTS="true"
echo "  \"has_tests\": $HAS_TESTS,"

# Recent git commits (last 10)
echo "  \"recent_commits\": ["
if [ -d ".git" ]; then
  git log --oneline -10 --format='    "%s",' 2>/dev/null || true
fi
echo "    \"__end__\""
echo "  ],"

# --- Growth Story Data ---
echo "  \"growth\": {"

if [ -d ".git" ]; then
  # First commit date
  FIRST_COMMIT=$(git log --reverse --format='%aI' 2>/dev/null | head -1 || echo "")
  echo "    \"first_commit\": \"$FIRST_COMMIT\","

  # Total commit count
  TOTAL_COMMITS=$(git rev-list --count HEAD 2>/dev/null || echo "0")
  echo "    \"total_commits\": $TOTAL_COMMITS,"

  # Commits per week (last 52 weeks)
  echo "    \"commits_by_week\": ["
  for i in $(seq 51 -1 0); do
    WEEK_START=$(date -d "$i weeks ago" +%Y-%m-%d 2>/dev/null || date -v-${i}w +%Y-%m-%d 2>/dev/null || echo "")
    if [ -n "$WEEK_START" ]; then
      WEEK_END=$(date -d "$((i-1)) weeks ago" +%Y-%m-%d 2>/dev/null || date -v-$((i-1))w +%Y-%m-%d 2>/dev/null || echo "")
      COUNT=$(git rev-list --count --after="$WEEK_START" --before="$WEEK_END" HEAD 2>/dev/null || echo "0")
      echo "      {\"week\": \"$WEEK_START\", \"count\": $COUNT},"
    fi
  done
  echo "      {\"week\": \"__end__\", \"count\": 0}"
  echo "    ],"

  # Commits by day of week
  echo "    \"commits_by_day_of_week\": {"
  for DAY in Mon Tue Wed Thu Fri Sat Sun; do
    COUNT=$(git log --format='%ad' --date=format:'%a' 2>/dev/null | grep -c "^$DAY" || echo "0")
    echo "      \"$DAY\": $COUNT,"
  done
  echo "      \"__end__\": 0"
  echo "    },"

  # Commits by hour of day (for night owl detection etc.)
  echo "    \"commits_by_hour\": {"
  for HOUR in $(seq 0 23); do
    PADDED=$(printf "%02d" $HOUR)
    COUNT=$(git log --format='%ad' --date=format:'%H' 2>/dev/null | grep -c "^$PADDED" || echo "0")
    echo "      \"$PADDED\": $COUNT,"
  done
  echo "      \"__end__\": 0"
  echo "    },"

  # Milestone commits (feat, add, launch, release, deploy, init, ship, complete, first, v1, v2)
  echo "    \"milestones\": ["
  git log --format='{"date": "%aI", "message": "%s"}' --grep='feat\|add\|launch\|release\|deploy\|init\|ship\|complete\|first\|v[0-9]' -i 2>/dev/null | head -30 | while read -r line; do
    echo "      $line,"
  done
  echo "      {\"date\": \"__end__\", \"message\": \"__end__\"}"
  echo "    ],"

  # Lines of code snapshots (sample 10 points across history)
  echo "    \"lines_over_time\": ["
  SAMPLE_COUNT=10
  STEP=$((TOTAL_COMMITS / SAMPLE_COUNT))
  [ "$STEP" -lt 1 ] && STEP=1
  for i in $(seq 0 $((SAMPLE_COUNT - 1))); do
    SKIP=$((i * STEP))
    COMMIT_HASH=$(git rev-list HEAD --reverse 2>/dev/null | sed -n "$((SKIP + 1))p" || echo "")
    if [ -n "$COMMIT_HASH" ]; then
      COMMIT_DATE=$(git show -s --format='%aI' "$COMMIT_HASH" 2>/dev/null || echo "")
      # Count lines in tracked files at that commit (fast approximation)
      LINE_COUNT=$(git diff-tree --numstat -r --root "$COMMIT_HASH" 2>/dev/null | awk '{s+=$1} END {print s+0}' || echo "0")
      echo "      {\"date\": \"$COMMIT_DATE\", \"lines\": $LINE_COUNT},"
    fi
  done
  # Always include current
  CURRENT_LINES=$(find . -type f \( -name '*.js' -o -name '*.ts' -o -name '*.py' -o -name '*.go' -o -name '*.rs' -o -name '*.rb' -o -name '*.jsx' -o -name '*.tsx' -o -name '*.vue' -o -name '*.svelte' -o -name '*.css' -o -name '*.html' \) -not -path '*/node_modules/*' -not -path '*/.git/*' -not -path '*/dist/*' 2>/dev/null | xargs wc -l 2>/dev/null | tail -1 | awk '{print $1}' || echo "0")
  echo "      {\"date\": \"$(date -Iseconds)\", \"lines\": $CURRENT_LINES}"
  echo "    ],"

  # Streak detection (consecutive days with commits)
  echo "    \"max_streak_days\": $(git log --format='%ad' --date=format:'%Y-%m-%d' 2>/dev/null | sort -u | awk '
    BEGIN { max=0; streak=1; prev="" }
    {
      if (prev != "") {
        cmd = "date -d \"" prev " +1 day\" +%Y-%m-%d 2>/dev/null"
        cmd | getline expected
        close(cmd)
        if ($1 == expected) { streak++ } else { if (streak > max) max=streak; streak=1 }
      }
      prev = $1
    }
    END { if (streak > max) max=streak; print max }
  ' 2>/dev/null || echo "0"),"

  # Contributor count
  CONTRIBUTOR_COUNT=$(git shortlog -s HEAD 2>/dev/null | wc -l || echo "0")
  echo "    \"contributor_count\": $CONTRIBUTOR_COUNT"

else
  echo "    \"available\": false"
fi

echo "  },"

# Language detection — multi-signal
HAS_README="false"
echo "  \"language_signals\": {"

# Signal 1: README language
README_LANG="none"
if [ -f "README.md" ] || [ -f "readme.md" ] || [ -f "README.rst" ]; then
  HAS_README="true"
  README_FILE=$(ls README.md readme.md README.rst 2>/dev/null | head -1)
  if [ -n "$README_FILE" ]; then
    ZH_LINES=$(grep -P '[\x{4e00}-\x{9fff}]' "$README_FILE" 2>/dev/null | wc -l || echo "0")
    TOTAL_LINES=$(wc -l < "$README_FILE" 2>/dev/null || echo "0")
    if [ "$ZH_LINES" -gt 5 ] && [ "$TOTAL_LINES" -gt 0 ]; then
      ZH_RATIO=$((ZH_LINES * 100 / TOTAL_LINES))
      if [ "$ZH_RATIO" -gt 30 ]; then
        README_LANG="zh"
      else
        README_LANG="en"
      fi
    elif [ "$TOTAL_LINES" -gt 0 ]; then
      README_LANG="en"
    fi
  fi
fi
echo "    \"readme\": \"$README_LANG\","

# Signal 2: Code comments language (sample up to 20 source files)
COMMENT_ZH=0
COMMENT_TOTAL=0
for f in $(find . -type f \( -name '*.js' -o -name '*.ts' -o -name '*.py' -o -name '*.jsx' -o -name '*.tsx' -o -name '*.vue' -o -name '*.go' -o -name '*.rs' -o -name '*.rb' \) -not -path '*/node_modules/*' -not -path '*/.git/*' -not -path '*/dist/*' 2>/dev/null | head -20); do
  FILE_COMMENTS=$(grep -c '//\|#\|/\*\|"""' "$f" 2>/dev/null || echo "0")
  FILE_ZH=$(grep -P '[\x{4e00}-\x{9fff}]' "$f" 2>/dev/null | wc -l || echo "0")
  COMMENT_TOTAL=$((COMMENT_TOTAL + FILE_COMMENTS))
  COMMENT_ZH=$((COMMENT_ZH + FILE_ZH))
done
if [ "$COMMENT_TOTAL" -gt 5 ]; then
  ZH_PCT=$((COMMENT_ZH * 100 / COMMENT_TOTAL))
  if [ "$ZH_PCT" -gt 60 ]; then
    echo "    \"comments\": \"zh\","
  elif [ "$ZH_PCT" -lt 20 ]; then
    echo "    \"comments\": \"en\","
  else
    echo "    \"comments\": \"mixed\","
  fi
else
  echo "    \"comments\": \"insufficient\","
fi

# Signal 3: Commit messages language (last 20 commits)
COMMIT_LANG="none"
if [ -d ".git" ]; then
  COMMIT_MSGS=$(git log --oneline -20 --format='%s' 2>/dev/null || echo "")
  if [ -n "$COMMIT_MSGS" ]; then
    COMMIT_ZH=$(echo "$COMMIT_MSGS" | grep -cP '[\x{4e00}-\x{9fff}]' 2>/dev/null || echo "0")
    COMMIT_COUNT=$(echo "$COMMIT_MSGS" | wc -l || echo "0")
    if [ "$COMMIT_COUNT" -gt 0 ]; then
      ZH_COMMIT_PCT=$((COMMIT_ZH * 100 / COMMIT_COUNT))
      if [ "$ZH_COMMIT_PCT" -gt 60 ]; then
        COMMIT_LANG="zh"
      elif [ "$ZH_COMMIT_PCT" -lt 20 ]; then
        COMMIT_LANG="en"
      else
        COMMIT_LANG="mixed"
      fi
    fi
  fi
fi
echo "    \"commits\": \"$COMMIT_LANG\","

# Signal 4: Package description
PKG_LANG="none"
if [ -f "package.json" ]; then
  PKG_DESC=$(python3 -c "import json; print(json.load(open('package.json')).get('description',''))" 2>/dev/null || echo "")
  if [ -n "$PKG_DESC" ]; then
    PKG_ZH=$(echo "$PKG_DESC" | grep -cP '[\x{4e00}-\x{9fff}]' 2>/dev/null || echo "0")
    if [ "$PKG_ZH" -gt 0 ]; then PKG_LANG="zh"; else PKG_LANG="en"; fi
  fi
fi
echo "    \"package_desc\": \"$PKG_LANG\""

echo "  },"
echo "  \"has_readme\": $HAS_README,"

# Entry points
echo "  \"entry_points\": ["
for f in main.* app.* index.* server.* src/main.* src/app.* src/index.* src/server.*; do
  [ -f "$f" ] && echo "    \"$f\","
done
echo "    \"__end__\""
echo "  ],"

# Route files (heuristic)
echo "  \"route_files\": ["
find . -type f \( -path '*/routes/*' -o -path '*/router/*' -o -path '*/api/*' -o -path '*/pages/*' -o -path '*/app/*' \) \
  -not -path '*/node_modules/*' -not -path '*/.git/*' \
  2>/dev/null | head -30 | while read -r f; do
    echo "    \"$f\","
done
echo "    \"__end__\""
echo "  ],"

# Model/schema files (heuristic)
echo "  \"model_files\": ["
find . -type f \( -path '*/models/*' -o -path '*/schema*' -o -path '*/entities/*' -o -path '*/prisma/*' -o -name '*.model.*' -o -name '*.schema.*' \) \
  -not -path '*/node_modules/*' -not -path '*/.git/*' \
  2>/dev/null | head -30 | while read -r f; do
    echo "    \"$f\","
done
echo "    \"__end__\""
echo "  ]"

echo "}"
