# Building the screen in code

For target `code`. The part reports and crop sheets are the design; there is
no Figma screen in between.

## Before writing anything

- **Find what the project already has**: framework, styling approach, theme or
  token file, existing components, icon library. That is the direction lock.
  A part spec says how a sidebar is arranged; the project says what a button,
  a color and a radius are. Reuse existing components before writing new ones.
- **New project, nothing existing:** write the direction lock from step 2 as
  the token file first (CSS variables, Tailwind theme, Flutter `ThemeData`,
  SwiftUI constants), then build against it. No raw color or spacing values
  inside components.
- **Icons:** the project's icon library; if none, add one open set (Lucide for
  web, SF Symbols for SwiftUI, the platform set for Flutter). Do not
  hand-write SVG paths.

## Build

- **One component per part, named after the part** on the board (`Sidebar`,
  `StatCard`, `OrdersTable`), so a board row maps to a file.
- **Follow the part spec for structure**: what is in it, order, position,
  stacking, shape. Keep the crop sheet for that part open while writing it.
- **Build the states the part listed** (empty, loading, selected, active), not
  only the default. In code they are cheap, and they are where the references
  earn their place.
- **Real content from the brief**, shaped like real data. Never a reference's
  copy, logo or product name.
- **Assemble last**, in the page or screen file. Shared spacing and type come
  from the tokens; if two parts disagree, fix both toward the tokens.
- Match the project's conventions for file layout, naming and comments.

## Check it running

Do not judge the result from the source. Run the app the way the project
runs, take a screenshot of the screen, and compare it with each part's crop
sheet:

- each part shows its primary's structure, and every Took line on the board
  is visible;
- no overlap, clipped text, or controls hidden under a fixed bar;
- web: check one narrow width as well as desktop;
- iOS: safe areas, and the last row reachable above the tab bar.

If the app cannot be run here, say so in the report rather than claiming the
screen was checked.
