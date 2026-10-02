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
> direction lock.** Structure is what is in the part, in what order, where it
> sits, how it stacks, what shape it has, how states show. Styling is color,
> typeface, fill, radius, shadow. A reference never brings its own styling.
>
> **2. Every reference is shown, cropped, next to what it produced.** Each crop
> on the board carries a line saying what was taken from it, or that it was
> considered and rejected.

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
  `use_figma` call if either the Figma plugin or the `skill://figma/...`
  resources offer them. If neither does, `references/build.md` lists the rules
  this skill depends on; read it instead and carry on.
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
| **File** | The target Figma file and page. If none was given and there is no obvious one, create a file with `create_new_file`. |

## 2. Lock the direction once

Decide color, type, radius, spacing density and elevation for the whole screen
before looking at any part. Write it down as a short token list. Source, in
order of preference:

1. **The file's own design system.** If the Figma file already has variables,
   styles or built screens, that is the direction. Do not research a new one.
2. **Web, nothing existing:** `refero_search_styles` with 2 queries describing
   the feel ("calm neutral admin with one accent"), then `refero_get_style` on
   the best one. Refero styles are taken from marketing pages, so do not query
   by product domain for an app screen ("ecommerce" returns storefronts), and
   expect the style to give palette, type and radius only.
3. **iOS, nothing existing:** Refero styles do not cover iOS. Find one strong
   app in the same category and take its colors: call `refero_get_screen` on
   one of its screens and read the `Colors` list (`0xRRGGBB`) and the hex
   values in the description. Any screen of that app will do, colors are
   app-wide. If category searches return onboarding and paywalls instead of the
   app's main screens, search by app name. Fill the rest from iOS conventions:
   44pt touch targets, 16-20pt side margins, safe areas.

Whatever the source, it will not cover everything an app screen needs. Decide
these yourself and list them as **guessed** on the board: status colors
(success, warning, danger), surface steps (canvas vs card), and data density
(row height, table text size).

Atoms are defined here too: buttons, inputs, chips, checkboxes, icons. Do not
search Refero for them (see step 3). For icons, one open set (Lucide on web,
SF Symbols style on iOS) at one size and stroke; see `references/build.md`.

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
- **Every requirement gets a host part.** Something in the brief that is too
  small to research ("a way to add a habit") is assigned to the part it lives
  in (the tab bar), and that part's query mentions it.
- **One element, one owner.** If two parts would both contain the same thing (a
  week strip in the header and in the summary card), decide now which part
  owns it.

See `references/parts.md` for a catalog of parts per mode with query wording.

## 4. Find three references per part

Run 2 `refero_search_screens` queries per part with the mode as `platform` and
`response_format: "md"`. The `md` format gives a short description and the
image URLs for each hit; `json` returns many times more text for the same
hits. Fire the queries for all parts in parallel. Add a third query only for a
part whose first two came back thin.

**Write the query as the anatomy of the part**: what kind of thing it is and
how it is arranged. Never the page it sits on.

| Weak | Strong |
|---|---|
| dashboard | metric cards row with trend delta and comparison period |
| settings page | settings form section with inline save and helper text |
| sidebar | collapsible sidebar with nested sections and workspace switcher |
| onboarding | onboarding step with progress dots and single choice list |

Keep the user's content nouns out of the query. Search matches on them and
drags in whole screens about that subject: "orders table with customer and
payment status" returns shoppers' order-history pages, "habit row with streak"
returns streak onboarding screens. Say "data table with status tabs and row
actions" instead. If the domain matters, add it as a setting ("admin",
"back-office"), not as content. Use the second query for a different
arrangement or state ("empty table with call to action"), or for a product
known to do this part well ("Linear sidebar").

**Shortlist, look, then choose.** From the hits, shortlist 4-5 per part where:

1. **The part is really there.** The `UI Elements` tags are the reliable
   signal (`Table`, `Tabbar`, `Sidebar & Drawer`, `Checklist & To Do`), backed
   by the description.
2. **Each is a different product.** Results cluster: five of the top ten are
   often one app. Never two references from one product for one part.

Look at each shortlisted screen once with `refero_get_screen_image`,
`image_size: "full"`. This same view is what you measure the crop on in step
5, so note the box while you are looking. Then choose **three**, rejecting:

- screens where a popover, modal or toast covers the part;
- near-empty instances (a table with one row, a list with one item);
- screens where the part is plainer than its tags suggested.

Prefer three that solve the part in visibly different ways over three
near-identical ones, and ones with a content load close to the user's.

If a part has fewer than three good ones: page 2, a reworded query, or
`refero_get_similar_screens` on the best hit. If it still has fewer than
three, use what exists and say so on the board. Do not pad with weak ones.

`refero_get_screen` returns a long written description per screen with
estimated sizes, paddings and colors. It is expensive, and the colors are
styling you will not use. Call it only when you need a measurement the crop
cannot show, and only for a part's primary reference.

