# Tells

Checks a design for the marks that make it read as AI-made, reports which are
present, and asks before removing or replacing any. Changes nothing until the
user answers. No reference research.

Source: a short list of the most common tells, from a creator's reel on what
makes a design look AI-generated. It is a list of marks to look for, not a
ban: each one is fine when the design chose it on purpose.

## 1. Look

Look at the rendered thing (SKILL.md, Checking: one batch, 1440 and 390),
then grep the source for what a screenshot can't show (fonts, `box-shadow`,
`backdrop-filter`, `—`, `gradient`, hover rules). Go through the list below.
Count a tell only when it is actually there, with a place (`file:line` or
which part). Skip what the screen cannot have: no skeleton check on a static
page, no pricing check on a screen with no prices.

## 2. The list

| Group | Tells |
|---|---|
| **Color** | Harsh or rainbow gradients; purple-and-black; neon; default pastels; pure `#fff` page background with nothing else behind it |
| **Surface** | Drop shadow on everything; liquid glass / heavy blur; soft radius on everything; radial orbs or blurred blobs; dot grids; colored stripe on the edge or top of cards; hover animation on every element |
| **Layout** | Three feature cards in a row; bento grid; three pricing tiers; a fake terminal window as decoration |
| **Type** | Inter, Geist or Space Grotesk chosen as the default, not by the design file |
| **Icons and marks** | Loose icons beside every item; emoji as icons; sparkle icons; animated arrows; checkmark bullet lists |
| **Copy** | Em dashes; "it's not X, it's Y" phrasing |
| **Missing the real thing** | Testimonials with no real person behind them; no real product demo or screenshot; no skeleton loaders where content loads; no terms or privacy links where the page collects data or sells |

A tell that comes from the project's design file or tokens (the font is in
the design file, the radius is a token) is the project's identity: report it
marked `in design file` and never offer to edit the file. The user can
choose to leave it.

## 3. Report

In chat, only what is present, grouped as above:

```text
Screen: <name>   Looked at: <rendered at 1440 + 390 | source only>

<n> tells found
- <tell> — <where> — suggest: <remove | replace with ...>
- ...

Not present: <one line, the groups that came up clean>
```

Each suggestion is concrete: "replace the three-card row with one row of
text and a single product screenshot", "swap the rainbow gradient for the
accent token", "rewrite 'it's not a tool, it's a team' as what the team
does". For the missing-real-thing group the fix is rarely code: say what
the user has to supply (a real quote with a name, a screenshot, the legal
text) and offer a labelled placeholder only if they want one.

None found: say so in one line and stop.

## 4. Ask

Then ask, with AskUserQuestion, before touching anything. One question per
group that has findings (up to four; fold the rest into the nearest group).
Options per question: **Remove**, **Replace** (with the suggestion named),
**Keep**. Say in the option text what each does to the screen. Group
answers apply to every tell in that group; if the user wants one tell
treated differently, they say so in "Other".

## 5. Apply

Do exactly what was chosen, nothing more:

- Remove and replace edit the screen only. Tokens and the design file stay as
  they are; report what they would need.
- Replacements use the project's own tokens, type and components, not new
  ones.
- Keep means leave it and don't raise it again in this session.
- Check once in the rendered page after the edits (one look), then report
  what changed and what was kept.
