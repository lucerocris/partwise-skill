# partwise

A Claude Code skill for UI design work, web and iOS.

It picks the smallest job that fits the request:

| Job | For |
|---|---|
| `tweak` | Changing something that exists: spacing, a state, copy, one property |
| `part` | One new or redesigned component or section |
| `build` | A new screen, or a full redesign |
| `review` | A critique. Reports, changes nothing |
| `polish` | A pre-ship pass on something already built |
| `tells` | Finds the common marks that make a design look AI-made, reports them, then asks whether to remove, replace or keep each group |
| `ux` | Research only: journeys as they are, three real flows each from Refero, ranked findings, a recommended flow, and what to test with real people. Saved to `docs/ux/` for `site` and `overhaul` to use |
| `site` | The whole product, top down: page map and flows, art direction, design system (tokens, components, every state, a states sheet), and a page plan run as overhauls. `site next` continues the plan |
| `overhaul` | One page, the whole process from one line: context and product kind, art direction, which parts need rethinking, then build and check |
| `frame` | The site-level design: reader, character, page skeletons, rhythm, color, type, voice, in one design file. Extracted from what is built, or researched; and a fresh direction for an existing site when you ask for one |

For `part` and `build` it designs part by part. The usual agent workflow with
[Refero](https://refero.design) is "find screens like the page I'm building,
then build it", which returns generic pages and produces a generic design.
Partwise breaks the screen into parts first (sidebar, stat card, table, tab
bar...), finds three real-product references for each part, crops each
reference down to just that part, saves the crops beside the work, and builds
from them.

Every job runs against a short craft floor (type, color, spacing, states,
motion, access, words) and a platform page for web or iOS.

Builds straight into code by default and saves references in the project
(`docs/references/<screen>/`, gitignored unless you commit it). When asked for
a Figma mockup instead, it builds in Figma with a reference board beside the
screen.

## Needs

- [Refero MCP](https://refero.design/mcp), for `part` and `build`
- ImageMagick and curl, for `part` and `build`
- Figma MCP (remote server, with `use_figma` and `upload_assets`), only for
  Figma output

## Install

```bash
git clone git@github.com:lucerocris/partwise-skill.git ~/partwise-skill
ln -s ~/partwise-skill/skills/partwise ~/.claude/skills/partwise
```

## Use

```text
/partwise ux — why do owners start a claim and not finish it?
/partwise site — redesign the whole Nook web app, keep the colors
/partwise site next
/partwise overhaul the login page
/partwise use partwise on the cafe details page
/partwise orders dashboard for a small ecommerce admin
/partwise a new stat card for the analytics page
/partwise the settings form feels cramped, fix the spacing
/partwise review the checkout screen
/partwise polish the onboarding flow, ios
/partwise as a figma mockup: pricing page, in <figma url>
/partwise frame                       # write the design file from what is built
/partwise frame fresh, new direction  # research 3 new directions, you pick one
```

### Frame and fresh directions

Every job takes its direction from the project's design file (`design.md`,
or whatever the project already uses). Nothing but `frame` changes it.

- **`/partwise frame`** in a project with no design file writes one from what
  is already built. No research, cheap.
- **`/partwise frame`** in a new project, or **`/partwise frame fresh`** in an
  existing one, researches three distinct directions in Refero and stops to
  ask you to pick one. It also lists the rules it is carrying over (brand
  marks, color meanings, product promises) so you can strike any. Then it
  writes the new design file, on a branch, and rebuilds the most important
  page in the new direction as proof. Other pages move over one per run.
- **Pin what should stay**: "frame fresh, keep the colors" (or the type, the
  logo, the dark theme). Pinned layers keep their exact values; the three
  directions differ in everything else.
- Without the words "fresh", "new direction", "new look" or "redesign the
  site", the existing design file always wins.

## Scenarios

Open Claude Code in the project folder and type one line. The skill picks the
job; you can also name it. Every scenario below is one request unless it says
otherwise.

### The layers

```
ux        research the journeys          what should change, and why
site      the whole product              map, flows, direction, design system, plan
overhaul  one page                       brief, sort parts, build
part      one component                  three references, build
tweak     one small change               no research
```

Bigger jobs run the smaller ones inside them. Start at the highest layer you
actually need; most days that is `overhaul` or `tweak`.

### Starting something new

**A new app or site from an idea.**
```
/partwise site — a habit tracker for students, iOS. They log habits daily,
see streaks and get reminders. Calm and simple.
```
Sets up the project (Next.js on web, SwiftUI on iOS, unless you name a
stack), plans the fewest pages that cover each job, maps the flows, asks you
to pick one of three directions, builds the design system with every
component state on a `/design` preview page, writes `docs/design-plan.md`,
and builds the first screen. Then `/partwise site next`, once per screen.

**A new app, research first.**
```
/partwise ux — how should a new user get from install to their first logged habit?
/partwise site — <the app idea>
```
`site` starts from the recommended flows the research wrote.

**A one-page site or landing page.**
```
/partwise overhaul the landing page — a portfolio for a freelance photographer
```
Also loads `studio-design` if installed; `commerce-design` for a store.

**A Figma mockup instead of code** (for a client, or to decide before building).
```
/partwise as a figma mockup: pricing page, in <figma file url>
```
Builds in Figma with a reference board beside the screen.

### Redesigning what exists

**The whole product, new look.**
```
/partwise site — redesign the whole app, fresh direction
/partwise site next        (repeat per page)
```

**New look, but keep parts of the brand.**
```
/partwise site — fresh direction, keep the colors and the logo
/partwise frame fresh, keep the fonts
```
Pinned layers keep their exact values; the three directions differ in
everything else.

**Just the direction, no pages yet.**
```
/partwise frame fresh, new direction
```
Writes the design file and rebuilds one page as proof.

**One page.**
```
/partwise overhaul the login page
/partwise use partwise on the cafe details page
/partwise overhaul the settings page, the notifications section is the problem
```
Writes a five-line brief, checks the direction fits this kind of product,
sorts the page's parts into keep, restyle and rethink, researches only the
rethink parts, builds and checks.

**Several related pages onto the current design** (after a new direction).
```
/partwise polish the login, register and claim pages, bring them onto the design file
```
Restyle only, no research. Cheap.

**One section that feels weak.**
```
/partwise the hero feels flat, find options that don't use a photo
/partwise rethink the reviews section on the cafe page
```

**One new component.**
```
/partwise a new stat card for the analytics page
/partwise add a filter bar above the orders table
```

### Fixing and finishing

**A small visual fix.**
```
/partwise the save button on the profile form is misaligned
/partwise the settings form feels cramped, fix the spacing
/partwise make the empty inbox message friendlier
```
No research; reads the craft floor only when needed.

**Before shipping.**
```
/partwise polish the checkout page
/partwise polish the onboarding flow, ios
```
Fixes in order: anything blocking the task, missing states, drift from the
design system, hierarchy, craft details, decoration. Puts long names, empty
lists and many rows through every part.

**"Make it look better."**
```
/partwise make the dashboard look better
```
Runs as polish. If a part's structure is the real problem, it rebuilds that
part with research and says so.

### Judging without changing anything

**A critique.**
```
/partwise review the checkout screen
/partwise what's wrong with the home page?
```
Ranked findings, each with a place and a fix: must fix, should fix, could be
better, working well. Changes nothing.

**UX research on a journey.**
```
/partwise ux — why do owners start a claim and not finish it?
/partwise ux — review the search-to-booking journey
```
Walks the journey in your app, compares it step by step with three real
products' flows, pulls real drop-off from your analytics if the project has
them, and writes `docs/ux/<topic>.md`: findings, a recommended flow, and what
to test with real people. No design, no code.

### Setting up the design system

**Write down the design you already have.**
```
/partwise frame
```
Extracts `design.md` from what is built. No research.

**Build the design system for an existing product.**
```
/partwise site — set up the design system, keep the current look
```
Tokens, shared components, every state, and a `/design` preview page; then a
plan for moving pages onto it.

**A component the system lacks.**
```
/partwise add a toast component to the design system
```

### Picking up later

**Continue a site plan.**
```
/partwise site next
```
Builds the next unticked page in `docs/design-plan.md`.

**Redo a part with saved references.**
```
/partwise rethink the sidebar again
```
Reads `docs/references/<page>/` first and only researches what is new.

### Steering any of the above

| Add to the request | Effect |
|---|---|
| `fresh`, `new direction`, `new look` | Allowed to replace the design file; otherwise it is never changed |
| `keep the colors / fonts / logo` | Pins that layer through a fresh direction |
| `ios` or `web` | Sets the platform when the project doesn't make it obvious |
| `as a figma mockup` | Builds in Figma instead of code |
| `the X section is the problem` | That part is rethought first |
| Naming the parts ("sidebar, stat cards, orders table") | Research stays on those; cheaper |
| `no photos in the hero` | Recorded as a constraint in the design file |

### When not to use it

- Pure backend or logic work.
- A change where you already know the exact value ("make the button 44px"):
  just ask for the change.
- Content and copy for a whole site: it writes interface copy, not your
  marketing.

### Cost, roughly

| Job | Research | Tokens (measured where noted) |
|---|---|---|
| tweak, review, polish, tells | none | small; polish ~80k (measured) |
| part | one helper | ~80-100k on a mid-tier model (measured) |
| overhaul | one helper per part to rethink | ~80-100k per rethought part |
| frame fresh, site direction | one helper | ~90-105k (measured) |
| ux | one helper per journey | ~80-100k per journey (estimate) |
| site | direction + flows + system + one page | the largest; one page per run after that |

Research runs on a cheaper model in helpers, so search results and
screenshots stay out of your main session. Start a new session per page on
long runs.

## What is in here

Under `skills/partwise/`:

| File | What | Read for |
|---|---|---|
| `SKILL.md` | Router: picks the job, mode and target; checking rules | every job |
| `references/craft.md` | The craft floor | every job that edits or judges UI |
| `references/web.md`, `ios.md` | Platform rules | the mode in use |
| `references/review.md` | Review and polish | `review`, `polish` |
| `references/tells.md` | The AI-look checklist and the ask-before-fixing flow | `tells` |
| `references/screen.md` | The part-by-part pipeline | `build`, `part` |
| `references/ux.md` | UX research, and the flow scout brief | `ux` |
| `references/site.md` | The whole product: map, flows, direction, system, plan | `site` |
| `references/overhaul.md` | The whole process for one page | `overhaul` |
| `references/frame.md` | The design file: what it holds, extract, new and fresh | `frame` |
| `references/frame-scout.md` | Brief for the direction research subagent | frame scouts only |
| `references/scout.md` | Brief for the per-part research subagent | scouts only |
| `references/parts.md` | Catalog of parts and query wording | scouts only |
| `references/code.md` | Building into a codebase | target `code` |
| `references/board.md`, `figma.md` | Figma reference board and build rules | target `figma` |
| `scripts/refcrop.sh` | Crops a part out of a screenshot by percentage box | |
| `scripts/refsheet.sh` | Puts several images on one labeled contact sheet | |

## Credits

The craft floor draws on rules that recur across published agent design
skills, restated here: Refero's `refero-design` (MIT), Paul Bakaus's
`impeccable` (Apache-2.0), Anthropic's `frontend-design`, Vercel's web
interface guidelines and Emil Kowalski's design engineering skills.

The `ux` job's methods come from published practice: Nielsen Norman Group
(cognitive walkthrough, PURE, severity ratings, journey mapping), the GOV.UK
Design System's question-page patterns, W3C WCAG 2.2, Google's HEART
framework, lawsofux.com, and the evidence labels in ux-crux (MIT).
