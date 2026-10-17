# Claude AI — VLC Redesign Integration Guide

> **Purpose:** This document serves as the master operational guide for Claude (or any LLM agent) working on the VLC Community Redesign. It consolidates the design system, agent workflow, feature changelog, and component prompts into a single, actionable reference.

---

## 1. Project Overview

The VLC Community Redesign is a conceptual UI/UX overhaul of the VLC Media Player. It modernizes the interface while preserving the utilitarian, no-nonsense character that defines VLC. The redesign assets are located in [`VLC Redesign (Community)/`](file:///d:/workspace/vlc/VLC%20Redesign%20(Community)) and include Figma exports (`.svg`, `.png`) covering the player, settings, subtitles, sidebar panels, right-click menus, and icon variants.

### Key Design Files

| File | Description |
|------|-------------|
| `Player.png` / `Player-*.png` | Main player viewport & playback controls |
| `Subtitles.png` | Subtitle sync timeline & fetching UI |
| `Settings - global.png` | Unified settings — global preferences |
| `Settings - audio.png` | Unified settings — audio configuration |
| `Property 1=expanded*.png` | Sidebar panel states (collapsed/expanded) |
| `right-click menu.png` | Context menu redesign |
| `VLC Redesign (Community).svg` | Full Figma source export |

---

## 2. Design System Reference

> Source: [`design_system.md`](file:///d:/workspace/vlc/design_system.md)

### 2.1 Brand Identity

- **Primary Accent:** VLC Orange (`#FF8800` family) — used sparingly for interactive elements, the cone logo, and active states.
- **Backgrounds:** Deep neutral dark grays (`#1A1A1A`, `#242424`) and true blacks (`#000000`) for the player viewport.
- **Text:** White (`#FFFFFF`) for primary text, muted gray (`#A0A0A0`) for secondary/inactive labels.

### 2.2 Shape Language

- **Rectangles over pills.** Buttons and containers retain slightly rectangular, rigid shapes — *not* the heavy, bubbly rounding common in modern web apps. This keeps VLC feeling like a serious, utilitarian tool.
- **Consistent corner radius:** `4px` for small elements (buttons, chips), `8px` for panels/cards, `0px` for the seek bar and full-width elements.

### 2.3 Typography

- **Font family:** System sans-serif stack (`-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif`).
- **Weights:** Regular (400) for body text, Medium (500) for labels, SemiBold (600) for headings.
- **Sizes:** `12px` metadata, `14px` body, `16px` section headers, `20px` page titles.

### 2.4 Iconography

- Mathematically consistent stroke-based icons.
- **No two-tone** — monochrome with VLC Orange accent only for active/selected state.
- Icon reference variants in the design folder: `name=disc, ...two-tone=no.png` vs `two-tone=yes.png`.

### 2.5 Modes & Theming

| Mode | Description |
|------|-------------|
| **Video Mode** | Default — full viewport with overlaid controls |
| **Music Mode** | Dedicated interface: massive album art, audio waveform seek bar |
| **Light Theme** | Inverted — light grays with dark text |
| **Dark Theme** | Default — deep grays & blacks |
| **Custom Accent** | User-selectable accent color replacing VLC Orange |

---

## 3. Feature Specifications

> Source: [`changelog_and_updates.md`](file:///d:/workspace/vlc/changelog_and_updates.md)

### 3.1 Playback & Controls

| Feature | Specification |
|---------|--------------|
| **Play Button** | Left-aligned to prevent a massive centralized control bar |
| **Cone Volume Slider** | Traffic-cone-shaped slider — orange fill rises bottom-to-top with volume |
| **Seek Bar** | Absolute bottom of viewport, thickened, with hover thumbnail previews |
| **Hover Thumbnails** | Generated from video keyframes; displayed on seek-bar hover |

### 3.2 Sidebar Features

| Feature | Specification |
|---------|--------------|
| **Visual Subtitle Sync** | Draggable timeline slider adjusting offset (ms) with live text-shift preview |
| **Subtitle Fetching** | Integrated OpenSubtitles REST API — search by video hash, download `.srt` to media directory |
| **Show Presets** | Save audio/subtitle config per TV show (e.g., audio track + subtitle track + sync offset) |
| **Live Filters** | Visual preview icons for video effects & audio equalizer presets |

### 3.3 Library & Settings

| Feature | Specification |
|---------|--------------|
| **Compact Library** | Overlay panel for queuing files without leaving playback |
| **Unified Settings** | Merged "Simple" & "Advanced" views into scrollable, categorized pages |
| **Visual Editor** | Drag-and-drop toolbar customization (add/remove/reorder playback buttons) |

---

## 4. Agent Workflow

> Source: [`agent_workflow.md`](file:///d:/workspace/vlc/agent_workflow.md)

### Agent Roles

```
┌─────────────────────┐    ┌─────────────────────┐    ┌─────────────────────┐
│  Agent 1: Frontend   │    │  Agent 2: API/Integ  │    │  Agent 3: QA/Test    │
│  ─────────────────── │    │  ─────────────────── │    │  ─────────────────── │
│  • Visual editor     │◄──►│  • Subtitle fetch    │◄──►│  • Visual regression │
│  • Drag-and-drop UI  │    │  • OpenSubtitles API │    │  • Aspect ratio test │
│  • Config persistence│    │  • Auth + hash search│    │  • Seek bar perf     │
└─────────────────────┘    └─────────────────────┘    └─────────────────────┘
```

### Agent 1 — UI/UX Frontend Developer

- **Stack:** React + drag-and-drop library (`dnd-kit`) *or* native Qt equivalents
- **Deliverable:** Toolbar visual editor with state persistence to local config file
- **Key Constraint:** Must respect the rectangular shape language (no pill buttons)

### Agent 2 — API & Integrations

- **Stack:** REST client for OpenSubtitles API
- **Deliverable:** Subtitle search (by video hash), auth flow, `.srt` download
- **Key Constraint:** Handle rate limiting, fallback search by filename, error states

### Agent 3 — QA & Testing

- **Stack:** Visual regression framework (Playwright, Percy, or BackstopJS)
- **Deliverable:** Test suite covering seek bar + hover thumbnails across aspect ratios
- **Key Constraint:** Must test 16:9, 4:3, 21:9 without blocking video content

---

## 5. Claude Component Prompts

> Source: [`claude_ai_integration.md`](file:///d:/workspace/vlc/claude_ai_integration.md)

These are ready-to-use prompts for generating individual components. Each prompt has been enriched with design-system context below.

### 5.1 Cone Volume Slider

**Prompt:**
> Write a React component using Tailwind CSS and Framer Motion that creates a volume slider shaped like a traffic cone. The orange color should fill up the cone from bottom to top as the volume percentage increases.

**Design Constraints:**
- Accent color: VLC Orange (`#FF8800`)
- Background: `#1A1A1A`
- Shape: Tapered trapezoid (wider at top, narrow at bottom) — *not* rounded
- Animation: `framer-motion` spring with `stiffness: 300, damping: 25`
- Accessibility: `aria-label="Volume"`, keyboard support (Up/Down arrow keys)

### 5.2 Subtitle Sync Timeline

**Prompt:**
> Design a UI component for a subtitle synchronization timeline. It needs a draggable slider that adjusts the offset time (in milliseconds) and displays a visual preview of the text shifting forward or backward.

**Design Constraints:**
- Sidebar panel width: `320px`
- Slider range: `-10000ms` to `+10000ms` with `50ms` steps
- Visual preview: Show 2–3 subtitle lines with animated left/right shift
- Typography: `12px` monospace for millisecond readout
- Color: Orange handle on gray track

### 5.3 Unified Settings Refactor

**Prompt:**
> Refactor this JSON structure of VLC's legacy advanced settings into a clean, categorized nested object suitable for a modern scrolling settings menu.

**Design Constraints:**
- Categories: `General`, `Audio`, `Video`, `Subtitles`, `Input/Codecs`, `Interface`, `Advanced`
- Each category maps to a scrollable page (see `Settings - global.png`, `Settings - audio.png`)
- Replace jargon with plain English labels (e.g., "Subtitle auto-detect precision" → "How accurately should VLC detect subtitle files?")
- Preserve original setting keys as `id` fields for backward compatibility

---

## 6. Implementation Roadmap

### Phase 1 — Foundation (Week 1–2)
- [ ] Set up React project with Vite + TypeScript
- [ ] Implement design tokens (colors, spacing, radii, typography)
- [ ] Build base component library: `Button`, `Slider`, `Panel`, `Icon`
- [ ] Implement Dark/Light theme switching

### Phase 2 — Player Core (Week 3–4)
- [ ] Build player viewport with video element
- [ ] Implement bottom seek bar with hover thumbnails
- [ ] Create left-aligned playback controls
- [ ] Build cone volume slider component
- [ ] Implement right-click context menu

### Phase 3 — Sidebar & Panels (Week 5–6)
- [ ] Build collapsible sidebar framework
- [ ] Implement subtitle sync timeline
- [ ] Integrate OpenSubtitles API for subtitle fetching
- [ ] Build show presets save/load system
- [ ] Create live filter preview panel

### Phase 4 — Library & Settings (Week 7–8)
- [ ] Build compact overlay library
- [ ] Implement unified settings pages (scrollable categories)
- [ ] Build drag-and-drop toolbar visual editor
- [ ] Implement Music Mode alternate layout

### Phase 5 — Polish & QA (Week 9–10)
- [ ] Visual regression test suite (16:9, 4:3, 21:9)
- [ ] Accessibility audit (keyboard nav, screen readers, ARIA)
- [ ] Performance profiling (seek bar, hover thumbnails)
- [ ] Onboarding screen with theme selection
- [ ] Documentation & handoff

---

## 7. File Structure (Recommended)

```
vlc-redesign/
├── public/
│   └── assets/              # Static assets (icons, cone logo)
├── src/
│   ├── components/
│   │   ├── player/
│   │   │   ├── SeekBar.tsx
│   │   │   ├── PlaybackControls.tsx
│   │   │   ├── ConeVolumeSlider.tsx
│   │   │   └── HoverThumbnail.tsx
│   │   ├── sidebar/
│   │   │   ├── SubtitleSync.tsx
│   │   │   ├── SubtitleFetch.tsx
│   │   │   ├── ShowPresets.tsx
│   │   │   └── LiveFilters.tsx
│   │   ├── settings/
│   │   │   ├── SettingsPage.tsx
│   │   │   ├── SettingsCategory.tsx
│   │   │   └── VisualEditor.tsx
│   │   ├── library/
│   │   │   └── CompactLibrary.tsx
│   │   └── ui/
│   │       ├── Button.tsx
│   │       ├── Slider.tsx
│   │       ├── Panel.tsx
│   │       ├── Icon.tsx
│   │       └── ContextMenu.tsx
│   ├── hooks/
│   │   ├── useVolume.ts
│   │   ├── useSubtitles.ts
│   │   └── useTheme.ts
│   ├── services/
│   │   └── opensubtitles.ts
│   ├── stores/
│   │   ├── playerStore.ts
│   │   ├── settingsStore.ts
│   │   └── libraryStore.ts
│   ├── styles/
│   │   ├── tokens.css       # Design tokens (CSS custom properties)
│   │   └── global.css
│   ├── types/
│   │   └── index.ts
│   ├── App.tsx
│   └── main.tsx
├── tests/
│   ├── visual/              # Visual regression tests
│   └── unit/                # Unit tests
├── package.json
├── tsconfig.json
├── vite.config.ts
└── README.md
```

---

## 8. Code Conventions

| Convention | Rule |
|------------|------|
| **Language** | TypeScript (strict mode) |
| **Styling** | CSS custom properties for tokens, Tailwind for utility classes |
| **State** | Zustand for global state, React hooks for local state |
| **Animation** | Framer Motion for interactive components |
| **Testing** | Vitest + Playwright for visual regression |
| **Naming** | PascalCase components, camelCase functions, UPPER_SNAKE constants |
| **Imports** | Absolute paths via `@/` alias |
| **Comments** | JSDoc for public APIs, inline comments for non-obvious logic only |

---

## 9. Design Reference Quick Access

All design mockups are located in [`VLC Redesign (Community)/`](file:///d:/workspace/vlc/VLC%20Redesign%20(Community)):

| Reference | File |
|-----------|------|
| Main Player | `Player.png` |
| Sidebar Expanded | `Property 1=expanded.png` through `Property 1=expanded-6.png` |
| Subtitles Panel | `Subtitles.png` |
| Settings — Global | `Settings - global.png` |
| Settings — Audio | `Settings - audio.png` |
| Right-Click Menu | `right-click menu.png` |
| Icon Variants | `name=disc, ...two-tone=no.png` / `two-tone=yes.png` |
| Full Figma Export | `VLC Redesign (Community).svg` |

---

## 10. Related Documents

- [`agent_workflow.md`](file:///d:/workspace/vlc/agent_workflow.md) — Agent role definitions
- [`claude_ai_integration.md`](file:///d:/workspace/vlc/claude_ai_integration.md) — Raw component prompts
- [`changelog_and_updates.md`](file:///d:/workspace/vlc/changelog_and_updates.md) — Feature change log
- [`design_system.md`](file:///d:/workspace/vlc/design_system.md) — Visual design principles

---

*Last updated: 2026-10-17*
