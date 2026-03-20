---
name: codeck
description: Generate an interactive HTML dashboard (CoDeck) that visualizes a software project's architecture, user journeys, and working mechanisms in a way non-technical vibe coders can understand. Use this skill whenever the user asks to "generate project dashboard", "generate codeck", "show me project overview", "update codeck", "visualize my project", "explain how my project works", "show project architecture", "what does my codebase do", or any request to understand, map, or visualize the structure and behavior of their codebase. Also trigger when users express confusion about their project, feel lost in the codebase, or want a bird's-eye view of what they've built.
---

# CoDeck

Generate a beautiful, interactive, self-contained HTML dashboard that gives non-technical builders (vibe coders) a clear, visual understanding of their entire software project — its growth story, working mechanisms, user journeys, technical architecture (with per-file drill-down), and health metrics.

## Who This Is For

Vibe coders: people who build software products with AI assistance but lack deep technical backgrounds. They need to understand *what their project does and how it works* without reading code line by line. This dashboard is their control tower.

## Core Workflow

### Step 1: Scan the Project

Analyze the project root directory to understand the codebase. Read these in order of priority:

1. **Package/config files** — `package.json`, `requirements.txt`, `pyproject.toml`, `Cargo.toml`, `go.mod`, `Gemfile`, etc. Identify the tech stack, dependencies, and scripts.
2. **Entry points** — `main.*`, `app.*`, `index.*`, `server.*`, or whatever the config specifies as entry.
3. **Route/API definitions** — Look for route handlers, API endpoints, URL patterns.
4. **Data models / schemas** — Database models, type definitions, schemas.
5. **Directory structure** — `find . -type f -not -path '*/node_modules/*' -not -path '*/.git/*' -not -path '*/dist/*' -not -path '*/build/*' -not -path '*/__pycache__/*' -not -path '*/venv/*'` to map the full tree.
6. **README and docs** — Any existing documentation.
7. **Git history** (if available) — Recent commits for context on active areas.
8. **Git deep history** (if available) — Full commit log for growth analysis. Run `scripts/scan_project.sh` which collects: total commit count, commits per week, code line count over time (sampled), first commit date, contributor count, and commit message keywords for milestone detection.

Use `scripts/scan_project.sh` to automate the initial scan. It outputs a structured JSON summary.

### Step 1.5: File Role Analysis

For every source code file discovered in Step 1, generate a one-sentence plain-language role description. Read the file's imports, exports, class/function names, and comments to determine its purpose. Think of this as writing a name badge for each file — what does this file *do* in the project?

Store results as a `file_roles` map: `{ "src/auth/login.ts": "Handles the login page — validates email and password, then sends them to the server" }`.

Rules for writing file roles:
- Use everyday language. "Handles user login" not "Implements OAuth2 PKCE authentication flow"
- Mention what triggers this file (a button click, an API call, a scheduled job)
- If the file talks to other files, mention who: "Gets data from the database helper and sends it to the login page"
- If purpose is unclear from the code, write "Role unclear from code analysis" — never guess

### Step 2: Build the Mental Model

From the scan results, construct five models (in priority order):

**Model 1 — Growth Story**
Build a narrative of the project's evolution from git history. Extract:
- Timeline of commits (weekly aggregation)
- Code volume growth curve (total lines over time, sampled at key commits)
- Milestone detection: scan commit messages for keywords like "feat", "add", "launch", "release", "v1", "deploy", "first", "initial", "complete", "finish", "ship" — these become milestone markers on the timeline
- Activity patterns: which days of the week / times of day are most active
- Achievement unlocks: first commit, 10th commit, 50th commit, 100th commit, first 1000 lines, first test added, first dependency added, etc.
- Period-over-period summary: compare this week/month to the previous one

The growth story should make the builder feel proud. Frame everything as progress, not judgment.

**Model 2 — Working Mechanisms**
Identify the 3-5 core "machines" in the project. A "machine" is a complete process: "User uploads a photo → system resizes it → stores in S3 → returns CDN URL". Describe each as a plain-language pipeline with clear input → processing → output. Non-technical users should read this and think "oh, THAT'S what happens when I click that button."

**Model 3 — User Journeys**
Map the paths a user takes through the product. Start from entry (landing page, login, CLI command) and follow through to key outcomes. Identify: entry points, decision branches, happy paths, error states, and exit points.

**Model 4 — Technical Architecture (with File Roles)**
Simplify the component relationships into layers: UI → Logic → Data. Show which files/modules belong to each layer and how data flows between them. Use metaphors non-technical users understand (e.g. "the kitchen" for backend processing, "the front desk" for API gateway).

Attach the `file_roles` data from Step 1.5 to each file node. Every file in the architecture diagram must be individually expandable to show its role description, dependencies, file size, and last modified date.

