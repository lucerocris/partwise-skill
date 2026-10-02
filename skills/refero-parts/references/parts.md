# Part catalog

Parts that search well in Refero, with query wording that returns the part
rather than the page around it. Use these as starting points and add the
screen's real content and state to the query.

Query formula: **part + its distinguishing anatomy + arrangement or state**.
Leave the user's subject matter out (orders, habits, invoices): search matches
on those nouns and returns whole screens about the subject instead of the
part. The same goes for loose words like "plus" or "streak" on iOS, which
match unrelated screens.

## Web

| Part | Queries that work |
|---|---|
| Sidebar | collapsible sidebar with nested sections and workspace switcher · icon rail sidebar with tooltip labels · sidebar with pinned favorites and search |
| Top bar | app top bar with breadcrumb, search and avatar menu · command palette search overlay |
| Stat card | metric card with trend delta and sparkline · KPI tiles row with comparison period |
| Chart panel | line chart panel with date range picker and legend · bar chart with segmented time toggle |
| Data table | data table with filters, sortable columns and row actions · table with bulk selection toolbar · empty table with call to action |
| Filter bar | filter bar with chips and saved views · faceted filter sidebar with checkboxes |
| Form section | settings form section with inline save and helper text · multi-column form with validation errors |
| Modal | confirmation modal for destructive action · modal form with stepper |
| Side panel | detail side panel with tabs and activity log · slide-over drawer edit form |
| Empty state | empty state with illustration and primary action · first-run checklist |
| Pricing card | pricing cards with monthly annual toggle and highlighted plan · feature comparison table |
| Hero | hero with product screenshot and two calls to action · hero with email capture |
| Feature row | alternating feature rows with screenshot · bento feature grid |
| Testimonial | testimonial cards with logo and metric · single large quote with portrait |
| Footer | multi-column footer with newsletter signup |
| List row | list item with avatar, status badge and overflow menu · activity feed with timestamps |
| Kanban column | kanban board column with cards and add button |
| Toast / banner | inline alert banner with action · toast notification stack |
| Auth card | sign in card with social login buttons · two-factor code entry |
| Notification panel | notifications dropdown with unread grouping |

## iOS

| Part | Queries that work |
|---|---|
| Tab bar | floating pill tab bar with icon and label · bottom tab bar with raised center button (filter hits by the `Tabbar` tag; these queries also match any screen with a floating button) |
| Navigation bar | large title navigation bar with search · navigation bar with segmented control |
| List row | settings list rows grouped with icons · list row with thumbnail, subtitle and chevron · swipe actions on list row |
| Card | summary card with ring progress · content card with image and bookmark · horizontal card carousel |
| Stat block | metric tiles grid with trend · weekly bar chart with selected day |
| Bottom sheet | bottom sheet with drag handle and action list · half sheet filter options |
| Form | sign up form with inline validation · stepper and toggle form rows |
| Onboarding step | onboarding step with progress dots and single choice list · permission priming screen |
| Paywall | subscription paywall with plan cards and trial toggle |
| Empty state | empty state with illustration and add button |
| Search | search screen with recent searches and suggestions · search results with filter chips |
| Profile header | profile header with avatar, stats and edit button |
| Message / feed item | chat bubbles with reactions · feed post with actions row |
| Player / hero media | now playing bar mini player · full screen media controls |
| Picker | date picker in sheet · segmented picker with wheel |
| Action bar | sticky bottom call to action with price · floating action button with menu |

## Do not search for

Button, text input, checkbox, toggle, avatar, badge, icon, divider, tooltip.
Every screen has them, so results are noise. Define them in the direction lock.

One exception: an atom in an unusual **state or arrangement** is a part.
"Button group with split dropdown" or "OTP code input with paste" search well,
because the query describes something only some screens have.

## When a search disappoints

- **Wrong part matched:** the query leaned on a page word or a subject noun.
  Remove "dashboard", "settings", "page" and the user's content words, and
  describe how the part is arranged instead.
- **Right subject, wrong side:** consumer screens instead of admin ones (order
  history instead of an orders table). Add "admin" or "back-office".
- **All one product:** take the best one, then page 2, or
  `refero_get_similar_screens` on it.
- **Nothing close:** widen the part by one level (search "detail side panel"
  instead of "activity log in side panel") and crop tighter.
- **Too many (thousands):** the query is an atom or a vibe word. Add anatomy.
