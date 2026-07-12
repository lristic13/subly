# Handoff: Subly — "Ledger" subscription tracker (Flutter / Dart)

## Overview
Subly is a mobile app for tracking recurring subscriptions and what you spend on
them per month / year. This package covers the **Ledger** design direction — a calm,
minimal, cool-neutral aesthetic with a single indigo accent. It contains six screens:
Home, Subscriptions list, Subscription detail, Add / Edit, Insights, and Settings.
Currency is **EUR (€)**.

## About the Design Files
The file in this bundle (`Subly.dc.html`) is a **design reference created in HTML** — a
prototype showing intended look, layout, and copy. It is **not production code to copy
directly**. Your task is to **recreate these designs in a Flutter/Dart app** using idiomatic
Flutter widgets and the project's existing patterns.

- Build screens as `StatelessWidget` / `StatefulWidget` composed from Material or Cupertino
  widgets (your call — the visual language is custom, not stock Material, so most surfaces
  are plain `Container`/`Column`/`Row` with the tokens below).
- Put the color/typography/spacing tokens into a central `ThemeData` + a small `AppColors`
  / `AppText` constants file, and reference those everywhere rather than hard-coding.
- The **iPhone bezel, status bar, and home indicator** in the mock are just prototype
  chrome — ignore them. Real device chrome comes from the OS. Design your screens to the
  **safe-area content region** (wrap bodies in `SafeArea`).

## Fidelity
**High-fidelity.** Colors, typography, spacing, and radii are final — implement
pixel-accurately. The reference canvas renders each phone at a **402 pt logical width**
(standard modern iPhone). All px values below are effectively logical points at that width;
use them directly as Flutter logical pixels.

## Design Tokens

### Colors
| Token | Hex | Use |
|---|---|---|
| `bg` | `#F6F7F9` | screen background (cool off-white) |
| `ink` | `#14161C` | primary text |
| `inkStrong` | `#1B1D24` | headings / near-black |
| `muted` | `#8A8F9C` | secondary text, captions |
| `muted2` | `#9AA0AB` | uppercase section labels |
| `hairline` | `#ECEDF1` | card borders / row dividers |
| `hairline2` | `#F1F2F5` | inner row dividers on white cards |
| `tabDivider` | `#E7E8EE` | tab-bar top border |
| `surface` | `#FFFFFF` | cards |
| `fieldBg` | `#EDEEF2` | search field / filter chips |
| `accent` | `#4B53E8` | indigo — primary accent, active states, primary buttons |
| `accentSoft` | `rgba(75,83,232,0.10)` | accent pill/badge backgrounds |
| `accent300` | `#8A8FF0` | category shade 2 (Tools) |
| `accent200` | `#C3C6F7` | category shade 3 (Storage) |
| `accent100` | `#E4E5FB` | category shade 4 (Other) |
| `barTrack` | `#DDE0F4` / `#E1E3F5` | inactive chart bars |
| `barTrack2` | `#EDEEF2` | empty/future chart bars & progress track |
| `toggleOff` | `#E1E3EA` | switch off track |
| `iconInactive` | `#B9BDC6` | inactive tab icons |
| `chevron` | `#C0C4CC` | disclosure chevrons |
| `danger` | `#C4362F` | destructive text (cancel, sign out) |

**Brand tile colors** (rounded square, white bold monogram) — used as stand-ins for real
service logos. Replace with actual brand logos/icons at implementation time; do not ship
these monograms if real assets are available.
Netflix `#E50914` "N" · ChatGPT `#10A37F` "C" · Spotify `#1DB954` "S" ·
Adobe `#D31A1A` "A" · YouTube `#FF0000` "Y" · Figma `#A259FF` "F" ·
Dropbox `#0061FF` "D" · iCloud+ `#3B82F6` "i".

### Typography
- Family: **Instrument Sans** (Google Fonts). Use the `google_fonts` package
  (`GoogleFonts.instrumentSans(...)`) or bundle the font and register in `pubspec.yaml`.
