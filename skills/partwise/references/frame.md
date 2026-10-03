# Frame

The site-level design: who it is for, what it feels like, how pages are
shaped, the rhythm, the color and type systems, the voice. It lives in one
file in the project, the **design file**, and every other job takes its
direction from it. Parts answer "how is this sidebar arranged"; the frame
answers everything above that.

## The four ways in

| Situation | What frame does | Research |
|---|---|---|
| Design file exists, no fresh request | Nothing. Read it; it is the direction. | None |
| Existing project, no design file | **Extract**: write the file from what is already built. | None |
| New project, nothing built | **New**: research directions, user picks one, write the file. | One frame scout |
| User asked for a fresh direction | **Fresh**: same as new, but the old design is set aside on purpose. | One frame scout |

The design file is whichever the project already has (`design.md`,
`DESIGN.md`, `docs/design.md`, a design section in `CLAUDE.md`). None: create
`design.md` at the project root.

**The direction must fit the kind of product.** Before adopting or
researching one, name the product's kind (listing app, tool, marketing page,
content site, store) and check the direction against real products of that
kind. A sibling site's design file is not automatically right: a business
marketing landing and the consumer listing app it serves share colors, type
and voice, not page skeletons or rhythm. An editorial marketing direction
put on a listing app reads as a magazine, not as something to browse.

**Fresh is only ever on request.** Words like "fresh", "new direction", "new
look", "redesign the site", "start the design over" switch it on. Without
them the design file wins, and no other job may change it.

## What the design file holds

One page. Every layer answers a question, and each constrains the next:

```markdown
# Design — <product>

## Reader and job
Who comes, how often, on what device, to do what. Two lines.

## Character
One or two words, and one sentence on why they fit this product.

## Site map and flow
The page types, and how people move between them: where they land, where
the work happens, how they get back. Navigation pattern per page type.

## Page skeletons
For each page type, its shape in one line: "Index: one paragraph, then the
list, no hero." Section order where it matters.

## Rhythm
Density (airy, balanced, dense). How sections are divided (space, rules,
surfaces). How often something loud appears. Reveal and scroll behavior.

## Emphasis
What gets the eye first on a typical page. How much of a screen the accent
may cover. One focal thing per screen, or several.

## Color
Tokens with roles: canvas, surfaces, text levels, borders, accent, status
(success, warning, danger). Light, dark or both, and why.

## Type
Faces and the job each does. Scale. Tracking and line length rules.

## Shape and depth
Radius set. Borders or shadows (one method). Icon set and size.

## Motion
How much moves and why. Durations and easing. Reduced motion.

## Voice
Button verbs, tone, words to use and avoid.

## Constraints
Rules with a reason outside taste: brand marks, meanings of colors,
accessibility commitments, things the product promises. These survive a
fresh direction unless the user strikes them.

## Components and states
Where the system lives in code: token file, component folder, states sheet
route. Written by the `site` job; absent until it runs.

## Exceptions
Craft-floor rules this product deliberately breaks, each with its reason.
```

Write values as tokens wherever the code has them, and point to the token
file rather than repeating it. Mark anything inferred rather than stated as
**(inferred)**.

## Extract

For an existing project with no design file. Cheap: no Refero.

1. Find the page types (an index, a detail page, a form, a settings page...)
   and one real example of each, 3 or 4 pages at most.
2. One batch of screenshots of those pages at 1440 and 390 (simulator for
   iOS), and read the theme or token files and the shared components.
3. Write the design file from what is there. Where pages disagree, write down
   what most of them do and list the outliers at the end as drift; do not fix
   them now.

## New and fresh

1. **Sort the old file, if there is one** (fresh only). Everything in it is
   either *style* (colors, faces, radius, rhythm, skeletons, motion, voice) or
   a *constraint* (has a reason outside taste: a brand mark, green means
   correct, works without an account, never invent numbers). Style is set
   aside; constraints carry over unless the user strikes them.

   **The user can pin any layer.** "Fresh, but keep the colors" (or the type,
   the logo, the dark theme, the page skeletons) moves that layer, exactly as
   it is in the old file and the token files, into the constraints. The fresh
   direction is then researched around it: everything else changes, the
   pinned layer does not, and the token values for it are not touched.
2. **Work on a branch** if the project is a git repo and you are on its main
   branch. A fresh direction touches everything.
3. **Send one frame scout** (a subagent, mid-tier model, as in `screen.md`
   step 4) with this, and nothing from the old style:

   ```text
   Follow <skill folder>/references/frame-scout.md exactly. Read that file first.

   Product: <what it is, one line>
   Reader and job: <who, how often, what device, to do what>
   Page types: <the list>
   Character hints from the user: <any words they used, or "none">
   Constraints: <the carried-over list, or "none">
   Pinned layers: <each pinned layer with its actual values, e.g. "color: canvas #0e0f12, surface #17191e, text #f2f2f3, accent #7cc4a4 (primary actions only)", or "none">
   Mode: <web|ios>
   Scratch folder: <scratch>/frame
   Skill folder (<skill>): <skill folder>
   ```

   It returns three directions, each with a contact sheet of real pages, a
   thesis and a token sketch.
4. **Look at the three sheets** (three images). Drop or flag any direction
   that falls into the craft floor's refuse list or breaks a constraint.
5. **Ask the user to pick.** This is the one stop in partwise, because a
   site-wide direction is pure taste and expensive to undo. One question with
   the directions as options (name, thesis, the look in a line), plus a second
   question listing the carried-over constraints for them to strike any. The
   user may also answer "mix": take the named direction as primary and only
   the named detail from the other.
6. **Write the design file** for the chosen direction. Fresh: if the old file
   is tracked in git, overwrite it; history keeps the old one. If it is not
   tracked, rename it `design.old.md` first.
7. **Save the frame references** in `docs/references/frame/`: the chosen
   direction's pages and a README with the thesis, links and what each page
   gave (layout, rhythm, color, type). Gitignored, as in `screen.md` step 5.
8. **Prove it on one page.** Run job `build` on the page that matters most
   (usually the home or main screen), in the new direction. Then stop and
   report. The rest of the site moves over one page per run, each as `build`,
   or as `polish` "bring this page onto the design file" when only styling
   changes.

## Report

The way in that ran, where the design file is, the direction chosen and its
sources, constraints carried over and any the user struck, what was inferred,
and which page was rebuilt to prove it.
