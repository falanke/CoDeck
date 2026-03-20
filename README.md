# 🎛️ CoDeck

**Your project, decoded. A visual control tower for vibe coders.**

CoDeck is a Claude Code skill that scans your codebase and generates an interactive HTML dashboard — so you can *see* how your project works without reading a single line of code.

You built it with AI. Now understand what you built.

<!-- TODO: Add screenshot of a real CoDeck dashboard here -->
<!-- ![CoDeck Dashboard](./assets/demo-screenshot.png) -->

## The Problem

You're a vibe coder. You prompt AI, it writes code, you debug, iterate, ship. But somewhere along the way you lost track of what's actually going on inside your project. Which file does what? How does data flow from the login page to the database? What changed since last week?

You don't need to understand every line of code. But you need a map.

**CoDeck is that map.**

## What You Get

```
/codeck > "generate codeck"
```

A single self-contained `codeck.html` file opens in your browser with five interactive tabs:

🏆 **Growth Story** — Your project's journey visualized. Commit timeline, code growth curve, contribution heatmap, and achievement badges that unlock as your project evolves. Designed to make you feel proud, not overwhelmed.

⚙️ **How It Works** — The 3-5 core "machines" in your project as interactive pipeline diagrams. Click to see what happens when a user presses that button.

🗺️ **User Journey** — Interactive flowchart showing how users move through your product. Happy paths highlighted, branches revealed on hover.

🏗️ **Architecture** — Layered view of your project (UI → Logic → Data). **Every file is clickable** — expand to see a plain-language explanation of what it does, who it talks to, and when it was last modified.

📊 **Project Health** — File count, dependencies, TODOs, activity heatmap. The vitals at a glance.

## Features

- **Zero Dependencies** — Single HTML file with inline CSS/JS. Open in any browser. No npm, no build tools.
- **Anti-AI-Slop Design** — CoDeck has its own design system (Manrope + Inter, M3 surface tokens, indigo accent, ultra-light shadows). Every dashboard looks polished and consistent — not like generic AI output.
- **Per-File Drill-Down** — Click any file in the architecture view to see what it does in plain language. Like a name badge for every file in your project.
- **Auto Language Detection** — Dashboard language (English/Chinese) is detected from your README, comments, and commit messages. Mixed signals? CoDeck asks instead of guessing.
- **Sync with Your Project** — Manual update (`update codeck`) or automatic git hook that reminds you after every commit.
- **Complexity Calibration** — Simple project gets a clean single-page dashboard. Complex monorepo gets sidebar navigation, search, animated data flows.
- **Achievement System** — Milestones like "First Commit", "100 Commits", "First Release" unlock automatically from git history, each with its own Material Symbols icon. Locked badges show what's next.

## Quick Start

### Install (Claude Code)

```bash
# Project-level (recommended — travels with your repo)
mkdir -p .claude/skills
git clone https://github.com/YOUR_USERNAME/codeck.git .claude/skills/codeck

# Or global (available in all projects)
git clone https://github.com/YOUR_USERNAME/codeck.git ~/.claude/skills/codeck
```

### Use

In Claude Code, just say:

```
generate codeck
```

That's it. Claude scans your project and creates `codeck.html` in the project root. Open it in your browser.

### Update

```
update codeck
```

CoDeck diffs against the previous snapshot and highlights what changed since last time — the most valuable information for someone who just asked AI to modify their code.

### Auto-Sync (Optional)

```
set up auto-update for codeck
```

Installs a git post-commit hook. After every commit, you'll see:

```
[CoDeck] Project changed since last dashboard update.
[CoDeck] Run: update codeck
```

## How It's Built

This skill uses progressive disclosure — the main SKILL.md is a concise workflow (~270 lines), with design principles and scripts loaded only when needed:

```
codeck/
├── SKILL.md                        # Core instructions (270 lines)
│   ├── Step 1: Scan project        #   Automated code analysis
│   ├── Step 1.5: File roles        #   Per-file plain-language descriptions
│   ├── Step 2: Build mental model  #   5 models: Growth → Mechanisms → Journeys → Architecture → Health
│   ├── Step 3: Detect language     #   Multi-signal (README + comments + commits + package.json)
│   ├── Step 4: Generate HTML       #   Self-contained dashboard with CoDeck design system
│   └── Step 5: Write snapshot      #   JSON for diffing on future updates
├── references/
│   └── design-principles.md        # Complete CoDeck visual language (322 lines)
│       ├── M3 color system          #   Exact Tailwind config with semantic tokens
│       ├── Component patterns       #   7 reusable HTML templates
│       ├── Motion & interaction     #   Animation specs
│       └── UI robustness rules      #   Overflow/layout bug prevention
└── scripts/
    ├── scan_project.sh             # Automated project scanner (tech stack, files, git history, language signals)
    └── setup_git_hook.sh           # One-command git hook installer
```

The design language is not a suggestion — it's a specification. Every CoDeck dashboard uses the exact same color tokens, font pairing, component patterns, and shadow values. This is what makes CoDeck outputs look consistent instead of random.

## What the Output Looks Like

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <!-- Manrope + Inter fonts, Material Symbols, Tailwind CSS -->
  <!-- CoDeck M3 color system via Tailwind config -->
</head>
<body class="bg-surface text-on-surface">
  <!-- TopNavBar: fixed, backdrop-blur, tab navigation -->
  <!-- Bento Grid Layout: 12-column responsive grid -->
  <!--   Growth Story: timeline + heatmap + achievements -->
  <!--   Mechanisms: interactive pipeline diagrams -->
  <!--   Journeys: funnel visualization -->
  <!--   Architecture: file table with click-to-expand roles -->
  <!--   Health: stat cards + progress bars -->
  <!-- Floating toast: sync status indicator -->
</body>
</html>
```

One file. No dependencies. Works in 2035.

## Beliefs

**You don't need to read code to understand your project.** You need a visual map that speaks your language.

**Growth deserves celebration.** The first tab isn't architecture or health metrics — it's your achievement wall. Every commit is progress.

**Consistency is a feature.** CoDeck doesn't generate a random design each time. It has a brand — same fonts, same colors, same components. You recognize a CoDeck dashboard instantly.

**If you can't tell, ask.** CoDeck doesn't silently default to English when your project is half-Chinese. It detects, and when unsure, it asks.

**One HTML file is enough.** Dependencies are debt. A single self-contained file will open on any machine, any browser, any decade from now.

## License

MIT

## Credits

Created with Claude Code. Built for the vibe coding community — people who ship products without being traditional software engineers.