- All monetary figures use **tabular figures**: `fontFeatures: [FontFeature.tabularFigures()]`.
- Scale (size / weight / letter-spacing):
  - Hero amount: 56 / w700 / -0.035em, line-height 1.0
  - Large screen title ("Subscriptions", "Insights", "Settings"): 30 / w700 / -0.03em
  - Detail price: 44 / w700 / -0.03em
  - Add amount: 52 / w700 / -0.03em (with 34 / w600 muted "€" prefix)
  - Screen title (medium, "Overview", "New subscription"): 22 / w700 / -0.02em
  - Detail name: 23 / w700
  - Section header (row title, "Upcoming"): 17 / w600
  - Wordmark: 17 / w700 / -0.02em
  - Body / row title: 15 / w600 (name), 15 / w400–500 (setting label)
  - Secondary / caption: 12–14 / w400–500, color `muted`
  - Uppercase section label: 12 / w600 / letter-spacing 0.06em, color `muted2`, UPPERCASE
  - Tiny footnote (version): 12 / color `#B0B5BE`

> Letter-spacing note: values shown as em. In Flutter `letterSpacing` is in logical px —
> multiply by font size (e.g. 56px × −0.035 ≈ −1.96 `letterSpacing`).

### Spacing & Radius
- Screen padding: **24 horizontal**; top content begins ~ status-bar height below the
  safe-area top; bottom padding 40 above the home indicator. In Flutter just use
  `SafeArea` + `EdgeInsets.symmetric(horizontal: 24)` with `bottom: 40`.
- Card radius: **20** (settings/detail cards), **16** (list item cards / small cards),
  **22** (Insights hero), **11** (brand monogram tiles), **12** (search/filter fields).
- Pill / badge / chip radius: **999** (fully rounded).
- Row vertical padding in lists: **11**; card inner rows: **14–15**.
- Icon monogram tile: **38×38** (lists), **42×42** (add service row), **52×52** (settings
  avatar), **64–66** (detail header).
- Standard gap between an icon/tile and its text: **13**.
- Toggle switch: track **48×29** r999; knob **24×24** circle, 2.5 inset.

### Shadows
Effectively none on content — the design uses hairline borders (`hairline`) on white cards
instead of shadows. Do not add Material elevation/shadows to cards.

## Screens / Views

Common structure for every screen: `bg` background → optional header → scrollable content →
**bottom tab bar** pinned at bottom. Bottom padding clears the home indicator.

### Bottom Tab Bar (shared)
- Row of 4 icons, `spaceAround`, top border `tabDivider` (1px), top padding 16.
- Icons (stroke 2, rounded caps): **Home** (house), **Subscriptions** (3 horizontal lines),
  **Insights** (ascending bars), **Add** (circle with plus, size 26).
- Active icon = `accent` (`#4B53E8`); inactive = `iconInactive` (`#B9BDC6`).
- Active per screen: Home→Home, Subscriptions→list, Insights→bars. Detail/Add/Settings are
  pushed routes (no persistent tab highlighted; Detail & Add are modal/pushed over the list).

### 1. Home (`2a`)
- **Purpose**: The "what am I spending this month" glance.
- **Layout** (top→bottom): header row (wordmark left = 26×26 `accent` rounded square + "Subly";
  34×34 grey avatar circle right) → "This month" label (`muted`) → hero amount **€143.87**
  (56/w700) → delta row: accent pill "↑ €6.99" (`accentSoft` bg) + "vs. May · 11 active"
  (`muted`) → **segmented category bar** (height 10, r6, 3px gaps; flex 45/30/15/10 in
  accent / accent300 / accent200 / accent100) → legend (3 dot+label items) → "Upcoming"
  section header + "See all" (accent) → list of next charges → tab bar.
- **Upcoming row**: 38×38 brand tile + name (15/w600) over "Renews Jul 12" (12/`muted`) +
  amount (15/w600, tabular) right. Divider `hairline` between rows.
  Items: Netflix €17.99 (Jul 12), ChatGPT Plus €22.00 (Jul 14), Spotify €10.99 (Jul 18),
  Adobe CC €24.99 (Jul 21).

