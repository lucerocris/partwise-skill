# Part scout

Find three real-product references in Refero for **one part** of a screen,
crop each down to that part, and report back. You are given: the part (name,
job, content, states), the mode (`web` or `ios`), a scratch folder, and the
path to this skill's folder.

Everything you look at stays with you. Only the short report at the end goes
back, so keep it exact.

Tools: `refero_search_screens`, `refero_get_screen_image`,
`refero_get_similar_screens` (load with one ToolSearch call if deferred), a
shell with `curl` and ImageMagick, and a way to read image files.

## 1. Search (2 queries, one call each, in parallel)

`refero_search_screens` with `platform` = the mode and
`response_format: "md"`. Never `json`: it returns many times more text.

Write each query as the **anatomy of the part**: what it is and how it is
arranged. Not the page it sits on, and not the user's subject matter.

| Weak | Strong |
|---|---|
| dashboard | metric cards row with trend delta and comparison period |
| orders table with customer and payment status | data table with status tabs, sortable columns and row actions |
| habit row with streak | checklist row with leading icon, meta line and trailing check circle |

Subject nouns (orders, habits, invoices) pull in whole screens about that
subject. If the setting matters, add "admin" or "back-office". Use the second
query for a different arrangement or state, or a product known for this part
("Linear sidebar"). `parts.md` in this folder has query wording per part.

A third query only if the first two give fewer than four usable hits. Then:
page 2, or `refero_get_similar_screens` on the best hit.

## 2. Shortlist 5, from the text

- The part is really there: trust the `UI Elements` tags (`Table`, `Tabbar`,
  `Sidebar & Drawer`, `Cards & Tiles`...) over the description.
- Five different products. Results cluster by app; one screen per product.

## 3. Look at all five in one image

```bash
<skill>/scripts/refsheet.sh <scratch>/<part>-cand.png \
  "1 Programa=<Thumbnail URL>" "2 Square=<Thumbnail URL>" ...
```

Read the sheet. Choose **three**, rejecting screens where a popover, modal or
toast covers the part, near-empty instances (a table with one row), and parts
plainer than their tags suggested. Prefer three that solve the part in
visibly different ways, with a content load near the user's.

Fewer than three good ones is an acceptable result. Do not pad.

## 4. Measure and crop the three

Get one image per chosen screen to measure on:

- **web:** the thumbnail the sheet already saved, `<scratch>/<part>-cand/<n>.jpg`
  (n = position in the sheet command). If the part is not visible there
  because it is below the first viewport, call `refero_get_screen_image` with
  `image_size: "full"` instead and use the local path its result reports
  (`[Image: source: /...jpg]`).
- **ios:** `refero_get_screen_image` with `image_size: "full"` (the thumbnail
  is too small to crop from). Note screen id → reported path as each result
  arrives; the filenames do not say which screen they are.

Read the image and box the part as percentages of that image: left, top,
right, bottom, 0-100. Then:

```bash
<skill>/scripts/refcrop.sh --sharp "<Preview URL>" <measured-image> <l> <t> <r> <b> <scratch>/<part>-<product>.png
```

`--sharp` is optional: pass the screen's `Preview URL` when it has one. The
script uses it only if it matches the measured image's shape. The script
prints the crop's pixel size; keep it.

When the part repeats on the screen (cards in a grid), crop two or three
together: the spacing between them is part of the pattern.

## 5. Check the crops in one image

```bash
<skill>/scripts/refsheet.sh <scratch>/<part>-crops.png \
  "Programa=<scratch>/<part>-programa.png" "Square=..." "Ballpark=..."
```

Read it. Re-crop any where the part is clipped or more than about a quarter
is something else. An element that belongs to the part but floats away from
it (an add button above a tab bar) stays in. Rebuild the sheet after
re-cropping: the caller will look at this sheet instead of your crops.

## 6. Decide and report

Pick one **primary** for anatomy. From each of the others take at most one
detail, or nothing. Do not average three layouts into a fourth.

The primary and borrowed details together must cover everything listed in the
part's content. If the part needs an add button, a reference that has one is
worth more than a tidier one that does not; never reject a reference for
having something the part asks for. If nothing found covers a requirement,
say so in NOTES. Between two that fit, prefer the more distinctive
arrangement over the most ordinary one.

Took lines name a **structural** decision someone could check against the
crop: what is in the part, order, position, stacking, shape, how states show.
Never color, typeface, fill, radius or shadow; the caller has its own
styling. "Clean modern look" is not a Took line, and neither is a list of the
table's columns. One sentence, 25 words at most, for each Took line and for
each clause of SPEC.

Reply with exactly this and nothing else:

```text
PART: <name>
SHEET: <scratch>/<part>-crops.png
SPEC: Primary: <product> — <anatomy in one line>. Borrow: <product> — <one detail>. Rejected: <product> — <why>.
REFS:
<product> | <ReferoURL> | <crop path> | <W>x<H> | Took: <one sentence>   (or "Considered, not taken: <reason>")
<product> | <ReferoURL> | <crop path> | <W>x<H> | <...>
<product> | <ReferoURL> | <crop path> | <W>x<H> | <...>
NOTES: <only if fewer than 3 references, or something the builder must know>
```
