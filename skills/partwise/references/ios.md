# iOS

Rules specific to native and native-feeling mobile apps: SwiftUI, UIKit,
Flutter, React Native. Read with `craft.md`.

The failure to avoid is an app that looks **ported from a website**: a
hand-built top bar, web-shaped buttons, hover-style affordances, a hamburger
menu, a footer.

## Structure

- Tab bar for 2 to 5 top-level sections. A navigation stack for going deeper.
  A sheet for a task that starts and finishes on its own. Not a hamburger
  menu.
- Keep the system back gesture working: swipe from the left edge goes back.
- Large title at the top of a section's root screen, collapsing on scroll.
- Lists of settings and details are grouped inset lists, not cards on a
  canvas.
- Primary action where the thumb is: bottom of the screen or the bar, not the
  top corner, when it is the main thing to do.

## Controls

Use the platform's own before drawing a custom one: switch, segmented control,
picker, stepper, menu, context menu, swipe actions on rows, pull to refresh,
search in the navigation bar. A custom control must do something the system
one cannot.

## Type and color

- System text styles (Large Title, Title, Headline, Body, Footnote, Caption)
  so text scales with the user's Dynamic Type setting. Never fixed sizes for
  reading text. Body is 17pt; nothing below 11pt.
- System typeface for interface text unless the brand has its own.
- Semantic colors (label, secondary label, system background, separator) so
  dark mode and contrast settings work without extra effort. One tint color
  for interactive things.
- Dark mode is a first-class version, not an inversion. Check it.
- System materials for bars and overlays; no hand-rolled blur.

## Touch and space

- Targets 44 by 44 points at least, including icon-only buttons.
- 16-20pt side margins. Respect safe areas top and bottom; content scrolls
  under bars, controls do not sit under them.
- Nothing important under the home indicator, or behind a floating button or
  tab bar at the end of a scroll: pad the bottom of scrolling content by the
  height of whatever floats over it.
- No hover states. Pressed states do not shift layout.

## Icons and motion

- SF Symbols in SwiftUI and UIKit, at a weight matching the text beside
  them; the platform icon set in Flutter and React Native. One set per app.
- System transitions for push, sheet and tab changes. Custom motion only
  where it explains something, and it honors Reduce Motion.

## Checking

On the simulator or a device, never in a browser. Say which. Look at:

- a small phone and a large one;
- dark mode (`xcrun simctl ui booted appearance dark`);
- the largest standard Dynamic Type size: nothing clipped or overlapping;
- the keyboard open on any screen with a field: the field and its action
  stay visible.

Screenshot with `xcrun simctl io booted screenshot <file>`.