### 2. Subscriptions list (`2b`)
- **Purpose**: Browse/manage all subscriptions.
- **Layout**: title "Subscriptions" (30/w700) → subtitle "11 active · **€143.87** / month"
  (the amount in `ink` w600, rest `muted`) → controls row: search field (flex, `fieldBg`,
  r12, search glyph + "Search" placeholder) + filter chip "Amount ▾" (`fieldBg`, r12, accent
  text) → scrollable list → tab bar (list active).
- **Row**: 38×38 tile + name (15/w600) over "{Category} · Monthly" (12/`muted`) + right column
  amount (15/w600, tabular) over "/mo" (11/`muted`). Divider `hairline`.
- **Data (sorted by amount desc)**: Adobe CC €24.99 (Tools) · ChatGPT Plus €22.00 (Tools) ·
  Netflix €17.99 (Entertainment) · YouTube Premium €12.99 (Entertainment) · Figma €12.00
  (Tools) · Dropbox €11.99 (Storage) · Spotify €10.99 (Entertainment) · iCloud+ €2.99
  (Storage). (Full set is 11 subs totalling €143.87/mo; show all in the real list.)

### 3. Subscription detail (`2c`)
- **Purpose**: One subscription's full record + edit/cancel.
- **Layout**: nav row (back chevron left, "Edit" accent text right) → centered header
  (66×66 brand tile r19, name 23/w700, "Entertainment" category pill in `accentSoft`) →
  centered price **€17.99** (44/w700) + "/ month" (15/`muted`) → **info card** (white, r20,
  `hairline` border) with 4 rows: Next charge → Jul 12, 2026 · Billing cycle → Monthly ·
  Subscribed since → Jan 2023 · Yearly cost → €215.88 (label `muted` left, value w600 right,
  `hairline2` dividers) → "Paid this year" row (label w600 + €125.93 w700 right) → **12-bar
  mini chart** (height 48, gap 8, r4): 6 bars `#E1E3F5`, current month `accent`, remaining
  `barTrack2` → primary button "Edit subscription" (full-width, `accent` bg, white, r14, pad 15)
  → text button "Mark as canceled" (`danger`, centered).

### 4. Add / Edit (`2d`)
- **Purpose**: Create or edit a subscription.
- **Layout**: header row ("New subscription" 22/w700 + close ✕ `muted2` right) → **service
  selector** (white card r16 `hairline`: 42×42 tile + "Service"/"Netflix" + chevron) →
  centered **amount entry**: "Amount" label, then "€" (34/w600 `muted`) + "17.99" (52/w700)
  with a 2px `accent` underline under the number → **fields card** (white r20) with rows:
  Billing cycle → Monthly · First payment → Jul 12, 2026 · Category → Entertainment (accent
  text + 9×9 accent dot) · "Remind me before" → **switch ON** (accent track, knob right) →
  primary button "Add subscription" (full-width accent, r14, pad 16).
- Rows with a choose action show value in `muted` w600 + small chevron. Category row uses
  accent styling because it's "set".

### 5. Insights (`2e`)
- **Purpose**: Spending trends and breakdowns.
- **Layout**: header "Insights" (30/w700) + year chip "2026 ▾" (`accentSoft`, accent) →
  **hero card** (`accent` bg, white text, r22, pad 20): "Projected this year" (white 70%) +
  **€1,726.44** (38/w700) + "Avg €143.87 / month across 11 subscriptions" (white 75%) →
  "Monthly spend" section → **7-bar chart** (height 88, gap 6, r4): 6 bars `#DDE0F4`, current
  month `accent`, month letters below (current in accent w600) → "By category" section →
  **4 progress rows**: label + amount (w600 tabular) above an 8px track (`barTrack2`) with a
  filled bar — Entertainment €67.01 (47%, `accent`) · Tools €58.99 (41%, `accent300`) ·
  Storage €14.98 (10%, `accent200`) · Other €2.89 (2%, `accent100`) → tab bar (Insights active).

