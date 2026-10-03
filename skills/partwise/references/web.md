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

## Checking

Use whatever the project already has for running and viewing the app. Plain
static files: `python3 -m http.server` in the folder. With browser automation
available: load the page, wait for it to settle, screenshot at 1440 and 390,
then look. Browser tools often only write inside their own folder; save
there. Check the console for errors while there, ignoring a missing favicon
and dev-server noise.

A dev server running in a git worktree or other copied folder can keep
serving old CSS after edits (the file watcher misses them). If a style change
does not show, restart the server and clear its cache (`.next/` for Next.js)
before assuming the code is wrong. Measure in the page (computed font,
element positions) to confirm the change is live.

Screenshot traps that look like design defects:

- Load the page fresh at each width. Resizing after load leaves maps and
  canvases drawn for the old size (a half-blank map).
- Scroll through the page before a full-page screenshot so lazy content
  loads, and remember pinned bars appear mid-image in a full-page capture.
- Subtle effects (a fade, a focus ring, a hover) rarely show in a
  screenshot; confirm them with computed styles instead of by eye.
- A full-page capture can show a pinned bar that is hidden at load (it
  shows only after scrolling), and a phone capture can crop the scrollbar's
  width so content looks flush with the right edge. Check both in the
  running page, and tell anyone judging the screenshots about them.