## 5. Crop each reference to the part

1. **Box the part** on the full image you viewed, as percentages of that image:
   left, top, right, bottom, each 0-100.
2. **Crop** with the bundled script, passing the local file the image tool
   saved. The tool result names it in a line like
   `[Image: source: /.../mcp-refero-blob-....jpg]`. The filename says nothing
   about which screen it is, so record screen id → path as each result
   arrives, not afterwards.

   ```bash
   scripts/refcrop.sh --sharp "<Preview URL>" <local-image> <left> <top> <right> <bottom> <out.png>
   ```

   `--sharp` is optional and takes the `Preview URL` from the search result. It
   is a larger copy for some screens and only the top viewport of a long page
   for others; the script uses it when it has the same shape as the image you
   measured and falls back to the local image otherwise. Leave it out when a
   screen has no Preview URL, which is common on iOS.

   If no local path was reported, download the `Thumbnail URL` and measure and
   crop on that.
3. **Look at the crops.** Build one contact sheet per part and read that,
   rather than opening every crop:

   ```bash
   magick montage crops/sidebar-*.png -tile x1 -geometry '480x480>+12+12' -background '#eeeeee' crops/sheet-sidebar.png
   ```

   If a part is clipped, or more than about a quarter of a crop is something
   else, adjust the box and crop again. Exception: an element that belongs to
   the part but floats away from it (an add button above a tab bar) stays in,
   even if it drags empty space along. Do not upload a crop you have not
   looked at.

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
Rejected: Mercury — centered value; conflicts with the primary's left alignment
Not taken: any colors, fonts, radius (direction lock decides those)
```

A reference that is a genuinely different answer may have nothing compatible
to give. Keep it on the board with "Considered, not taken:" and the reason.
That is a result, not a failure.

Took lines describe structure only. If a detail you liked turns out to be
styling the direction lock overrides (a monospace id, a tinted active pill),
leave it out of the Took line rather than have the board promise something the
build does not show.

## 7. Put the references in Figma

Build the reference board with the script in `references/board.md`. One board
per screen, one row per part, each row showing its crops with product name
(linked to the Refero page) and the Took line. The script returns one empty
slot node per crop; `upload_assets` then fills the slots.

The board goes on the same page as the screen, not on a separate page: the
point is to see references and result together. For an existing frame, the
board lands to its right. For a new build, the board goes first and the
script returns where the screen should go (to the board's right, 120px gap).

## 8. Build part by part, then assemble

Read `references/build.md` first: frame skeletons per mode, the Figma
behaviors that silently break a build, and icons.

Create the screen frame at the position the board script returned. Build each
part as a named frame **inside** it, one part at a time, following its part
spec for structure and the direction lock for every visual value. Do not build
parts as loose top-level frames and move them in later. Use the user's real
content from the brief, never the reference's copy, logos or product names.
Name each part's frame exactly as on the board so rows and built parts match.

When all parts are in, assembly is where they fight: one spacing scale, one
radius, one type scale across all of them. Fix mismatches toward the direction
lock, not toward whichever reference is loudest.

## 9. Check and report

Screenshot the board and the built screen, and check:

- **Text rendered.** A font can load without error and still draw nothing. If
  the screenshot shows no text, see `references/build.md`.
- **Anatomy.** For each part, is the primary's structure from the part spec
  actually there? Fix what drifted.
- **Board matches build.** Every Took line is visible in the built part. Fix
  the part or reword the line.
- **Collisions.** Overlap, clipped text, and content hidden under floating
  elements: a tab bar or floating button covering the last row's controls is
  the usual iOS failure.
- **One styling.** No part still wearing its reference's colors or radius.

Finish with a short trace, in chat:

```text
Part         | Primary    | Borrowed from     | Notes
Sidebar      | Understory | Linear, Dropbox   |
Stat card    | Stripe     | Linear            | Mercury considered, not taken
Orders table | Attio      | Retool            | only 2 good references
```

Plus the Figma link, the direction source, and what was guessed.

## Limits worth knowing

- **Screenshots are small.** 800 to 1120px wide for a whole screen, so a
  cropped card may be 300px. Crops show structure and hierarchy well and exact
  spacing poorly.
- **Crops are eyeballed.** The box comes from looking at the image. The
  contact-sheet check is not optional.
- **Cost scales with parts × references.** 5 parts means about 10 searches, 20
  images viewed and 15 crops. Keep to 7 parts or fewer; split a bigger screen
  into two runs.
- **A plain primary gives a plain part.** If the best reference for a part is
  the most ordinary version of it, the part will be ordinary. Prefer a primary
  with a point of view, as long as it fits the content.
- **References are other companies' real products.** They are for study, on a
  working board. Do not ship their copy, logos, illustrations or screenshots
  in the design itself.
