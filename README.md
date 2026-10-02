# refero-parts

A Claude Code skill for part-by-part design inspiration.

The usual agent workflow with [Refero](https://refero.design) is "find screens
like the page I'm building, then build it". That returns generic pages and
produces a generic design. This skill breaks the screen into parts first
(sidebar, stat card, table, tab bar...), finds three real-product references
for each part, crops each reference down to just that part, pins the crops on a
reference board in Figma, and builds the screen part by part from them.

Works in `web` and `ios` mode.

## Needs

- [Refero MCP](https://refero.design/mcp)
- Figma MCP (remote server, with `use_figma` and `upload_assets`)
- ImageMagick and curl

## Install

```bash
git clone git@github.com:lucerocris/refero-parts-skill.git ~/refero-parts-skill
ln -s ~/refero-parts-skill/skills/refero-parts ~/.claude/skills/refero-parts
```

## Use

```text
/refero-parts orders dashboard for a small ecommerce admin, web, in <figma url>
/refero-parts rebuild this frame part by part: <figma frame url>
/refero-parts habit tracker home screen, ios
```

## What is in here

| File | What |
|---|---|
| `skills/refero-parts/SKILL.md` | The pipeline |
| `skills/refero-parts/references/parts.md` | Catalog of parts and query wording, per mode |
| `skills/refero-parts/references/board.md` | Figma script and upload steps for the reference board |
| `skills/refero-parts/scripts/refcrop.sh` | Crops a part out of a screenshot by percentage box |
