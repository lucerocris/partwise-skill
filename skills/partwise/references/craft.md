# Craft floor

What any finished UI clears, whatever it looks like. These are checks, not a
style: two designs that share nothing visually both pass. When the brief, the
project's existing design or a chosen reference says otherwise, that wins;
note the exception and move on.

## Type

- Text meant for reading: 16px or larger on web, lines of 65-75 characters,
  80 at most. Product UI (tables, lists, labels) may run 13-14px for
  secondary text; inputs stay at 16px.
- One typeface, two at most. Hierarchy from size and weight steps you can see
  at a glance, not from many near-identical sizes.
- Headings: balanced line breaks (`text-wrap: balance`), tighter tracking as
  size grows, never tighter than -0.04em.
- Numbers that line up in columns or change in place use tabular figures.
- No all-caps above 13px. No single word in a headline set in a different
  face or color as decoration.

## Color

- Contrast: 4.5:1 for body text, 3:1 for large text and for the edges of
  controls. Measure against the surface the text actually sits on.
- Neutrals carry most of the screen. One accent, used for the same meaning
  everywhere. Status colors (success, warning, danger) are separate from it.
- No pure black text or pure gray neutrals: tint them slightly toward the
  surface or brand hue.
- Colors live in tokens. No raw values inside components.
- Light or dark is chosen for where the product is used, not by habit.

## Space and layout

- Related things sit close, unrelated things sit apart. More space above a
  heading than below it.
- One spacing scale, one radius set, one way of showing elevation (borders or
  shadows, not both on the same thing).
- Group with space and alignment first. A card is for something that is a
  unit in its own right or can be acted on, not for every section.
- Align to a small number of edges. Ragged starts look unfinished.

## States

Every part is built in every state it can be in, not only the default:

- interactive: hover, pressed, focus, disabled
- data: loading, empty, error, partial, a lot
- content: the longest realistic name, a one-letter name, a zero, a huge
  number, missing image

Empty states say what belongs here and offer the action that fills it.

## Motion

- Every animation has a reason: showing where something came from, confirming
  an action, drawing attention once. No reason, no animation.
- 100-300ms for interface changes, ease-out. Nothing eases in.
- Never animate layout properties (width, height, top, margin, padding);
  move and scale with transform. Color, background and opacity are fine.
  Never `transition: all`.
- Things the user does constantly, or triggers from the keyboard, do not
  animate.
- Respect reduced motion.

## Access

- A visible focus ring on everything focusable. Never remove an outline
  without replacing it.
- Targets at least 44 by 44 on touch screens and phone widths. With a
  pointer, 24 by 24 at least, with space between neighbors, so dense tables
  stay dense.
- Real elements: a button is a button, a link is a link, an input has a
  label.
- Everything reachable and usable by keyboard on web.
- Meaning is never carried by color alone.

## Words

- Buttons name the action: "Save changes", not "Submit". The same thing has
  the same name through the whole flow.
- Errors say what went wrong and what to do. No apologies, no blame.
- Real content shaped like real data. Never lorem ipsum, never an invented
  statistic or testimonial; mark what is missing as a placeholder.

## Refuse

Tells of an interface generated on autopilot. Leave them out unless the brief
or a chosen reference specifically calls for one:

- indigo or violet as the default accent; cream with terracotta; near-black
  with one neon accent
- gradient text; glass or blur as decoration
- cards inside cards; a grid of identical cards with the same soft shadow
- a colored bar down the left edge of a card
- a small all-caps label above every heading
- numbered markers (01, 02, 03) on things that are not a sequence
- a hero made of a giant number and a caption
- emoji used as icons
- a fade-up on every section
- a modal where an inline control would do

## Last look

Before calling it done, take out decoration that does no work. For a new
screen or part, also spend boldness in one place: one thing a user would
remember, and everything else quiet.

When the project's own tokens fail a check here (a border too faint, a text
color too light), keep the token and report it; do not patch around it. When
the project has no token for something you need, derive it from the ones it
has and say so.
