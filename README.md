# 🎛️ CoDeck
<img width="2816" height="1536" alt="Gemini_Generated_Image_a7oiw3a7oiw3a7oi" src="https://github.com/user-attachments/assets/75a227de-df0c-4464-a0d6-8fccf5d46c66" />

**A visual map of your project — for you and everyone you want to show it to.**
<img width="1510" height="843" alt="截屏2026-03-19 23 27 39" src="https://github.com/user-attachments/assets/c421b77d-8083-4ee9-9736-c62dd161c679" />

[中文版](README.zh.md)

CoDeck is a Claude Code skill that scans your codebase and generates a self-contained interactive HTML dashboard. No code reading required — just a clear picture of what you built, how it works, and where it's going.

<!-- TODO: Add screenshot of a real CoDeck dashboard here -->
<!-- ![CoDeck Dashboard](./assets/demo-screenshot.png) -->

---

## When you'll actually use this

**You've lost track of your own project.** You've been prompting AI and iterating for weeks. Somewhere along the way you stopped knowing which file does what. Open CoDeck and get your bearings back in five minutes.

**You want to show someone what you're building.** A friend asks what your project does. A family member wants to understand what you've been working on. Send them a `codeck.html` — no explanation needed, they can click through it themselves.

**You're pitching or presenting.** Investors, collaborators, advisors — pull up the CoDeck dashboard and walk them through user flows, system architecture, and project progress. More honest than a slide deck, and faster to put together.

**You just had AI rewrite a bunch of stuff.** Run `update codeck` to diff against the last snapshot and see exactly what changed. Before you keep going, at least know what just happened.

---

## What you get

Just say this in Claude Code:

```
generate codeck
```

A `codeck.html` file appears in your project root. Open it in any browser — five tabs, no install:

🏆 **Growth Story** — Commit timeline, code growth curve, milestone badges that unlock from your git history. Built to make you feel good about the progress you've made.

⚙️ **How It Works** — Your project's core processes as interactive pipeline diagrams. Click any step to see what's actually happening under the hood.

🗺️ **User Journey** — A flowchart of how users move through your product, from entry to completion. Branches expand on hover.

🏗️ **Architecture** — Your project layered as UI → Logic → Data. Every file is clickable — expand any one to get a plain-language explanation of what it does and who it talks to.

📊 **Project Health** — File count, dependencies, open TODOs, activity heatmap. The vitals at a glance.

---

## A few things worth knowing

- **Single file, zero dependencies** — The output is one standalone HTML file. Anyone can open it on any machine, no setup needed.
- **Auto language detection** — CoDeck reads your README, comments, and commit messages to decide whether to generate in English or Chinese. When it's not sure, it asks.
- **Stays in sync** — Run `update codeck` manually for an incremental update, or set up a git hook that nudges you after every commit.
- **Scales with complexity** — Simple project gets a clean single page. Large monorepo gets sidebar navigation, search, and animated data flows.

---

## Quick start

```bash
# Project-level install (recommended — travels with your repo)
mkdir -p .claude/skills
git clone https://github.com/falanke/codeck.git .claude/skills/codeck
```

Then in Claude Code, just say `generate codeck`.

---

## License

MIT
