---
name: refero-parts
description: Part-by-part design inspiration from Refero, built in Figma. Instead of searching Refero for "a page like mine", break the screen into parts (sidebar, stat card, table, form, modal, tab bar...), find three real-product references for EACH part, crop each reference down to just that part, pin the crops on a reference board in Figma, then build the screen part by part from them. Use when designing or redesigning a screen, section or component in Figma with Refero connected, for web or iOS, or when the user says "find inspiration for this card / sidebar / section", "break it down", "part by part", "reference board", or complains that Refero results are too generic or page-level. Needs the Refero MCP and the Figma MCP.
---

# Refero Parts

Refero indexes whole screens. Ask it for "a dashboard" and you get ten average
dashboards, and the design that comes out is the average of those. But its
search is semantic and answers component-level questions well: "collapsible
sidebar with nested sections and workspace switcher" returns real sidebars.

So the unit of research here is the **part**, not the page. Every part of the
screen gets its own queries, its own three references, and its own crops. The
page is only assembled at the end.

Two rules keep the result from turning into a collage:

> **1. Structure comes from the part references. Styling comes from one
> direction lock.** A reference tells you the anatomy of a sidebar: what is in
> it, in what order, how dense, how states show. It does not get to bring its
> own colors, fonts or radius. Those are decided once, for the whole screen.
>
> **2. Every reference is shown, cropped, next to what it produced.** If a crop
> is not on the board with a line saying what was taken from it, it was not
> used.

Run this autonomously. Do not stop to ask the user to approve the part list or
the references; record both on the board so they can be corrected afterwards.
Ask only when the brief is missing something no default can fill (what the
screen is for, or which Figma file to work in).

## Before starting

- Refero MCP tools (`refero_search_screens`, `refero_get_screen`,
  `refero_get_screen_image`, `refero_get_similar_screens`,
  `refero_search_styles`, `refero_get_style`) and Figma MCP tools (`use_figma`,
  `upload_assets`, `get_screenshot`) must be available. If they are deferred,
  load them all in one ToolSearch call.
- Load the `figma-use` skill (and `figma-generate-design`) before the first
  `use_figma` call, from the Figma plugin or the `skill://figma/...` resources.
- ImageMagick (`magick` or `convert`) and `curl` are needed for cropping and
  uploading.
- Pick a scratch folder for crops (the session scratchpad if there is one).

## 1. Read the task

Settle four things, from the request or by sensible default:

| | How to decide |
|---|---|
| **Screen** | What it is and what the user does on it, in one sentence. |
| **Mode** | `web` or `ios`. Named by the user, else inferred: an existing frame under ~500px wide, or words like "app", "tab bar", "sheet" mean `ios`. If the user wants both, run the pipeline once per mode; references do not transfer between them. |
| **Input** | A text brief (build new), or an existing Figma frame (rebuild or improve it part by part). For a frame, screenshot it first and decompose what is actually there. |
| **File** | The target Figma file. If none was given and there is no obvious one, create one with `create_new_file`. |

## 2. Lock the direction once

Decide color, type, radius, spacing density and elevation for the whole screen
before looking at any part. Write it down as a short token list. Source, in
order of preference:

1. **The file's own design system.** If the Figma file already has variables,
   styles or built screens, that is the direction. Do not research a new one.
2. **Web, nothing existing:** `refero_search_styles` with 2-3 queries (one
   aesthetic, one domain), then `refero_get_style` on the best one or two.
   Pick one as the foundation. Do not blend them into a safe middle.
3. **iOS, nothing existing:** Refero styles do not cover iOS apps. Search 2-3
   whole iOS screens in the same product category, take the direction from the
   one strongest app (its `hex_colors` and description), and fill the rest from
   iOS conventions: SF Pro, 44pt touch targets, 16-20pt side margins, safe
   areas.

Buttons, inputs, chips, icons and other atoms are defined here too. Do not
search Refero for them (see step 3).

## 3. Break the screen into parts

List 3 to 7 parts. For each: a **name**, a one-line **job**, the **content** it
must hold, and the **states** that matter.

```text
Sidebar      | primary nav, 6 sections, two with children | active, collapsed group, workspace switcher
Stat card    | one metric + change vs last period          | up, down, no data
Orders table | 8 columns, sortable, row actions            | empty, selected row, loading
```

The right size for a part is **something a product team would name and
design on its own**: sidebar, top bar, stat card, data table, filter bar, form
section, modal, empty state, pricing card, tab bar, list row, bottom sheet,
onboarding step.

- **Too big:** "the dashboard", "the settings page". That is the old workflow.
  Split it.
- **Too small:** "primary button", "text input", "avatar", "icon". Refero
  returns thousands of unrelated screens for atoms, since every screen has a
  button. Atoms come from the direction lock.
- A part that repeats (a card in a grid, a row in a list) is researched once.

See `references/parts.md` for a catalog of parts per mode with query wording.

## 4. Find three references per part

For each part, run 2-3 `refero_search_screens` queries with the mode as
`platform`. Fire the queries for all parts in parallel.

**Write the query as what is literally visible in that part**, including its
content and state, never the page it sits on:

| Weak | Strong |
|---|---|
| dashboard | metric stat card with trend indicator and sparkline |
| settings page | settings form section with inline save and helper text |
| sidebar | collapsible sidebar with nested sections and workspace switcher |
| onboarding | onboarding step with progress dots and single choice list |

