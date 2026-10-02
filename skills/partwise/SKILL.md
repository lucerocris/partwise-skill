---
name: partwise
description: Main design skill for any UI work, web or iOS, in code (default) or Figma. Use for designing, building, redesigning, restyling, fixing, polishing or reviewing a screen, page, section or component - dashboards, app screens, forms, tables, navigation, modals, landing pages, empty states - and for requests like "make this look better", "design this", "polish this", "review this UI", "what's wrong with this screen". Picks the smallest job that fits (tweak, part, build, review, polish). For new screens and components it designs part by part - breaking the screen into parts, finding three real-product references per part in Refero, cropping and saving them, then building from them - so the result is not a generic average. Carries its own craft floor for typography, color, spacing, states, motion and accessibility. Uses the Refero MCP for research; the Figma MCP only when a Figma mockup is asked for.
---

# Partwise

Design work done the way a product team does it: one part at a time, each
part grounded in how real products solved it, all of it held together by one
set of visual decisions.

Two rules, for every job:

> **1. Structure comes from references. Styling comes from one direction.**
> Structure is what is in a part, in what order, where it sits, how it
> stacks, what shape it has, how states show. Styling is color, typeface,
> fill, radius, shadow. A reference never brings its own styling, and a
> project that already has styling keeps it.
>
> **2. The brief wins.** What the user asked for, then the project's existing
> design, then references, then this skill's craft rules. The craft rules are
> a floor to stand on, not a look to impose.

## Pick the job

Choose the smallest one that fits and say which in one line before starting.
Do not ask; pick, and escalate later if it turns out too small.

| Job | When | Research | Read |
|---|---|---|---|
| **tweak** | Changing something that exists: spacing, a state, copy, alignment, one property, a bug in the look | None | `craft.md` + platform page |
| **part** | One new or redesigned component or section: a card, a sidebar, a form, a tab bar | One scout | `screen.md` + `craft.md` + platform page |
| **build** | A new screen, or a screen redesigned from scratch | One scout per part | `screen.md` + `craft.md` + platform page |
| **review** | "What's wrong with this", critique, audit. Reports; changes nothing | None | `review.md` + `craft.md` + platform page |
| **polish** | "Make this better", pre-ship pass on something already built | None, unless a part's structure is the problem | `review.md` + `craft.md` + platform page |

All of these are in `references/`. Platform page: `web.md` or `ios.md`.

- A tweak that keeps growing is a part. A part whose neighbors all need
  redoing is a build. Say so and switch.
- Polish finds a part that is structurally weak, not just untidy: rebuild
  that one part as job `part`.
- Never run the reference research for a tweak, review or polish. It is the
  expensive step and those jobs do not need it.

## Settle before starting

| | How to decide |
|---|---|
| **Mode** | `web` or `ios`. Named by the user, else from the project (SwiftUI, Flutter, React Native are `ios`), else from the request: "app", "tab bar", "sheet" mean `ios`. Both wanted: do the job once per mode. |
| **Target** | Where the work lands. **`code` by default.** `figma` only when the user asks for a Figma design or mockup. Never both: designing in Figma and then building in code pays for the screen twice. No codebase in the working directory: build `code` as a new standalone project. |
| **Direction** | The visual decisions in force. In an existing project: its tokens, theme and components, as they are. Only a new project, or a redesign the user asked for, gets a new direction (`screen.md` step 2). |

## Before any UI edit

Read `references/craft.md` and the platform page for the mode. Not earlier,
and not for a job that edits nothing but copy or one value.

## Checking

Look at the rendered result, never only the source. And do it in bounded
passes, because open-ended self-review is where design work burns money:

1. Finish the whole job first.
2. One look: the running screen at desktop and phone width for web (1440 and
   390), or the simulator for iOS. One batch of screenshots.
3. Fix everything found, in one batch.
4. At most one more look. Then stop and report what is left.

If the app cannot be run here, say so. Do not claim a screen was checked from
its source.

## Other skills

- Marketing site, landing page, portfolio, agency or studio site: also load
  `studio-design` if it is installed. It owns section order, page skeleton
  and copy voice there.
- Online store: product page, collection, cart, checkout: also load
  `commerce-design` if it is installed.

Partwise still picks the job, researches parts and applies the craft floor.
Where those skills name a specific value, they win.

## Report

Short, in chat: the job that ran, what changed and where, what was checked
and how (rendered or not), anything guessed, and anything found but left
alone. For `build` and `part`, the trace table from `screen.md`.