### 6. Settings (`2f`)
- **Purpose**: Account, preferences, notifications, data.
- **Layout**: title "Settings" (30/w700) → **profile card** (white r20 `hairline`: 52×52
  gradient avatar `linear-gradient(135deg,#4B53E8,#8A8FF0)`, "Alex Rendl" 17/w700 +
  "alex.rendl@gmail.com" 13/`muted`, chevron) → grouped sections, each = uppercase label +
  white card (r20) of rows:
  - **Preferences**: Currency → EUR (€) · Monthly budget → €220.00 · Appearance → Light.
    Each row has a 28×28 rounded-square leading icon (Currency: `accent` bg "€"; Budget:
    `accent300` bg bars glyph; Appearance: `accent200` bg sun glyph), label, `muted` value,
    chevron.
  - **Notifications**: Renewal reminders (ON) · Price change alerts (ON) · Weekly summary (OFF).
    Right-aligned switches (accent when on, `toggleOff` when off).
  - **Data**: "Export as CSV" (chevron) · "Sign out" (`danger` w600).
  - Footer: "Subly v2.0.1" (12, `#B0B5BE`, centered).

## Interactions & Behavior
- **Navigation**: bottom tab bar switches Home / Subscriptions / Insights (and Add via the
  + tab, which opens the Add sheet). Tapping a list row → Detail (push). Detail "Edit" and
  Add "Service/Billing/Date/Category" rows → pickers (native modal pickers are fine).
- **Add flow**: amount field focuses a numeric keypad; billing cycle / date / category open
  selection sheets; the reminder switch toggles a "days before" reminder. "Add subscription"
  validates a non-empty service + amount > 0, then saves and pops.
- **Detail**: "Mark as canceled" should confirm (dialog) then move the sub to a canceled
  state (excluded from monthly totals).
- **Switches / toggles**: standard on/off, accent = on. Animate the knob 150–200ms ease.
- **Transitions**: standard platform push/pop; sheets slide up. Nothing custom/elaborate.
- No loading/skeleton or error states were designed — add per your data layer's needs
  (a simple centered spinner on `bg` is fine).

## State Management
Use whatever the project already uses (Provider / Riverpod / Bloc). Minimum state:
- `List<Subscription>` — each: `name`, `monogram`, `brandColor`, `amount` (Decimal/double),
  `currency` (EUR), `billingCycle` (enum monthly/yearly), `nextChargeDate`, `startedDate`,
  `category` (enum: Entertainment / Tools / Storage / Other), `reminderDaysBefore`, `active`.
- Derived: `monthlyTotal`, `yearlyProjection`, per-category totals & percentages,
  month-over-month delta, upcoming (sorted by nextChargeDate), active count.
- Settings: `monthlyBudget`, `currency`, `appearance`, notification toggles.
- Use **money as integer minor units or `Decimal`** — never float arithmetic for currency.
  Format with `intl` `NumberFormat.currency(locale: 'de_DE'/'en_IE', symbol: '€')` (choose the
  locale matching your grouping/decimal convention; mock uses "€1,726.44").

## Assets
- **Font**: Instrument Sans (Google Fonts).
- **Icons**: simple stroked line icons (home, list, bars, plus, search, chevron, sun, close,
  back). Use your icon set (e.g. `lucide_icons`, `feather`, or Cupertino/Material) — match
  the thin 2px rounded-cap style.
- **Brand logos**: the colored monogram tiles are placeholders. Substitute real service
  logos/icons where you have rights to them; otherwise keep monogram tiles with brand colors.
- No bitmap image assets are required by the design.

## Files
- `Subly.dc.html` — the full HTML reference. Open it in a browser to inspect all six Ledger
  screens (badges **2a–2f**). It also contains three earlier dashboard explorations
  (badges 1a/1b/1c) further down — **ignore those**; 1a is the chosen direction and is what
  2a–2f build on.
