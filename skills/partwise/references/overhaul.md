# Overhaul

One command, the whole process, broad to narrow: context, then direction,
then the page as it is, then parts, then build and check. For "overhaul my
login page", "redo the details page", "use partwise on the settings page".
Each stage hands the next one its decisions; nothing below the direction gets
designed until the direction fits.

Run it autonomously. It stops for the user at most once: when a direction has
to be chosen (stage 2).

## 1. Context

Write a brief of five lines, from the request, the project's files (README,
`CLAUDE.md`, product notes, the design file) and the page's code. Ask only for
what none of those answer.

```text
Page:     <which page, its route or file>
Job:      <what a person comes to this page to do, in one sentence>
Product:  <what kind of product this is: listing app, tool, marketing site,
           content site, store, funnel> — like <2-3 real products of that kind>
Reader:   <who, how often, on what device>
Keep:     <what must survive: brand colors, logo, fonts, copy, flows; from
           the request and the design file's constraints>
Signature: <the one thing on this page a person would remember, tied to the
           job and not decoration: a listing's facts-at-a-glance row, a
           dashboard's one live number, a checkout's running total that
           explains itself, a form that previews its result>
```

The signature line is required, and it must add something the page does not
already say; a new way of showing a fact already on the page reads as a
repeat and moves nothing. Prefer a signature that shows what only this
product knows or does: the data competitors don't have, the decision it
makes easier, its own vocabulary. Fixing every problem still leaves a page
that reads as a template: in testing, overhauls raised every score except
distinctiveness until a signature was chosen up front.

The **Product** line decides the rest. A login page inside a listing app is
part of that app; the same page on a marketing site belongs to the site.
Name the kind before looking at any design.

If `docs/ux/` has research covering this page's journey, read its findings
for this page; they decide which parts to rethink in stage 3.

Say the brief in chat in one block and carry on.

## 2. Direction

Find the design file (`frame.md`). Then:

| Situation | Do |
|---|---|
| A design file exists and was written for this kind of product | Use it. |
| A design file exists but was written for a different product (a marketing landing's file, now applied to the app it promotes) | Do not use its page skeletons or rhythm. Run `frame` fresh for this product, pinning the shared layers (colors, logo, fonts, voice) from the existing file. |
| No design file, existing project | Run `frame` extract. Cheap, no research. |
| No design file, new project | Run `frame` new. |
| The user said "fresh", "new look", "new direction" | Run `frame` fresh, pinning whatever they said to keep. |

When `frame` researches directions, this is the one stop: the user picks.

**Before researching directions, ask about type if the request did not
settle it.** Brand fonts are the layer users most often want kept: "Keep
<current font>, or let the directions propose new type?" Fold it into the
direction question if there is one; otherwise one short question.

## 3. The page as it is

Skip for a new page. Otherwise, one look, as in `review.md` (one batch of
screenshots at desktop and phone width, then the code), and sort its parts
into three piles:

- **Keep**: works and already fits the direction. Only restyle.
- **Restyle**: right structure, wrong look. Restyle to the design file; no
  research.
- **Rethink**: the structure is the problem, or the part is new, or it is the
  part the user named. These, and only these, get reference research.

Before sorting, judge the **first screen as a whole**, at phone width and at
desktop width, against the brief's Job line: can a person answer the job's
questions without scrolling? A part can be fine on its own and the first
screen still miss something (the facts people decide on sitting one screen
down); that missing piece goes to whichever part should hold it, as rethink
or restyle.

Most overhauls have one to three parts to rethink. Researching a part that
was already right is the most common waste: say which pile each part went in
and why.

## 4. Parts

For the parts to rethink, run `screen.md` from step 3 (break into parts) with
the brief from stage 1 in each scout's part line, so the scout searches inside
this product's kind. Restyle and keep piles go straight to the build.

## 5. Build and check

Build as `screen.md` step 6 says (`code.md` or `figma.md`): rethought parts
from their references, the rest restyled, everything from the design file's
tokens. Save references as `screen.md` step 5 says.

Check in bounded passes (SKILL.md), and on that look also check, across the
whole page:

- **Repeats.** The same action or fact appearing more than once in one
  screen (the primary button in the header and again in a pinned bar; a
  status shown in the header, a side card and a section below). Parts that
  are right alone add up to this. The page's primary action stays in the
  main block under the title, where people look first; remove repeats from
  pinned bars, side cards and lower sections instead.
- **Every empty state.** Each "none yet" on the page says what belongs there
  and offers the next step, whether or not its part was rethought.
- **The signature** from the brief is visible in the first screen.

Then report:

```text
Brief:      <the five lines, shortened>
Direction:  <design file used | written by frame (which way in) | chosen: name>
Parts:      Rethought <list, with primary reference each>
            Restyled  <list>
            Kept      <list>
Checked:    <widths, states, what could not be opened>
Left alone: <anything noticed outside the page>
```
