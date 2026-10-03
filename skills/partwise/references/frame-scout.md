# Frame scout

Find three distinct design directions for a whole product, grounded in real
products in Refero, and report back. You are given the product, its reader,
its page types, any words the user used for the feel, constraints that must
hold, any pinned layers that must stay exactly as they are (for example the
color palette), the mode (`web` or `ios`), a scratch folder and the skill's
folder.

This is the opposite of part research: here the whole page is the point.
Look at layout, rhythm, color, type and density across a page, not at one
component.

Everything you look at stays with you. Only the report at the end goes back.

Tools: `refero_search_styles`, `refero_get_style`, `refero_search_screens`,
`refero_get_similar_screens`, `refero_search_flows` (load with one ToolSearch
call if deferred), a shell with `curl` and ImageMagick, and a way to read
image files. Always `response_format: "md"`.

## 1. Gather candidates

- **Web:** 3 `refero_search_styles` queries describing a feel, not the
  product's domain ("calm dense workspace with one accent", "editorial black
  and white with ruled lists", "warm tactile study tool"). Use the user's
  words if they gave any. Then 2 `refero_search_screens` queries for the main
  page type, written as its skeleton ("index page listing items as ruled
  rows with progress", "dashboard home with activity and shortcuts").
- **iOS:** Refero has no iOS styles. 3 `refero_search_screens` queries for the
  main screen type, then pick strong apps from the hits and look at 2-3
  screens of each (`refero_get_similar_screens`), since what stays the same
  across an app's screens is its direction.
- If the product has a journey (onboarding, a drill, checkout), one
  `refero_search_flows` query for it.

## 2. Form three directions

Cluster what you found into three directions that differ in a way the user
would see at a glance: light vs dark, airy vs dense, editorial vs tool-like,
quiet vs expressive. Three near-identical directions are a failed result.

Each direction gets one **primary source** (a style or an app whose look it
follows) and up to two secondary ones for specific details.

**Pinned layers stay fixed in all three directions.** If the palette is
pinned, the directions differ in everything else (layout, rhythm, type,
density, shape) and each one uses the pinned colors in its own way: say which
color takes which role. Prefer sources whose palette is close to the pinned
one, or whose look does not depend on its colors; a direction that only works
in its source's colors is a failed result. Write the pinned values, not the
source's, in the COLOR line. Check each
direction against the constraints and drop or adjust any that breaks one.

Avoid directions that are the autopilot looks: indigo or violet accent by
default, cream with terracotta, near-black with one neon accent, everything
in identical rounded cards, gradient text. Only if the product clearly calls
for one, and then say why.

## 3. One sheet per direction

For each direction, three whole-page images on one sheet: its primary
source's main page plus two more that show the same feel on other page types.
At least one of the three must be a working product screen of a page type
this product has (a list, a workbench, a settings page), not a marketing page:
styles come from marketing sites, and a direction the user picks must show
how an actual screen of theirs would look.

```bash
<skill>/scripts/refsheet.sh <scratch>/direction-<n>.png \
  "Primary Name=<Thumbnail or Preview URL>" "Second=<URL>" "Third=<URL>"
```

For a style, use its preview image URL. Read each sheet once to confirm it
shows what the direction claims.

## 4. Report

Reply with exactly this and nothing else:

```text
DIRECTION 1: <short name>
SHEET: <scratch>/direction-1.png
THESIS: <one sentence: what it feels like and why it fits this reader>
SOURCES: <primary name> (<url>); <secondary> (<url>) — <what detail>
COLOR: <canvas>, <surfaces>, <text>, <accent and its role>, light|dark
TYPE: <faces and jobs, scale in a phrase>
RHYTHM: <density, dividers, how loud moments recur>
SKELETON: <how the main page type is laid out, one line>
SHAPE: <radius, borders or shadows>
RISK: <what could go wrong with it for this product, one line>

DIRECTION 2: ...
DIRECTION 3: ...
```

Every field one line. Colors as hex where the source gives them, otherwise
described ("near-white, slightly warm").
