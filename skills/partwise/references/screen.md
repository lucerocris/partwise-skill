# Building a screen or a part

The pipeline for jobs `build` and `part`. Mode, target and the two rules come
from SKILL.md.

**Keep it cheap.** Search results and screenshots are the bulk of the cost and
none of them are needed once a part's references are chosen. The research for
each part is done by a scout (step 4) that returns a few lines. Do not read
`scout.md` or `parts.md` yourself unless you are scouting inline.

Run autonomously. Do not ask the user to approve the part list or the
references; they are saved with the references and can be corrected
afterwards. Ask only for what no default can fill: what the screen is for, or
(target `figma`) which Figma file to use.

Needs: Refero MCP tools (load deferred ones in a single ToolSearch call),
ImageMagick, curl, and a scratch folder. Figma MCP tools only for target
`figma`.

## 1. Read the task

| | How to decide |
|---|---|
| **Screen** | What it is and what the user does on it, in one sentence. |
| **Input** | A text brief (build new), or an existing Figma frame (screenshot it and decompose what is there). |
| **File** | Target `figma` only: the Figma file and page. None given: `create_new_file`. |
| **Existing references** | Target `code`: look for `docs/references/<screen>/README.md` in the project. Parts already recorded there are reused as they are: take the spec from the README and look at the saved crops with one `scripts/refsheet.sh` sheet. Scout only parts that are new, or that the user wants redone. |

## 2. Take the direction

The direction is the project's design file. Read it: the page skeleton for
this page type, the rhythm and the emphasis budget decide as much as the
colors do, and parts are judged against them.

- Job `part`: no design file is fine; use the project's tokens, theme and
  components as they are.
- Job `build` with no design file: run `frame` first (`frame.md`). In an
  existing project that is a cheap extract; in a new project it researches
  directions and asks the user to pick one.
- Target `figma`: the Figma file's variables and styles count as its design
  file when there is no file in a codebase.

Atoms (buttons, inputs, chips, icons) come from the direction, never from
research.

## 3. Break the screen into parts

Job `part`: there is one part. Write its row and go to step 4.

3 to 7 parts, each with a name, a one-line job, its content, and its states:

```text
Sidebar      | primary nav, 6 sections, two with children | active, collapsed group, workspace switcher
Stat card    | one metric + change vs last period          | up, down, no data
Orders table | 8 columns, sortable, row actions            | empty, selected row, loading
```

A part is **something a product team would name and design on its own**:
sidebar, top bar, stat card, data table, filter bar, form section, modal,
empty state, tab bar, list row, bottom sheet.

- Too big ("the dashboard"): split it. Too small ("primary button", "icon"):
  it is an atom; every screen has one, so search returns noise.
