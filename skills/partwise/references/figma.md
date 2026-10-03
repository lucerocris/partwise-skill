# Building the screen in Figma

What step 8 needs beyond the part specs. If the `figma-use` skill is loaded,
it covers the first section in more depth; the rest is specific to this skill.

## `use_figma` behaviors that break a build without an error

- **Every call starts on the first page.** Begin each script with
  `await figma.setCurrentPageAsync(await figma.getNodeByIdAsync(PAGE_ID))`.
- **Nothing persists between calls.** Return the ids of what you created and
  pass them into the next script as string literals.
- **`return` is the only output.** `console.log` is not shown. Do not wrap the
  script in an async function; top-level `await` works.
- **Colors are 0-1**, not 0-255, and a paint's color has no alpha: opacity
  goes on the paint (`{ type: "SOLID", color, opacity: 0.5 }`).
- **Load a font before touching text**: `await figma.loadFontAsync(...)`. The
  Inter style is `"Semi Bold"`, with a space.
- **`resize()` on an auto-layout frame sets both axes to FIXED.** A frame
  meant to hug its content collapses to the size you passed and clips
  everything. Call `resize()` first, then set the hug axis back
  (`primaryAxisSizingMode = "AUTO"` or `layoutSizingVertical = "HUG"`).
- **`FILL` and `HUG` sizing only work after `appendChild`** into an
  auto-layout parent. Set them after appending.
- **Frames clip their content by default.** Set `clipsContent = false` on a
  container whose child must overflow (a floating button, a shadow).
- **Wrapping text needs a fixed width**: `resize(width, height)` then
  `textAutoResize = "HEIGHT"`.
- Use `figma.createAutoLayout("VERTICAL" | "HORIZONTAL", { name, itemSpacing })`
  for any container whose children relate to each other. Absolute x/y is for
  placing top-level frames on the canvas and for overlays inside a screen.

## Fonts

- **Web:** the direction's typeface if `figma.listAvailableFontsAsync()`
  has it, otherwise Inter.
- **iOS:** SF Pro can be listed and load without error and still render
  nothing. After creating the first text node, check it:

  ```js
  const ok = t.width > 0 && !t.hasMissingFont;
  ```

  If that is false, use Inter for the whole screen and note the substitution
  on the board's direction line.

## Screen skeleton

**Web**, 1440 wide, height hugging content with a 900 minimum:

```js
const screen = figma.createAutoLayout("HORIZONTAL", { name: "Orders dashboard", itemSpacing: 0 });
screen.resize(1440, 900);
screen.counterAxisSizingMode = "AUTO";   // height hugs
screen.minHeight = 900;
screen.x = SCREEN_AT.x; screen.y = SCREEN_AT.y;
```

**iOS**, 390 × 844, plain frame with three layers: scrolling content, then
floating chrome on top.

```js
const screen = figma.createFrame();
screen.name = "Today";
screen.resize(390, 844);
screen.clipsContent = true;
screen.x = SCREEN_AT.x; screen.y = SCREEN_AT.y;

// content: auto-layout column, top padding 59 for the status bar,
// bottom padding = height of anything floating over it + 34 home indicator
const content = figma.createAutoLayout("VERTICAL", { name: "Content", itemSpacing: 24 });
screen.appendChild(content);
content.resize(390, 10);
content.primaryAxisSizingMode = "AUTO";
content.paddingTop = 59; content.paddingLeft = content.paddingRight = 20;
content.paddingBottom = 34 + 96;

// floating chrome (tab bar, add button): absolute children of `screen`,
// appended after `content` so they sit above it
```

Leave the bottom padding large enough that the last row's controls are not
under the tab bar or a floating button when scrolled to the end, and place a
floating button so it does not sit on a row control in the first viewport.

## Icons

Use one open icon set at one size and stroke: Lucide (24px, 1.5-2px stroke) on
web, an SF Symbols-like outline set on iOS. Insert each with
`figma.createNodeFromSvg(svgString)`; the SVG needs `width`, `height` and
`viewBox`, and `currentColor` imports as black, so write the color in.

Do not draw icons from rectangles and lines, and do not spend effort on icon
fidelity: a correct simple glyph from the set is enough. If the file has an
icon library, use that instead.

## Checking the result

`get_screenshot` caps size but does not upscale, so a 390pt iOS frame comes
back at 390px. To read small text, scale it up locally:

```bash
magick shot.png -filter Lanczos -resize 200% shot-2x.png
```
