# Reference board in Figma

Three calls: build the board with empty slots, ask Figma for upload URLs, post
the crops into the slots.

## 1. Build the board (`use_figma`)

Fill in `DATA` and run.

- `page`: name of the page to work on. It is created if missing. `use_figma`
  starts every call on the file's first page, so every later script must
  switch to this page again too (use the returned `pageId`).
- `placeBesideNodeId`: an existing screen frame to put the board to the right
  of. `null` for a new build; the board then goes in clear space and the
  result says where the screen belongs.
- `w`, `h`: pixel size of each crop, as printed by `refcrop.sh`.
- `took`: for a reference that was considered and rejected, write the whole
  line yourself starting with "Considered, not taken:".

Wide crops (tables, card rows, headers) are stacked full width so they stay
readable; tall and square ones sit three across. The script decides per part.

`figma.createAutoLayout` is a helper provided by `use_figma`, not part of the
standard Plugin API.

```js
const DATA = {
  page: "Orders dashboard",
  title: "References · Orders dashboard (web)",
  direction: "Direction: Refero style X. Inter, 8px radius, neutral canvas, one blue accent. Guessed: status colors, card surface step.",
  placeBesideNodeId: null,
  parts: [
    {
      name: "Sidebar",
      job: "Primary nav, 6 sections, two with children; workspace switcher",
      spec: "Primary: Understory. Borrow: Linear (pinned favorites). Rejected: Dropbox.",
      refs: [
        { product: "Understory", url: "https://refero.design/pages/...", w: 277, h: 603,
          took: "Switcher pinned to bottom edge behind a hairline; sub-items indented, no icons" },
        // two more
      ],
    },
    // more parts
  ],
};

let page = figma.root.children.find((p) => p.name === DATA.page);
if (!page) { page = figma.createPage(); page.name = DATA.page; }
await figma.setCurrentPageAsync(page);

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

const WIDE = 1040;
const board = figma.createAutoLayout("VERTICAL", { name: DATA.title, itemSpacing: 48 });
board.paddingLeft = board.paddingRight = board.paddingTop = board.paddingBottom = 40;
board.fills = solid({ r: 0.97, g: 0.97, b: 0.98 });
board.cornerRadius = 16;
board.appendChild(text(DATA.title, 24, "Semi Bold", ink));
if (DATA.direction) board.appendChild(text(DATA.direction, 13, "Regular", mute, WIDE));

const slots = [];
for (const part of DATA.parts) {
  const row = figma.createAutoLayout("VERTICAL", { name: "Part · " + part.name, itemSpacing: 12 });
  row.fills = [];
  row.appendChild(text(part.name, 18, "Semi Bold", ink));
  row.appendChild(text(part.job, 13, "Regular", mute, WIDE));
  if (part.spec) row.appendChild(text(part.spec, 13, "Regular", ink, WIDE));

  const wide = part.refs.some((r) => r.w / r.h > 2);
  const maxW = wide ? WIDE : 330, maxH = wide ? 520 : 440;
  const cards = figma.createAutoLayout(wide ? "VERTICAL" : "HORIZONTAL", { name: "refs", itemSpacing: 24 });
  cards.fills = [];
  cards.counterAxisAlignItems = "MIN";
  for (const ref of part.refs) {
    const k = Math.min(maxW / ref.w, maxH / ref.h, 1.5);
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
    const cw = wide ? WIDE : Math.max(w, 240);
    const name = text(ref.product, 13, "Semi Bold", ink, cw);
    name.hyperlink = { type: "URL", value: ref.url };
    name.textDecoration = "UNDERLINE";
    card.appendChild(name);
    const line = ref.took.startsWith("Considered") ? ref.took : "Took: " + ref.took;
    card.appendChild(text(line, 12, "Regular", mute, cw));
    cards.appendChild(card);
    slots.push({ part: part.name, product: ref.product, nodeId: img.id });
  }
  row.appendChild(cards);
  board.appendChild(row);
}

const beside = DATA.placeBesideNodeId ? await figma.getNodeByIdAsync(DATA.placeBesideNodeId) : null;
let x = 0, y = 0;
if (beside) { x = beside.x + beside.width + 120; y = beside.y; }
else {
  for (const c of page.children) if (c.id !== board.id) x = Math.max(x, c.x + c.width + 200);
}
board.x = x;
board.y = y;
return {
  boardId: board.id,
  pageId: page.id,
  screenAt: beside ? null : { x: board.x + board.width + 120, y: board.y },
  slots,
};
```

Keep the returned `slots` list: one `{ part, product, nodeId }` per crop, in
order. The next two calls depend on that order. Build the new screen at
`screenAt`.

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

Pair files and URLs in one list so they cannot drift apart. The URLs contain
`?` and `&`, so keep them quoted.

```bash
while read -r file url; do
  printf '%s  ' "$file"
  curl -s -X POST -F "file=@crops/$file;type=image/png" "$url"
  echo
done <<'EOF'
sidebar-understory.png https://mcp.figma.com/mcp/upload/.../submit?scaleMode=FILL&currentPageId=0%3A1
sidebar-linear.png https://mcp.figma.com/mcp/upload/.../submit?scaleMode=FILL&currentPageId=0%3A1
EOF
```

Each line should print `{"success":true,...,"placedOnNodeId":"..."}`. Then
screenshot the board (`get_screenshot` on `boardId`) and confirm every slot
shows a crop, not a gray rectangle.

## Layout rules

- One board per screen. Rebuilding? Delete the old board first; do not stack.
- Screen goes to the right of the board, 120px gap, tops aligned.
- Fewer than three references for a part: show the ones that exist; say how
  many were found in the part's `spec` line.
- The board is working material. Keep it out of any frame that gets exported
  or handed off as the design.
