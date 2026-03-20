# CoDeck Design Language

This document defines the exact visual language for every CoDeck dashboard. It is extracted from the CoDeck reference design and must be followed precisely to ensure visual consistency across all generated dashboards. Read this file before generating any HTML.

## Design Identity

CoDeck uses a **Material Design 3 (M3) inspired surface system** with a cool-toned, professional palette. The aesthetic is: clean, spacious, information-dense-but-breathable, with subtle depth through layered surfaces rather than heavy shadows. It feels like a premium SaaS analytics tool — not a toy, not a terminal.

## Mandatory Technology Stack

Every CoDeck dashboard HTML must include these exact dependencies:

```html
<!-- Fonts: Manrope for headlines, Inter for body -->
<link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;600;700;800&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
<!-- Material Symbols for icons -->
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
<!-- Tailwind CSS with forms plugin -->
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
```

NEVER substitute these fonts or icon set. Manrope + Inter + Material Symbols Outlined is the CoDeck identity.

## Color System (Tailwind Config)

Use this exact extended color palette in the Tailwind config. These are M3-derived semantic tokens:

```javascript
tailwind.config = {
  darkMode: "class",
  theme: {
    extend: {
      colors: {
        "primary": "#5148d8",
        "primary-dim": "#453acc",
        "primary-fixed": "#6f68f7",
        "primary-fixed-dim": "#625bea",
        "on-primary": "#fbf7ff",
        "on-primary-fixed": "#ffffff",
        "inverse-primary": "#8681ff",
        "secondary": "#506076",
        "secondary-dim": "#44546a",
        "secondary-container": "#d3e4fe",
        "on-secondary": "#f7f9ff",
        "on-secondary-container": "#435368",
        "tertiary": "#765377",
        "tertiary-container": "#fed2fd",
        "error": "#a8364b",
        "error-container": "#f97386",
        "surface": "#f7f9fb",
        "surface-bright": "#f7f9fb",
        "surface-container-lowest": "#ffffff",
        "surface-container-low": "#f0f4f7",
        "surface-container": "#eaeff2",
        "surface-container-high": "#e3e9ed",
        "surface-container-highest": "#dce4e8",
        "surface-variant": "#dce4e8",
        "on-surface": "#2c3437",
        "on-surface-variant": "#596064",
        "on-background": "#2c3437",
        "background": "#f7f9fb",
        "outline": "#747c80",
        "outline-variant": "#acb3b7",
        "inverse-surface": "#0b0f10",
        "inverse-on-surface": "#9a9d9f",
        "surface-tint": "#5148d8"
      },
      fontFamily: {
        "headline": ["Manrope", "sans-serif"],
        "body": ["Inter", "sans-serif"],
        "label": ["Inter", "sans-serif"]
      },
      borderRadius: {
        "DEFAULT": "0.25rem",
        "lg": "0.5rem",
        "xl": "0.75rem",
        "2xl": "1rem",
        "3xl": "1.5rem",
        "full": "9999px"
      }
    }
  }
}
```

