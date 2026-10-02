# Reference board in Figma

Three calls: build the board with empty slots, ask Figma for upload URLs, post
the crops into the slots.

## 1. Build the board (`use_figma`)

Fill in `DATA` and run. `w` and `h` are the pixel size of each crop, as printed
by `refcrop.sh`. Set `placeBesideNodeId` to an existing screen frame to land
the board to its right; leave it `null` to place the board in clear space. To
target a page other than the first, add
`await figma.setCurrentPageAsync(await figma.getNodeByIdAsync(PAGE_ID))` at the
top.

```js
const DATA = {
  title: "References · Orders dashboard (web)",
  direction: "Direction: file design system. Inter, 8px radius, neutral gray canvas, one blue accent.",
  placeBesideNodeId: null,
  parts: [
    {
      name: "Sidebar",
      job: "Primary nav, 6 sections, two with children; workspace switcher",
      spec: "Primary: Understory. Borrow: Linear (pinned favorites), Dropbox (dark surface, not taken).",
      refs: [
        { product: "Understory", url: "https://refero.design/pages/...", w: 277, h: 603,
          took: "Switcher pinned to bottom edge behind a hairline; sub-items indented, no icons" },
        // two more
      ],
    },
    // more parts
  ],
};

const MAX_W = 360, MAX_H = 420;
await figma.loadFontAsync({ family: "Inter", style: "Regular" });
await figma.loadFontAsync({ family: "Inter", style: "Semi Bold" });
const ink = { r: 0.09, g: 0.09, b: 0.1 }, mute = { r: 0.42, g: 0.43, b: 0.46 };
const solid = (c) => [{ type: "SOLID", color: c }];
const text = (s, size, style, color, width) => {
  const t = figma.createText();
  t.fontName = { family: "Inter", style };
  t.fontSize = size;
  t.characters = s;
  t.fills = solid(color);
  if (width) { t.resize(width, t.height); t.textAutoResize = "HEIGHT"; }
  return t;
};

const board = figma.createAutoLayout("VERTICAL", { name: DATA.title, itemSpacing: 40 });
board.paddingLeft = board.paddingRight = board.paddingTop = board.paddingBottom = 40;
board.fills = solid({ r: 0.97, g: 0.97, b: 0.98 });
board.cornerRadius = 16;
board.appendChild(text(DATA.title, 24, "Semi Bold", ink));
if (DATA.direction) board.appendChild(text(DATA.direction, 13, "Regular", mute, 720));

const slots = [];
for (const part of DATA.parts) {
  const row = figma.createAutoLayout("VERTICAL", { name: "Part · " + part.name, itemSpacing: 12 });
  row.fills = [];
  row.appendChild(text(part.name, 18, "Semi Bold", ink));
  row.appendChild(text(part.job, 13, "Regular", mute, 720));
  if (part.spec) row.appendChild(text(part.spec, 13, "Regular", ink, 720));
  const cards = figma.createAutoLayout("HORIZONTAL", { name: "refs", itemSpacing: 24 });
  cards.fills = [];
  cards.counterAxisAlignItems = "MIN";
  for (const ref of part.refs) {
    const k = Math.min(MAX_W / ref.w, MAX_H / ref.h, 1.5);
    const w = Math.round(ref.w * k), h = Math.round(ref.h * k);
    const card = figma.createAutoLayout("VERTICAL", { name: "Ref · " + ref.product, itemSpacing: 8 });
    card.fills = [];
    const img = figma.createRectangle();
    img.name = "crop · " + part.name + " · " + ref.product;
    img.resize(w, h);
    img.cornerRadius = 8;
    img.fills = solid({ r: 0.9, g: 0.9, b: 0.92 });
    img.strokes = solid({ r: 0.85, g: 0.85, b: 0.88 });
    img.strokeWeight = 1;
    card.appendChild(img);
    const cw = Math.max(w, 220);
    const name = text(ref.product, 13, "Semi Bold", ink, cw);
    name.hyperlink = { type: "URL", value: ref.url };
    name.textDecoration = "UNDERLINE";
    card.appendChild(name);
    card.appendChild(text("Took: " + ref.took, 12, "Regular", mute, cw));
    cards.appendChild(card);
    slots.push({ part: part.name, product: ref.product, nodeId: img.id });
  }
  row.appendChild(cards);
  board.appendChild(row);
}

let x = 0, y = 0;
const beside = DATA.placeBesideNodeId ? await figma.getNodeByIdAsync(DATA.placeBesideNodeId) : null;
if (beside) { x = beside.x + beside.width + 120; y = beside.y; }
else {
  for (const c of figma.currentPage.children) {
    if (c.id !== board.id) x = Math.max(x, c.x + c.width + 200);
  }
}
board.x = x;
board.y = y;
return { boardId: board.id, pageId: figma.currentPage.id, slots };
```

The call returns `slots`: one `{ part, product, nodeId }` per crop, in order.
Keep the list; the next two calls depend on that order.

## 2. Ask for upload URLs (`upload_assets`)

```text
fileKey:       <file>
count:         <number of slots>
nodeIds:       <slot nodeIds, same order>
currentPageId: <pageId from step 1>
scaleMode:     FILL
```

It returns one single-use `submitUrl` per slot, in the same order, valid for
ten minutes. Up to 60 per call.

## 3. Post each crop to its URL

```bash
curl -s -X POST -F "file=@crops/sidebar-understory.png;type=image/png" "<submitUrl>"
```

Success looks like `{"success":true,...,"placedOnNodeId":"1:9"}`. Check
`placedOnNodeId` against the slot you meant. Post them all, in parallel if
convenient, then screenshot the board (`get_screenshot` on `boardId`) and
confirm every slot shows a crop, not a gray rectangle.

## Layout rules

- One board per screen. Rebuilding? Delete the old board first; do not stack.
- Board sits to the left of, or beside, the built screen on the same page.
- Fewer than three references for a part: show the ones that exist and add a
  text line in the row saying how many were found.
- The board is working material. Keep it out of any frame that gets exported
  or handed off as the design.