Vary the angle across the 2-3 queries: one by anatomy, one by state or content
("empty orders table with call to action"), and one by a product known to do
this part well ("Linear sidebar", "Stripe data table") when one comes to mind.

Then choose **three**, applying these in order:

1. **The part is really there.** Check the result's `ui_elements` tags and
   description for the part. A hit that merely contains a sidebar somewhere is
   fine; a hit that matched on other words is not.
2. **Three different products.** Results cluster: five of the top ten are often
   the same app. Never take two references from one product for one part.
3. **Three different answers.** Prefer references that solve the part in
   visibly different ways over three near-identical ones. The point is to have
   something to choose between.
4. **Close in content load.** A sidebar with 4 items teaches little about one
   with 20.

If a part has fewer than three good hits: try page 2, reword the query, or take
the best hit and call `refero_get_similar_screens` on it. If it still has
fewer than three, use what exists and say so on the board. Do not pad with weak
references.

Call `refero_get_screen` once with all chosen `screen_ids` for a part (batch,
max 10). The descriptions carry measured-looking detail (hex values, radii,
font sizes, padding) that the screenshot is too small to show. Only fetch full
details for the chosen three, not for every search hit: they are long.

## 5. Crop each reference to the part

For every chosen reference:

1. **Look at it.** `refero_get_screen_image` with `image_size: "full"`.
2. **Box the part** as percentages of the image: left, top, right, bottom, each
   0-100. Percentages, not pixels, because the image you viewed and the file
   you crop may differ in resolution.
3. **Crop** with the bundled script:

   ```bash
   scripts/refcrop.sh <image> <left> <top> <right> <bottom> <out.png>
   ```

   - **Web:** pass the `Preview URL` from `refero_get_screen` (ends in
     `_preview.jpg`). It is about 1120px wide, sharper than the 800px image the
     tool returns. The script downloads URLs itself.
   - **iOS:** the preview URL is not public. Pass the local file path that
     `refero_get_screen_image` reported for the image. If no path was reported,
     fall back to the `thumbnail_url`.
4. **Look at the crop.** Read the output file. If the part is clipped, or more
   than about a quarter of the crop is something else, adjust the box and crop
   again. Do not upload a crop you have not looked at.

Name crops `<part>-<product>.png`. The script adds a small margin by default so
shadows and rounded corners survive.

When the part repeats on the screen (cards in a grid), crop two or three of
them together: spacing between repeats is part of the pattern.

## 6. Say what each reference gives you

For each crop write one **Took:** line, naming a structural decision, specific
enough that someone could check it against the crop:

- Good: "Took: switcher pinned to the bottom edge, separated by a hairline;
  sub-items indented with no icons."
- Useless: "Took: clean modern look."

Then write a **part spec** for each part. Choose one of the three as the
**primary** for anatomy and take at most one detail from each of the others.
Do not average three layouts into a fourth that none of them use.

```text
Stat card
Primary: Stripe — label top-left, value large, delta chip inline right of value
Borrow:  Linear — sparkline fills the bottom edge, no axis
Borrow:  Mercury — "vs last period" as muted caption under the value
Not taken: any colors, fonts, radius (direction lock decides those)
```

## 7. Put the references in Figma

Build the reference board with the script in `references/board.md`. One board
per screen, one row per part, each row showing its three crops with product
name (linked to the Refero page) and the Took line. The script returns one
empty slot node per crop; `upload_assets` then fills the slots.

Place the board **beside** where the screen will be built, not on a separate
page: the point is to see references and result together. For an existing
frame, pass its node id and the board lands to its right.

## 8. Build part by part, then assemble

Build each part as its own frame or component in Figma, following its part spec
for structure and the direction lock for every visual value. Use the user's
real content from the brief, never the reference's copy, logos or product
names. Name each layer after its part so board rows and built parts match.

Then assemble the parts into the screen. Assembly is where parts fight: one
spacing scale, one radius, one type scale across all of them. Fix mismatches
toward the direction lock, not toward whichever reference is loudest.

Put the finished screen next to the board.

## 9. Check and report

Screenshot the board and the built screen. For each part, compare the built
part with its primary crop: is the anatomy from the part spec actually there?
Fix what drifted. Check the assembled screen for overlap, clipped text and
mixed styling.

Finish with a short trace, in chat and nowhere else:

```text
Part         | Primary    | Borrowed from     | Thin?
Sidebar      | Understory | Linear, Dropbox   |
Stat card    | Stripe     | Linear, Mercury   |
Orders table | Attio      | Retool            | only 2 good references
```

Plus the Figma link, the direction source, and anything guessed.

## Limits worth knowing

- **Screenshots are small.** 800 to 1120px wide for a whole screen, so a
  cropped card may be 300px. Crops show structure and hierarchy well and exact
  spacing poorly. Take numbers from the `refero_get_screen` description, and
  treat those as estimates too.
- **Crops are eyeballed.** The box comes from looking at the image. Step 5.4 is
  not optional.
- **Cost scales with parts × references.** 5 parts × 3 references is 15 images
  viewed, 15 crops checked. Keep to 7 parts or fewer; split a bigger screen
  into two runs.
- **References are other companies' real products.** They are for study, on a
  working board. Do not ship their copy, logos, illustrations or screenshots
  in the design itself.
