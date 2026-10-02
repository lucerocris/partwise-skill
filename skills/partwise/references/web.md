# Web

Rules specific to building for the browser. Read with `craft.md`.

## Layout

- Check at 1440 and 390 wide. Nothing scrolls sideways at 390 except things
  meant to (a table, a carousel), and those scroll inside their own box.
- Flex and grid children that hold text need `min-width: 0`, or long content
  pushes the layout wide.
- Images and media reserve their space (`width`/`height` or `aspect-ratio`),
  so nothing jumps as they load.
- Full-height layouts use `dvh`, not `vh`. Fixed bars respect
  `env(safe-area-inset-*)`.
- A table that cannot fit a phone becomes a list of rows or scrolls in its
  own container; it does not shrink its text.

## Interaction

- `:focus-visible` for focus rings. `:active` gives feedback on press.
- Hover is an extra, never the only way to reveal something. Touch devices
  have no hover.
- Inputs: correct `type`, `inputmode` and `autocomplete`; at least 16px text
  so phones do not zoom; never block paste. On a failed submit, focus the
  first field with an error.
- Destructive actions ask for confirmation or offer undo.
- What the user sees should be in the URL when it can be: tab, filter, page,
  open item. Back does what they expect.
- Toasts and live updates are announced (`aria-live="polite"`).
- Scrolling areas inside the page set `overscroll-behavior: contain`.

## Text

- Curly quotes, a real ellipsis character, non-breaking spaces between a
  number and its unit.
- `text-wrap: balance` on headings, `pretty` on short paragraphs.
- `font-variant-numeric: tabular-nums` where numbers align or update.
- Truncate with an ellipsis only when the full text is reachable another way.

## Theme

- If the project has dark mode, every new part works in both. Set
  `color-scheme` so native controls and scrollbars match.
- Style what the browser draws for you where it shows: selection color, caret
  color, focus ring.

## Motion

- CSS transitions before keyframes: they can be interrupted midway.
- Popovers and menus grow from the thing that opened them. Nothing animates
  from scale 0; start near 0.95 with opacity.
- Wrap movement in `@media (prefers-reduced-motion: no-preference)`.

## Checking

Use whatever the project already has for running and viewing the app. With
browser automation available: load the page, wait for it to settle, screenshot
at 1440 and 390, then look. Check the browser console for errors while there.