### Color Usage Rules
- **Primary (#5148d8, indigo)** — active navigation, key actions, accent badges, chart fills
- **Surface scale** — layered card backgrounds. Use `surface-container-lowest` (white) for prominent cards, `surface-container-low` for secondary cards, `surface-container` for inputs/insets
- **on-surface (#2c3437)** — primary text. NEVER use pure black (#000000)
- **secondary (#506076)** — muted text, labels, metadata. NEVER use generic gray values
- **Status colors** — emerald-500 for healthy/positive, amber-500 for warnings/review, rose-400 for errors/critical
- **Dark mode** — use `dark:` prefix with slate-900/950 backgrounds, indigo-400/300 accents

## Typography

```css
body { font-family: 'Inter', sans-serif; }
h1, h2, h3, .font-headline { font-family: 'Manrope', sans-serif; }
```

### Type Scale
| Element | Font | Size | Weight | Extra |
|---------|------|------|--------|-------|
| Page title (h1) | Manrope | text-5xl | font-extrabold (800) | tracking-tight |
| Section heading (h3) | Manrope | text-xl | font-bold (700) | — |
| Eyebrow / kicker | Inter | text-xs | font-semibold (600) | uppercase tracking-wider text-primary |
| Body text | Inter | text-sm | font-medium (500) | — |
| Stat number | Manrope | text-2xl | font-bold (700) | — |
| Micro-label | Inter | text-[10px] | font-bold (700) | uppercase tracking-widest text-secondary |
| Code / mono | System mono | text-xs | font-mono | Only for metrics, file sizes, latency |

### Typography Rules
- NEVER center-align body text. Left-align everything.
- Micro-labels (10px, uppercase, wide tracking) are a CoDeck signature — use for status labels, category tags, metadata
- Stat numbers pair with a micro-label above and a comparison arrow below
- `tracking-tight` on large headings, `tracking-widest` on micro-labels — this contrast is intentional

## Layout System

### Page Structure
```
TopNavBar (fixed, z-50, bg-surface/80, backdrop-blur-md)
├── Logo (text-2xl font-bold text-indigo-600) + Nav links + Search + Avatar
SideNavBar (fixed left, hidden below xl, w-64, z-40)
├── Active: bg-indigo-50 text-indigo-700 border-l-4 border-indigo-600
├── Inactive: text-secondary hover:bg-slate-50 hover:translate-x-1
Main Content (xl:ml-64, pt-24, px-8, pb-12, max-w-[1440px], mx-auto)
├── Header (eyebrow + h1 + description + status badges)
├── Bento Grid (grid-cols-12, gap-6)
```

### Bento Grid
12-column CSS Grid: `grid grid-cols-1 md:grid-cols-12 gap-6`
- Large featured cards: `md:col-span-8`
- Side panels: `md:col-span-4`
- Medium cards: `md:col-span-6`
- Full-width sections: `md:col-span-12`

### Card System
Every content card:
```html
<div class="md:col-span-{N} bg-surface-container-lowest rounded-3xl p-8 shadow-[0_48px_48px_rgba(44,52,55,0.02)] overflow-hidden">
  <h3 class="text-xl font-bold mb-8">Section Title</h3>
  <!-- content -->
</div>
```
- Radius: `rounded-3xl` (1.5rem) — CoDeck signature
- Shadow: ultra-subtle `shadow-[0_48px_48px_rgba(44,52,55,0.02)]`. NEVER heavy drop shadows
- Padding: `p-8` consistently
- No visible borders. Depth from surface color layering
- Internal sub-items use `rounded-2xl`
- Always `overflow-hidden` on cards with dynamic content

## Component Patterns

### Stat Card
```html
<div>
  <div class="text-secondary text-xs font-medium uppercase tracking-tighter mb-1">Label</div>
  <div class="text-2xl font-bold">14,290</div>
  <div class="text-emerald-600 text-xs font-semibold flex items-center gap-1">
    ↑ 12% <span class="font-normal text-secondary/60">vs last mo</span>
  </div>
</div>
```

### Pipeline / Mechanism Node
```html
<div class="flex items-center gap-4 bg-surface-bright p-4 rounded-2xl group hover:translate-x-2 transition-transform cursor-pointer">
  <div class="w-10 h-10 rounded-full bg-white flex items-center justify-center shadow-sm shrink-0">
    <span class="material-symbols-outlined text-primary text-xl">icon_name</span>
  </div>
  <div class="flex-1 min-w-0">
    <div class="text-sm font-bold truncate">Node Name</div>
    <div class="text-[10px] text-secondary uppercase tracking-widest font-semibold">Status</div>
  </div>
  <div class="text-xs font-mono text-secondary bg-surface-container px-2 py-1 rounded whitespace-nowrap shrink-0">Metric</div>
  <span class="material-symbols-outlined text-secondary/30 group-hover:text-primary transition-colors shrink-0">chevron_right</span>
</div>
```

### Status Badge
```html
<span class="bg-indigo-50 text-indigo-600 px-2 py-1 rounded text-[10px] font-bold uppercase whitespace-nowrap">Category</span>
```
Variants: indigo (system), slate (docs), rose (config), emerald (healthy), amber (review)

### Progress Bar
```html
<div class="w-full bg-surface-container-highest h-1.5 rounded-full overflow-hidden">
  <div class="bg-emerald-500 h-full rounded-full" style="width:95%"></div>
</div>
```

### File Table Row
```html
<tr class="hover:bg-surface-container/30 transition-colors cursor-pointer">
  <td class="py-4 pl-4"><div class="flex items-center gap-3 min-w-0"><span class="material-symbols-outlined text-primary shrink-0">code</span><span class="font-semibold truncate">filename.ts</span></div></td>
  <td><span class="bg-indigo-50 text-indigo-600 px-2 py-1 rounded text-[10px] font-bold uppercase whitespace-nowrap">Role</span></td>
  <td><span class="flex items-center gap-1.5 whitespace-nowrap"><span class="w-1.5 h-1.5 rounded-full bg-emerald-500 shrink-0"></span> Status</span></td>
  <td class="text-secondary whitespace-nowrap">Modified</td>
  <td class="text-right pr-4 text-secondary font-mono text-xs whitespace-nowrap">Size</td>
</tr>
```
Table header: `text-secondary text-[10px] uppercase tracking-widest font-bold`
Table wrapper: always `<div class="overflow-x-auto">`

### Journey Funnel Bar
```html
<div class="flex items-center gap-4">
  <div class="w-24 text-right text-[10px] font-bold text-secondary uppercase tracking-wider shrink-0">Stage</div>
  <div class="flex-1 h-8 bg-primary rounded-full relative overflow-hidden">
    <div class="absolute inset-0 flex items-center px-4 text-on-primary text-xs font-bold truncate">92% Reach</div>
  </div>
</div>
```

### Floating Toast
```html
<div class="fixed bottom-8 right-8 bg-inverse-surface text-on-primary-fixed px-6 py-4 rounded-2xl shadow-2xl flex items-center gap-4 z-50">
  <div class="w-10 h-10 rounded-full bg-emerald-500 flex items-center justify-center shrink-0">
    <span class="material-symbols-outlined text-white" style="font-variation-settings:'FILL' 1;">check_circle</span>
  </div>
  <div class="min-w-0">
    <div class="text-sm font-bold truncate">Title</div>
    <div class="text-[10px] text-on-primary-fixed/60">Subtitle</div>
  </div>
</div>
```

## Motion & Interaction

### Transitions
- Hover on nodes/rows: `hover:translate-x-2 transition-transform` (horizontal slide, NOT scale)
- Button press: `active:scale-95 transition-all`
- Tab switch: smooth opacity crossfade
- Page load: staggered fade-in, `animation-delay` 0.1s increments, translate-Y 8px

### Chart Animations
- Bar charts: grow from bottom on load (CSS height transition)
- Line charts: SVG stroke-dasharray draw-on, 2s duration
- Heatmap cells: staggered fade-in, 5ms per cell

### Hover Tooltips
```html
<div class="absolute -top-10 left-1/2 -translate-x-1/2 bg-inverse-surface text-on-primary text-[10px] px-2 py-1 rounded opacity-0 group-hover:opacity-100 transition-opacity whitespace-nowrap pointer-events-none">
  Tooltip text
</div>
```

### NEVER Use
- Bounce easing
- Scale-up hover on cards (use translate-x instead)
- Heavy box-shadows
- Animations longer than 3s (except continuous flow indicators)
- Pure black (#000) or pure white (#fff) as text colors

## UI Robustness Rules

These rules prevent text overflow, layout breakage, and irregular element sizing. Apply them to EVERY element.

### Text Overflow Prevention
- Every text element in a flex row: parent has `min-w-0`, text has `truncate`
- Long file names: always `truncate`
- Stat numbers: `tabular-nums` font-feature, or fixed-width container
- Multi-line descriptions: `line-clamp-2` or `line-clamp-3`
- Badge text: always `whitespace-nowrap`
- Tooltip text: always `whitespace-nowrap`

### Flex Layout Safety
- Fixed-size elements (icons, badges, chevrons): always `shrink-0`
- Text container in a flex row: always `flex-1 min-w-0`
- Never omit `min-w-0` on a flex child that contains truncatable text — without it, `truncate` will not work

### Grid & Table Safety
- All grid card children: `overflow-hidden`
- Table wrapper: `<div class="overflow-x-auto">`
- Table cells with variable text: `max-w-[200px] truncate`
- Never let content push a card wider than its `col-span` allows

### Responsive Guards
- Nav links: `hidden md:flex`
- Sidebar: `hidden xl:flex`
- At < 1024px: single-column stack, no sidebar
- At < 768px: hide particle animations, enlarge touch targets to min 44px
- Always test: no horizontal scroll on the `<body>`

### Icon Consistency
- Material Symbols: always explicit size (`text-sm` / `text-xl`)
- Icon containers: fixed dimensions (`w-10 h-10` / `w-12 h-12`) + `flex items-center justify-center shrink-0`
- Never leave icons as inline without a sized container

### Spacing Discipline
- Card padding: `p-8`
- Grid gap: `gap-6`
- Heading to content: `mb-8`
- List items: `space-y-4` or `space-y-6`
- Never mix `gap-*` and margin on same axis

## Growth Story Visual Specifics

### Period Summary Cards
Use stat card pattern in `grid grid-cols-3 gap-8` inside the growth card.

### Commit Activity Bar Chart
Vertical bars, `rounded-t-lg`, `bg-primary/{opacity}` scaling 10-50 with value. Bars fill width with `gap-2`. Peak bar gets hover tooltip.

### Achievement Badges

**CRITICAL: Use Material Symbols icons, NEVER emoji.** Emoji render inconsistently across platforms, look unprofessional in a dashboard context, and break the CoDeck visual identity. Every icon in the dashboard must come from the Material Symbols Outlined set.

Achievement badge pattern:
```html
<!-- Unlocked -->
<span class="inline-flex items-center gap-1.5 bg-indigo-50 text-indigo-600 px-3 py-1.5 rounded-full text-xs font-bold whitespace-nowrap">
  <span class="material-symbols-outlined text-sm">eco</span>
  First Commit
</span>

<!-- Locked -->
<span class="inline-flex items-center gap-1.5 border border-dashed border-outline-variant text-secondary/40 px-3 py-1.5 rounded-full text-xs whitespace-nowrap">
  <span class="material-symbols-outlined text-sm">lock</span>
  Century (12 more to go)
</span>
```

### Achievement Icon Mapping

| Achievement | Icon name | Unlock condition |
|---|---|---|
| First Seed | `eco` | First commit |
| Getting Started | `counter_1` | 10 commits |
| Century | `military_tech` | 100 commits |
| 1K Club | `inventory_2` | 1,000 lines of code |
| Architect | `account_tree` | 10+ source files |
| Quality Minded | `science` | First test file added |
| Launched | `rocket_launch` | Commit contains "deploy", "release", or "launch" |
| Streak | `local_fire_department` | 7 consecutive days with commits |
| Night Owl | `dark_mode` | Commits after midnight |
| Early Bird | `wb_sunny` | Commits before 7am |
| Documenter | `menu_book` | README.md exceeds 100 lines |
| Team Player | `group` | 2+ contributors |

### Dashboard Section Icon Mapping

Use these icons in tab navigation and section headers:

| Section | Icon name | Context |
|---|---|---|
| Growth Story | `trending_up` | Tab nav + section header |
| How It Works | `settings_suggest` | Tab nav + section header |
| User Journey | `route` | Tab nav + section header |
| Architecture | `account_tree` | Tab nav + section header |
| Project Health | `monitor_heart` | Tab nav + section header |

### General Icon Usage

| Context | Icon name |
|---|---|
| File (code) | `code` |
| File (config) | `settings_suggest` |
| File (documentation) | `description` |
| Folder | `folder` |
| Status: healthy | `check_circle` (with `style="font-variation-settings:'FILL' 1;"` for filled variant) |
| Status: warning | `warning` |
| Status: error | `error` |
| Expand/chevron | `chevron_right` |
| Search | `search` |
| Filter | `filter_list` |
| Download/export | `download` |
| Sync complete | `check_circle` |
| Dark mode toggle | `dark_mode` |
| Milestone marker | `flag` |
| Commit | `commit` |
| Calendar/date | `calendar_today` |

**NEVER use emoji anywhere in the generated HTML.** This includes section titles, badge labels, tooltip text, toast messages, and data labels. Material Symbols is the only icon system in CoDeck.

### Contribution Heatmap
Grid of `w-3 h-3 rounded-sm` squares. Scale: `bg-surface-container` → `bg-primary/20` → `bg-primary/40` → `bg-primary/60` → `bg-primary`. Gap: `gap-[3px]`.

## Dashboard Complexity Scaling

The visual system (colors, fonts, components) stays constant. Only content density scales:
- **Simple projects**: no sidebar, full-width bento grid, fewer cards
- **Medium projects**: topnav with all tabs, mixed column spans
- **Complex projects**: sidebar + topnav, full component set, search functionality

The constant: Manrope + Inter, #5148d8 indigo primary, cool-toned M3 surfaces, rounded-3xl cards, ultra-light shadows, 10px uppercase micro-labels, Material Symbols Outlined icons.
