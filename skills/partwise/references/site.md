# Site

The top layer. Before any page is touched: what the whole product is, every
page it has and how people move between them, the art direction, and the
design system that every page will be built from: tokens, components and
their states. Then a plan that hands the pages to `overhaul` one at a time.

```
site       the product: map, flows, direction, system, plan     (once)
  overhaul one page: brief, parts sorted, build                  (per page)
    part   one component: references, build                      (per part)
```

Run it autonomously. It stops for the user once, when the direction is
chosen, and shows the plan at the end. It builds the system and one proof
page; the rest of the pages follow by `site next` or `overhaul`.

## 1. Product brief

The site-level version of `overhaul.md` stage 1:

```text
Product:  <what it is> — kind: <listing app, tool, marketing site, store...>,
          like <3-4 real products of that kind>
Readers:  <each kind of person, how often, on what device>
Jobs:     <the 3-5 things people come to do, most important first>
Keep:     <brand marks, colors, fonts, voice, flows that must survive>
Scope:    <which sites or apps are in: e.g. the consumer app only, or the
          app and its business landing as two products sharing a brand>
```

Two surfaces of different kinds (a marketing landing and the app it sells)
are two products. They share brand layers (color, logo, type, voice) and get
separate page skeletons and rhythm; write that down here.

## 2. Map

**Existing app:** from the code (routes, layouts, navigation) and a quick look
at the running app.

**New app, nothing built:** from the brief. Plan the pages each job needs,
using how real products of this kind are organized (the flow references
below are the main evidence here, so search 2-3 journeys, not 1-2), and keep
the first version small: the fewest pages that let a person do each job end
to end. List what was left out for later.

If `docs/ux/` has research on these journeys, start from its recommended
flows rather than redoing the work.

Either way, write down:

- **Pages:** every route, grouped into page types (index, list, detail,
  form, settings, auth, marketing, empty or error). One line each.
- **Flows:** the 3-5 journeys behind the jobs, as steps across pages: entry
  → task → done → where next. Note dead ends, missing back paths, steps that
  ask for the same thing twice.
- **Flow references:** for the one or two most important journeys, one
  `refero_search_flows` query each (`response_format: "md"`), through a
  scout if it gets long. Take step order, decisions and what each step
  confirms; not looks.

Write the map into the design file's "Site map and flow" section.

## 3. Direction

Run `frame` (`frame.md`), with the brief and the map as its input: extract
for an existing site the user is happy with, new for a new one, fresh when
asked. This is the one stop: the user picks a direction, and is asked about
keeping their fonts if the request did not say.

## 4. Design system

Turn the design file into code the pages will share. In a new app, set up the
project first in the stack the user named, or the most ordinary one for the
platform (Next.js with Tailwind on web, SwiftUI on iOS) if they named none,
and say which. In the project's own
stack and conventions; extend what exists rather than starting a parallel set.

- **Tokens:** color roles, type scale, spacing, radius, elevation, motion, as
  the project's token or theme file. Every value the design file names.
- **Components:** the pieces every page type in the map needs, usually:
  button (primary, secondary, quiet, destructive), link, text input, select,
  checkbox or toggle, search field, chip or tag, list row, card if the
  direction uses them, navigation (top bar, side nav, tab bar as the product
  has), page header, section header, dialog or sheet, toast, empty state,
  skeleton loader, error message.
- **States for each:** default, hover, focus, pressed, disabled, loading,
  error, selected or active, empty, as they apply. The craft floor's States
  section is the checklist.
- **A states sheet:** one page in the app (a dev-only route such as
  `/design`, or the project's Storybook if it has one) that shows every
  component in every state, at both widths. It is the system's proof and the
  first thing to screenshot.

Component structure that has no answer in the design file (how this
product's list row should be arranged, for example) is a `part`: research it
with a scout as `screen.md` step 4 says, then build it into the system.

Add a "Components and states" section to the design file pointing to the
token file, the component folder and the states sheet.

## 5. Plan

Order the pages for `overhaul`:

1. the page that matters most to the most important job (proof page);
2. the rest of that job's flow, in flow order;
3. other jobs' flows by importance;
4. auth, settings, error and empty pages, usually restyle-only.

For each page, one line: page, job it serves, expected piles (mostly
restyle, or parts to rethink). Write it to `docs/design-plan.md` with a
checkbox per page.

## 6. Prove it

Run `overhaul` on the first page in the plan, using the new system's
components. Tick it in the plan. Then report and stop.

## Continuing

`site next` (or "continue the site plan"): read `docs/design-plan.md`, run
`overhaul` on the first unticked page, tick it, report. Each run is one page,
in a fresh session if the last one was long.

If an overhaul needs a component the system does not have, add it to the
system and the states sheet first, then use it; never build a one-off copy
inside a page.

## Report

```text
Brief:     <shortened>
Map:       <N pages in M types; flows named; problems found in flows>
Direction: <chosen, and what was pinned>
System:    <token file; components built; states sheet route>
Plan:      <docs/design-plan.md, N pages; proof page done>
Next:      <the next page in the plan>
```