**Model 5 — Project Health**
Gather quantitative signals: file count by type, dependency count, TODO/FIXME/HACK count, test coverage presence, last modified dates, largest files.

### Step 3: Detect Dashboard Language

The dashboard's display language (all UI labels, section titles, descriptions, file role explanations) must match the project's primary language. Use multi-signal detection:

**Signal sources (check in order, strongest first):**
1. **README / docs** — if primarily Chinese → Chinese; if primarily English → English
2. **Code comments** — sample 10-20 source files; if > 60% of comments are in one language → that language
3. **Commit messages** — check recent 20 commits; if > 60% in one language → that language
4. **Variable/function naming** — if using pinyin or Chinese characters in identifiers → likely Chinese context
5. **Package metadata** — `description` field in package.json, pyproject.toml, etc.

**Decision rules:**
- If 2+ signals agree on the same language → use that language confidently, no need to ask
- If signals are mixed or inconclusive (e.g. README in English but comments in Chinese) → **ask the user**: "I detected mixed languages in your project (English README, Chinese comments). Which language should the CoDeck dashboard use?"
- If no signals available (no README, no comments, fresh project) → **ask the user**: "I couldn't determine the project's primary language. Which language should the dashboard use — English or Chinese?"
- Never silently default. If uncertain, always ask.

**What "language" controls:**
- Section titles ("Growth Story" vs "成长历程")
- Stat labels, status text, badge labels
- File role descriptions (the one-sentence explanations)
- Achievement badge names and descriptions
- Tooltips and footer text
- Navigation labels in topnav and sidebar

### Step 4: Generate the Dashboard HTML

Create a single self-contained HTML file at `codeck.html` in the project root.

Consult `references/design-principles.md` for all visual and interaction design guidance.

The HTML file must:
- Be completely self-contained (inline CSS + JS, no external dependencies)
- Work by opening directly in any modern browser
- Be responsive (works on laptop and large monitors)
- Include interactive elements (expandable sections, hover tooltips, tab navigation, animated transitions)
- Match business complexity with visual complexity — simple projects get clean, focused dashboards; complex projects get richer visualizations with animated data flows and interactive diagrams

#### Dashboard Sections (in order)

**Header**
- Project name (from package config or directory name)
- Tech stack badges (framework, language, database, etc.)
- Last updated timestamp
- One-sentence project summary

**Section 1: Growth Story (成长历程)**
This is the first thing the user sees. It should feel celebratory and motivating.

- **Period summary cards** at the top: "This week: 8 commits, +240 lines, 3 new features" with comparison arrows (↑12% vs last week). Use large, confident typography.
- **Growth timeline**: horizontal timeline with commit density visualized as a waveform or bar chart. Milestone commits (detected via keywords) rendered as prominent flag/star markers with labels (e.g. "First deploy", "Added user auth"). Each milestone marker uses a Material Symbols icon — see `references/design-principles.md` for the icon mapping table. The timeline should be scrollable/zoomable for long histories.
- **Code volume curve**: SVG line chart showing total lines of code over time. Area fill under the curve with a gradient. Animate the line drawing on page load (SVG stroke-dasharray technique).
- **Contribution heatmap**: grid of squares (52 columns × 7 rows = one year), color intensity = commit count per day. Similar to GitHub's contribution graph but styled to match the dashboard personality.
- **Achievement badges**: unlocked milestones displayed as pill-shaped badges with Material Symbols icons (NOT emoji). Examples: "First Commit" (icon: `eco`), "100 Commits" (icon: `century`), "1,000 Lines" (icon: `inventory_2`), "First Test" (icon: `science`), "First Release" (icon: `rocket_launch`). Locked/future achievements shown as dimmed outlines to create aspiration. See `references/design-principles.md` for the complete icon mapping table.
- If git history is unavailable, show a friendly empty state: "No git history found — start tracking your project with git to unlock growth insights!"

**Section 2: How It Works (Working Mechanisms)**
- Each "machine" as an interactive pipeline diagram
- Click/hover to expand steps with plain-language explanations
- Animated flow indicators showing data movement direction
- Color-coded by domain (auth = one color, data = another, etc.)

**Section 3: User Journey**
- Interactive flowchart/map
- Entry points clearly marked
- Decision branches visualized
- Happy path highlighted, alternate paths shown on interaction
- Animated path-tracing on hover to show the flow

**Section 4: Architecture Overview (with File Drill-Down)**
- Layered diagram (UI → Logic → Data)
- Data flow arrows between components
- Metaphor labels alongside technical labels (e.g. "Front Desk (API Gateway)")
- **Every file node is clickable**. Clicking expands an inline detail panel showing:
  - **Role**: the plain-language description from file_roles (e.g. "Handles the login page — validates email and password, then sends them to the server")
  - **Talks to**: list of files this file imports from or is imported by
  - **Size**: file size in human-readable format
  - **Last modified**: relative date (e.g. "3 days ago")
  - **TODOs**: count of TODO/FIXME in this file, if any, with a warning indicator
