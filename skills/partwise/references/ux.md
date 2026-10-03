# UX research

Research only: how people get things done in this product, how real products
of its kind handle the same journeys, where the friction is, and what to
change. No visual design and no code. The output is a research document the
other jobs build on: `site` uses it for the map and flows, `overhaul` for a
page's brief.

Be plain about what this is. It is desk research and expert evaluation:
competitor journeys from Refero, the product's own screens, and its own data
if the project has analytics. It is not user research. It never invents what
users said, felt or did; anything that needs real people goes in the last
section as a question to test.

Run autonomously; no stops.

## 1. Question

Turn the request into one research question and a scope:

```text
Question: <what we need to know, e.g. "Why do owners start a claim and not
          finish it?" or "How should a new user get from install to their
          first logged habit?">
Product:  <kind, like 3-4 real products>
People:   <who, in what situation, on what device>
Journeys: <the 1-3 journeys in scope, start to end>
Evidence: <what exists: the app itself, analytics (PostHog, GA), support
          messages, reviews, past research docs>
```

## 2. The product as it is

Skip for a new product. Otherwise walk each journey in the running app, at
phone width first, and write it as numbered steps: what the screen asks,
what the person must know or decide, what confirms success, where they can
go back. Screenshot each step onto one contact sheet per journey
(`scripts/refsheet.sh`).

If the project has analytics, pull the real funnel for each journey (step
counts and drop-off between steps) and quote it with dates. If it has none,
say so; do not estimate.

## 3. How others do it

For each journey, send a flow scout (subagent, mid-tier model) with this:

```text
Read <skill folder>/references/ux.md, section "Flow scout", and follow it.

Journey: <name, start → end, who does it>
Product kind: <kind>, like <real products>
Mode: <web|ios>
Scratch folder: <scratch>/ux-<journey>
Skill folder (<skill>): <skill folder>
```

Each returns 3 real flows of that journey with their steps and a sheet of
key screens.

## 4. Evaluate

For each journey, compare the product's steps with the three references and
judge against these, finding by finding:

- **Steps:** any step that could be removed, merged or deferred; anything
  asked twice; anything asked before it is needed.
- **Decisions:** what the person must decide at each step and whether they
  have what they need to decide it.
- **Orientation:** do they know where they are, how much is left, and how to
  go back.
- **Feedback:** does every action confirm itself; are errors specific and
  recoverable.
- **Exits:** dead ends, missing next steps, places they would leave and not
  return.
- **Trust:** at the moments that ask for something (sign-up, payment,
  permissions, verification), is the reason given.
- **Access and devices:** the journey on a phone, by keyboard, with the
  slowest realistic connection.

A finding names the step, what happens, why it costs the person, what a
reference does instead (which one), and the change. Rank by how much of the
journey it blocks.

## 5. Write it up

Save to `docs/ux/<topic>.md` in the project (create the folder), with the
contact sheets beside it. Gitignore the screenshots of other products, as
`screen.md` step 5 does.

```markdown
# <Topic> · UX research (<date>)

## Question
<question and scope from step 1>

## Journeys today
<numbered steps per journey, link to the sheet, funnel numbers if any>

## How others do it
<per journey: the three reference flows in a few lines each, and the pattern
they share or disagree on>

## Findings
<ranked; each: step · problem · cost to the person · reference · change>

## Recommended flow
<the journey as it should be, as numbered steps, marking what changed>

## To test with real people
<what this research cannot settle, as questions, plus how to check each:
a 5-person task test script, an analytics event to add, or a survey line>
```

## 6. Report

In chat: the question, the top three findings, the recommended flow in one
line per journey, and the document path. Suggest the next job: `site` if the
map should change, `overhaul` for the page with the worst finding.

## Flow scout

You research one journey in Refero and report back. Everything you look at
stays with you; only the report goes back.

1. `refero_search_flows` with the journey written plainly ("claim a business
   listing with verification", "first-run onboarding to first logged habit"),
   `platform` set, `response_format: "md"`. Two queries, different wording.
   Prefer flows from products of the given kind.
2. Pick 3 from different products that solve the journey in visibly
   different ways. `refero_get_flow` on each for its steps.
3. Put the 4-6 key screens of each on one sheet:
   `<skill>/scripts/refsheet.sh <scratch>/flow-<n>.png "1 Step name=<Thumbnail URL>" ...`
   and read it once.
4. Reply with exactly this:

```text
JOURNEY: <name>
FLOW 1: <product> — <N> steps — <refero link> — sheet: <path>
  steps: <step 1>; <step 2>; ...
  notable: <one or two things this flow does that the others do not>
FLOW 2: ...
FLOW 3: ...
PATTERN: <what all three do the same way, one line>
SPLIT: <where they disagree, one line>
```
