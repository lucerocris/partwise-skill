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
/partwise orders dashboard for a small ecommerce admin
/partwise a new stat card for the analytics page
/partwise the settings form feels cramped, fix the spacing
/partwise review the checkout screen
/partwise polish the onboarding flow, ios
/partwise as a figma mockup: pricing page, in <figma url>
```

## What is in here

Under `skills/partwise/`:

| File | What | Read for |
|---|---|---|
| `SKILL.md` | Router: picks the job, mode and target; checking rules | every job |
| `references/craft.md` | The craft floor | every job that edits or judges UI |
| `references/web.md`, `ios.md` | Platform rules | the mode in use |
| `references/review.md` | Review and polish | `review`, `polish` |
| `references/screen.md` | The part-by-part pipeline | `build`, `part` |
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