- For large projects, include a search/filter bar above the architecture diagram to find files by name or role keyword
- Expand-all / collapse-all toggle for power users

**Section 5: Project Health**
- At-a-glance stats cards (file count, dependencies, TODOs, etc.)
- File type distribution (visual bar or treemap)
- Dependency health indicators
- Recent activity heatmap (if git data available)

**Footer**
- Generation timestamp
- "Regenerate with: [trigger command]" hint
- Version indicator

### Step 5: Write the Snapshot Data File

Generate `codeck.json` alongside the HTML. This JSON contains the raw analyzed data so future regenerations can diff against it and show what changed.

Structure:
```json
{
  "generated_at": "ISO timestamp",
  "project_name": "...",
  "tech_stack": [],
  "growth": {
    "first_commit": "ISO date",
    "total_commits": 0,
    "commits_by_week": [{"week": "2025-W01", "count": 5}],
    "commits_by_day_of_week": {"Mon": 12, "Tue": 8},
    "lines_over_time": [{"date": "2025-01-15", "lines": 340}],
    "milestones": [{"date": "...", "message": "...", "type": "feat|release|init"}],
    "achievements": ["first-commit", "100-commits", "1000-lines"],
    "period_summary": {
      "this_week": {"commits": 8, "lines_added": 240},
      "last_week": {"commits": 5, "lines_added": 150}
    }
  },
  "mechanisms": [],
  "journeys": [],
  "architecture": {},
  "file_roles": {
    "src/auth/login.ts": {
      "role": "Handles the login page...",
      "imports": ["src/lib/api.ts"],
      "imported_by": ["src/app.ts"],
      "size": "2.4 KB",
      "last_modified": "2025-03-15",
      "todo_count": 1
    }
  },
  "health": {},
  "file_hash": "md5 of project file tree for change detection"
}
```

## Sync & Update Strategy

Support two update modes:

### Manual Trigger
User says "update codeck" or "refresh dashboard" → Re-scan the project, diff against `codeck.json`, regenerate the HTML with a "What Changed" highlight section at the top showing additions, removals, and modifications since last scan.

### Automatic Trigger (Git Hook)
When asked to "set up auto-update" or "enable automatic codeck updates":

1. Create a git post-commit hook at `.git/hooks/post-commit`:
```bash
#!/bin/bash
# CoDeck auto-update trigger
echo "[CoDeck] Project changed. Run 'claude' with 'update codeck' to refresh."
```

2. Optionally, if the user uses Claude Code with the `--auto` flag or a CI-like setup, create a more direct integration:
```bash
#!/bin/bash
# Requires Claude Code CLI
claude -p "update codeck silently" 2>/dev/null || echo "[CoDeck] Refresh needed. Run: claude → 'update codeck'"
```

Always ask before modifying git hooks. Explain what the hook does in plain language.

## Complexity Calibration

Match dashboard richness to project complexity:

**Simple project** (< 20 files, 1-2 routes, single purpose):
- Clean, single-scroll dashboard
- Minimal animations — subtle fade-ins and hover states
- Focus on the one core mechanism
- Growth story: simple timeline + achievement badges (even small projects deserve celebration)
- Architecture: flat file list with click-to-expand roles

**Medium project** (20-100 files, multiple routes, some services):
- Tab-based navigation between sections
- Animated flow diagrams for mechanisms
- Interactive journey map with path highlighting
- Growth story: full timeline with milestones + contribution heatmap
- Architecture: layered diagram with file drill-down panels

**Complex project** (100+ files, microservices, multiple data stores):
- Full interactive dashboard with sidebar navigation
- Animated data flow visualizations with particle effects or flowing dots
- Collapsible architecture layers with deep drill-down
- Search/filter capability within the dashboard
- Mini-map for architecture overview
- Growth story: all charts + animated code volume curve + period comparisons
- Architecture: searchable file explorer with role descriptions, dependency graph

## Output Files

Always generate these files in the project root:
- `codeck.html` — The interactive dashboard
- `codeck.json` — The structured data snapshot (for diff on updates)

## Important Notes

- Never hallucinate architecture. If you can't determine a component's role from the code, say "purpose unclear from code analysis" and mark it with a visual indicator.
- Use the project's own terminology. If the codebase calls something a "worker", don't rename it to "service".
- Keep all explanations at a level where someone who doesn't code can follow along. Think "explaining to a smart friend who's never programmed."
- When updating, always show what changed since last generation. Changes are the most valuable information for a vibe coder who just asked AI to modify their code.
