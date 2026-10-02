# Review and polish

Two jobs on something that already exists. **Review** reports and changes
nothing. **Polish** fixes. Neither runs reference research.

Both start the same way: look at the rendered thing as it is (one batch of
screenshots, as in SKILL.md, Checking), then read the code for what the screenshots
raised. Measure against `craft.md`, the platform page, and the project's own
tokens and components.

## Review

Judge in this order, and stop adding findings in a group once the point is
made:

1. **Can the task be done?** What the screen is for, whether the main action
   is obvious, whether anything blocks or misleads. The few problems here
   outweigh everything below.
2. **States.** Missing loading, empty, error, disabled, focus. What happens
   with long, short, zero and huge content.
3. **Hierarchy.** What the eye lands on first, and whether that is the most
   important thing. Competing accents, everything the same weight, boxes
   doing the work spacing should do.
4. **Consistency.** One-off values that should be tokens, a second radius or
   shadow style, a component rebuilt where the project already has one.
5. **Craft floor.** Contrast, line length, targets, focus, the refuse list.
6. **Platform.** Web or iOS specifics from the platform page.

Report, in chat:

```text
Screen: <name>   Looked at: <rendered at 1440 + 390 | simulator | source only>

Must fix (blocks the task or excludes people)
- <what> — <where: file:line or which part> — <what to do>

Should fix
- ...

Could be better
- ...

Working well
- <one or two things to keep; say why>
```

Each finding names a place and a change. "Spacing feels off" is not a
finding; "the table sits 8px under the header but 32px above the footer;
make both 24px" is. Do not pad: three real findings beat fifteen thin ones.

If a part is structurally wrong (the wrong kind of component for the job, or
an arrangement no fix will rescue), say so and suggest rebuilding it as job
`part`.

## Polish

Review first, without writing the report. Then fix, in this order, so the
effort goes where it matters and the cleanup does not undo itself:

1. Anything that blocks the task.
2. Missing states the existing code can reach (focus, hover, disabled, an
   empty list). States that need logic the screen does not have (loading,
   failed load) go in the report, not in the code.
3. Drift from the project's system: replace one-off values with tokens and
   rebuilt pieces with existing components.
4. Hierarchy and spacing.
5. Craft floor and platform details.
6. Remove decoration that does no work.

Rules while polishing:

- **Keep the design's identity.** Polish makes it a better version of what it
  is. A new palette, typeface or layout is a redesign, and only happens if
  asked for. Where the screen disagrees with the project's tokens, the tokens
  are the identity: bringing the screen back to them is polish, even when it
  changes how the screen looks.
- **Do not edit the token or theme files.** Report what is missing or failing
  in them.
- **Do not widen the scope.** Fix what is on the screen asked about. Note
  problems seen elsewhere; do not chase them.
- **Stress it** as part of the look after fixing, not as extra rounds: put
  realistic worst-case content through each part, limited to what this
  screen can actually be given (the longest name, a one-letter name, an
  empty list, many rows). Use the project's fixtures or story files if it
  has them; otherwise swap the data temporarily and put it back. Measuring
  in the page (does anything overflow or scroll sideways) counts; a
  screenshot of every case is not needed.
- Check in bounded passes (SKILL.md): one look, one batch of fixes, at most
  one more look.

Report what changed, grouped by the order above, and what was found but left
alone and why.