- A part that repeats (cards in a grid) is one part.
- Every requirement gets a host part: something too small to research ("a way
  to add a habit") is written into the part it lives in.
- One element, one owner: if two parts would both hold the same thing (a week
  strip), decide now which one has it.

## 4. Scout every part

Start one subagent per part, all at once, on a mid-tier model (Sonnet class).
In testing that was cheaper than scouting on the main model and judged
references just as well; the smallest model (Haiku class) cost a little less
again but accepted clipped crops and rejected the one reference that had what
the part asked for. Each scout gets only this:

```text
Follow <skill folder>/references/scout.md exactly. Read that file first.

Part: <name> | <job and content> | states: <states>
Mode: <web|ios>
Scratch folder: <scratch>/<part>
Skill folder (<skill>): <skill folder>

Reply with the report block the file specifies, nothing else.
```

Each returns a short block: a part spec (primary, borrowed details, rejected),
three references with crop path, pixel size, Refero link and a Took line, and
the path of one contact sheet showing the three crops.

No subagents available: follow `references/scout.md` yourself, one part at a
time, and keep nothing from a part but its report block.

When the reports are in:

- **Read each part's contact sheet** (one image per part). That is your look
  at the references; do not open the individual crops or the search results.
- **Check the Took lines against rule 1.** Remove any that describe styling.
- **Resolve clashes between parts** in favor of the direction.
- A part reported with fewer than three references stays that way.

## 5. Save the references

The scratch folder does not survive the session. The references are the
record of where each part came from and what a later revision starts from, so
they are saved before anything is built.

**Target `code`:** into the project, next to the code they produce. Use
`docs/references/<screen-slug>/` unless the project keeps design notes
elsewhere. Copy in the three crops of each part (not the contact sheets or
candidates) and write a `README.md`:

```markdown
# Orders dashboard · references (web)

Direction: project theme (`src/styles/tokens.css`). Guessed: status colors.
Researched 2026-10-03 with partwise.

## Sidebar
Primary nav, 6 sections, two with children; workspace switcher.
Built in `src/components/Sidebar.tsx`.

**Primary: Understory.** Borrow: Linear. Rejected: Dropbox.

| | Product | Taken |
|---|---|---|
| ![](sidebar-understory.png) | [Understory](https://refero.design/pages/...) | Switcher pinned to the bottom edge behind a hairline |
| ![](sidebar-linear.png) | [Linear](https://refero.design/pages/...) | Pinned favorites above the main list |
| ![](sidebar-dropbox.png) | [Dropbox](https://refero.design/pages/...) | Considered, not taken: icon-only rail hides the nested groups |
```

Fill in each part's "Built in" path after step 6. When adding parts to an
existing README, add sections; leave the others as they are.

These are screenshots of other companies' products. If the folder is not
already tracked by git, add it to `.gitignore` so it is not published by
accident, and say so in the final report; the user commits it if they want
it in the repo.

**Target `figma`:** read `references/board.md` and build the board from the
reports: one row per part, crops with product name (linked to its Refero
page) and Took line, on the same page as the screen. For an existing frame it
lands to the frame's right; for a new build it goes first and the script
returns where the screen goes.

## 6. Build part by part, then assemble

**Target `code`:** read `references/code.md` and build in the codebase. Skip
the rest of this step.

**Target `figma`:** read `references/figma.md`: it has the `use_figma` rules
this skill depends on, screen skeletons per mode, fonts and icons. That is enough to build with;
load the larger `figma-use` skill only if a script fails twice on the same
thing.

Create the screen frame where the board script said. Build each part as a
named frame **inside** it, following its spec for structure and the direction
lock for every visual value. Use the user's real content, never a reference's
copy, logos or product names. Name each part's frame as on the board.

Then make the parts agree: one spacing scale, one radius, one type scale. Fix
mismatches toward the direction, not toward the loudest reference.

## 7. Check and report

Check in bounded passes, as SKILL.md describes. On top of the craft floor,
look for:

- **Text rendered.** A font can load and still draw nothing (see `figma.md`).
- **Anatomy.** Each part shows its primary's structure, and every Took line
  saved with the references is visible in the build. Fix the part or reword
  the line.
- **Collisions.** Overlap, clipped text, and controls hidden under a tab bar
  or floating button.
- **One styling.** No part still wearing its reference's colors or radius.

Finish in chat with a short trace, where the references were saved (folder
path, or Figma link), the direction source and what was guessed:

```text
Part         | Primary    | Borrowed from     | Notes
Sidebar      | Understory | Linear, Dropbox   |
Stat card    | Stripe     | Linear            | Mercury considered, not taken
Orders table | Attio      | Retool            | only 2 good references
```

## Limits worth knowing

- **Screenshots are small** (800-1120px for a whole screen). Crops show
  structure and hierarchy well, exact spacing poorly. For a measurement,
  `refero_get_screen` on the primary gives estimated sizes; it is long, so
  call it for one screen and only when needed.
- **A plain primary gives a plain part.** If a part comes back ordinary,
  re-scout it asking for a more distinctive arrangement.
- **Keep to 7 parts.** Split a bigger screen into two runs.
- **References are other companies' products**, for study. Never ship their
  copy, logos or screenshots in the design, and do not publish the reference
  folder without the user choosing to.
