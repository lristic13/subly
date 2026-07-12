# Subly — Flutter Implementation Plan

## Overview

Subly is a subscription tracking mobile app that helps users manage and monitor their recurring expenses. The app features a friendly mascot character ("Subly") that provides personality and insights throughout the experience.

**Target platforms:** iOS & Android
**Storage:** Local-only (v1), designed for easy cloud sync addition later
**Currencies:** EUR and USD (v1)
**Brand:** Indigo Night palette, Plus Jakarta Sans, coin-shaped mascot character

---

## Tech Stack & Dependencies

### Core
- **Flutter** (latest stable)
- **Dart** (latest stable)

### State Management & Navigation
- **flutter_riverpod** + **riverpod_annotation** (code generation style)
- **go_router** for navigation

### Database & Models
- **drift** + **sqlite3_flutter_libs** (local SQL database)
- **freezed** + **freezed_annotation** (immutable models with union types)
- **json_annotation** + **json_serializable** (JSON serialization for catalog)

### UI & Charts
- **fl_chart** (pie charts, line charts, bar charts)
- **cached_network_image** (logo caching from Logo.dev)
- **flutter_svg** (SVG support if needed)
- **rive** (character animations — placeholder integration in v1)
- **google_fonts** (typography)

### Notifications
- **flutter_local_notifications** (renewal reminders)
- **timezone** (scheduling notifications in correct timezone)

### Utilities
- **intl** (date formatting, currency formatting)
- **uuid** (unique IDs for subscriptions)
- **path_provider** (local file paths)
- **shared_preferences** (simple key-value settings like selected currency)
- **url_launcher** (opening external links)

### Dev Dependencies
- **build_runner** (code generation for Freezed, Drift, Riverpod)
- **drift_dev** (Drift code generation)
- **riverpod_generator**
- **custom_lint_rules** / **flutter_lints**
- **mocktail** (testing)

---

## Project Structure (Feature-First)

```
lib/
├── main.dart
├── app/
│   ├── app.dart                        # MaterialApp.router setup
│   ├── router.dart                     # GoRouter configuration
│   └── theme/
│       ├── app_theme.dart              # Light & dark theme definitions
│       ├── app_colors.dart             # Color constants
│       └── app_typography.dart         # Text styles
│
├── core/
│   ├── database/
│   │   ├── app_database.dart           # Drift database class
│   │   ├── app_database.g.dart         # Generated
│   │   ├── tables/
│   │   │   └── subscriptions_table.dart
│   │   └── daos/
│   │       └── subscriptions_dao.dart  # Data access object with queries
│   │
│   ├── notifications/
│   │   └── notification_service.dart   # Local notification scheduling
│   │
│   ├── constants/
│   │   ├── app_constants.dart          # App-wide constants
│   │   └── category_constants.dart     # Category definitions with icons/colors
│   │
│   ├── extensions/
│   │   ├── date_extensions.dart        # DateTime helpers
│   │   ├── currency_extensions.dart    # Formatting helpers
│   │   └── context_extensions.dart     # BuildContext helpers
│   │
│   └── utils/
│       ├── currency_utils.dart         # EUR/USD conversion, formatting
│       └── billing_cycle_utils.dart    # Cycle calculations (next billing date, monthly cost normalization)
│
├── features/
│   ├── dashboard/
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   └── dashboard_screen.dart
│   │   │   └── widgets/
│   │   │       ├── total_spend_card.dart
│   │   │       ├── category_breakdown_chart.dart
│   │   │       ├── upcoming_renewals_card.dart
│   │   │       └── subly_insight_card.dart       # Character insight/tip
│   │   └── providers/
│   │       └── dashboard_providers.dart           # Aggregated stats providers
│   │
│   ├── subscriptions/
│   │   ├── domain/
│   │   │   └── models/
│   │   │       ├── subscription.dart              # Freezed model
│   │   │       ├── subscription.freezed.dart      # Generated
│   │   │       ├── billing_cycle.dart             # Enum: weekly, monthly, yearly
│   │   │       └── subscription_category.dart     # Enum with metadata
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── subscription_repository.dart   # Abstraction over Drift DAO
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   ├── subscriptions_list_screen.dart
│   │   │   │   ├── subscription_detail_screen.dart
│   │   │   │   └── add_edit_subscription_screen.dart
│   │   │   └── widgets/
│   │   │       ├── subscription_list_tile.dart
│   │   │       ├── subscription_form.dart
│   │   │       ├── billing_cycle_picker.dart
│   │   │       ├── category_picker.dart
│   │   │       └── currency_picker.dart
│   │   └── providers/
│   │       └── subscriptions_providers.dart
│   │
│   ├── catalog/
│   │   ├── data/
│   │   │   ├── catalog_data.dart                  # Loads & parses the JSON catalog
│   │   │   └── catalog.json                       # 100+ popular services
│   │   ├── domain/
│   │   │   └── models/
│   │   │       ├── catalog_item.dart              # Freezed model
│   │   │       └── catalog_item.freezed.dart
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   └── catalog_search_screen.dart     # Search/browse catalog when adding
│   │   │   └── widgets/
│   │   │       ├── catalog_list_tile.dart
│   │   │       └── catalog_search_bar.dart
│   │   └── providers/
│   │       └── catalog_providers.dart
│   │
│   ├── stats/
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   └── stats_screen.dart
│   │   │   └── widgets/
│   │   │       ├── monthly_trend_chart.dart        # Line chart
│   │   │       ├── category_pie_chart.dart         # Donut/pie chart
│   │   │       ├── cost_per_day_card.dart
│   │   │       ├── most_expensive_card.dart
│   │   │       └── average_cost_card.dart
│   │   └── providers/
│   │       └── stats_providers.dart
│   │
│   ├── onboarding/
│   │   └── presentation/
│   │       ├── screens/
│   │       │   └── onboarding_screen.dart          # Welcome flow with Subly character
│   │       └── widgets/
│   │           └── onboarding_page.dart
│   │
│   └── settings/
│       ├── presentation/
│       │   ├── screens/
│       │   │   └── settings_screen.dart
│       │   └── widgets/
│       │       ├── currency_setting_tile.dart
│       │       ├── theme_setting_tile.dart
│       │       └── notification_setting_tile.dart
│       └── providers/
│           └── settings_providers.dart
│
└── shared/
    ├── widgets/
    │   ├── logo_image.dart                         # Logo.dev image with letter avatar fallback
    │   ├── empty_state.dart                        # Empty state with Subly character
    │   ├── loading_indicator.dart
    │   └── subly_character.dart                    # Rive character widget (placeholder-ready)
    └── providers/
        └── shared_providers.dart                   # Database instance, shared services
```

---

## Data Models

### Subscription (Freezed)

```dart
@freezed
class Subscription with _$Subscription {
  const factory Subscription({
    required String id,                    // UUID
    required String name,
    required double price,
    required String currency,              // 'EUR' or 'USD'
    required BillingCycle billingCycle,     // weekly, monthly, yearly
    required SubscriptionCategory category,
    required DateTime startDate,
    required DateTime nextBillingDate,
    String? description,
    String? domain,                        // For Logo.dev lookup
    String? brandColor,                    // Hex color for letter avatar fallback
    String? catalogItemId,                 // Reference to catalog if created from it
    bool? isActive,                        // Default true
    DateTime? cancelledDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Subscription;
}
```

### BillingCycle (Enum)

```dart
enum BillingCycle {
  weekly,
  monthly,
  yearly;

  // Helper to normalize any subscription cost to monthly
  double toMonthly(double price) => switch (this) {
    weekly => price * 4.33,
    monthly => price,
    yearly => price / 12,
  };

  // Helper to normalize to yearly
  double toYearly(double price) => switch (this) {
    weekly => price * 52,
    monthly => price * 12,
    yearly => price,
  };
}
```

### SubscriptionCategory (Enum)

```dart
enum SubscriptionCategory {
  streaming,       // Netflix, Disney+, etc.
  music,           // Spotify, Apple Music, etc.
  gaming,          // Xbox Game Pass, PS Plus, etc.
  software,        // Adobe, Microsoft 365, etc.
  cloud,           // iCloud, Google One, Dropbox, etc.
  news,            // NYT, WSJ, etc.
  fitness,         // Gym, Peloton, etc.
  food,            // Meal kits, delivery passes, etc.
  education,       // Coursera, Skillshare, etc.
  finance,         // Banking, budgeting tools, etc.
  shopping,        // Amazon Prime, etc.
  productivity,    // Notion, Todoist, etc.
  social,          // LinkedIn Premium, dating apps, etc.
  vpn,             // NordVPN, ExpressVPN, etc.
  other;           // Catch-all

  // Each category has an associated icon and color — see Category Colors in Branding section
}
```

### CatalogItem (Freezed)

```dart
@freezed
class CatalogItem with _$CatalogItem {
  const factory CatalogItem({
    required String id,
    required String name,
    required String domain,               // For Logo.dev
    required String brandColor,           // Hex color
    required double defaultPriceUsd,
    required double defaultPriceEur,
    required SubscriptionCategory category,
    required BillingCycle defaultCycle,
  }) = _CatalogItem;

  factory CatalogItem.fromJson(Map<String, dynamic> json) =>
      _$CatalogItemFromJson(json);
}
```

---

## Drift Database Schema

```dart
class SubscriptionsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  RealColumn get price => real()();
  TextColumn get currency => text().withLength(min: 3, max: 3)();
  TextColumn get billingCycle => textEnum<BillingCycle>()();
  TextColumn get category => textEnum<SubscriptionCategory>()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get nextBillingDate => dateTime()();
  TextColumn get description => text().nullable()();
  TextColumn get domain => text().nullable()();
  TextColumn get brandColor => text().nullable()();
  TextColumn get catalogItemId => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get cancelledDate => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
```

### Key DAO Queries

The SubscriptionsDao should implement:

- `watchAllActive()` — Stream<List<Subscription>> of all active subscriptions
- `watchAllCancelled()` — Stream<List<Subscription>> for cancelled subs
- `getById(String id)` — Single subscription
- `insertSubscription(...)` — Create new
- `updateSubscription(...)` — Update existing
- `deleteSubscription(String id)` — Hard delete
- `cancelSubscription(String id, DateTime cancelledDate)` — Soft cancel
- `watchTotalMonthlySpend()` — Stream<double> aggregating all active normalized to monthly
- `watchSpendByCategory()` — Stream<Map<SubscriptionCategory, double>>
- `watchUpcomingRenewals(int days)` — Subscriptions renewing within N days
- `watchMonthlySpendHistory(int months)` — Historical monthly totals for trend chart

---

## Logo.dev Integration

### LogoImage Widget

Create a shared widget `LogoImage` that:

1. Takes a `domain` (nullable) and `brandColor` (nullable) and `name`
2. If `domain` is not null, renders a `CachedNetworkImage` with URL: `https://img.logo.dev/{domain}?token={API_TOKEN}&format=png&size=80`
3. On error or if `domain` is null, falls back to a circular letter avatar:
   - Background color from `brandColor` (or a default grey)
   - White text with first letter of `name`
4. Store the Logo.dev API token in a constants file (user provides their own free token)

### Caching Strategy

- `cached_network_image` handles disk caching automatically
- Logos are fetched once and served from cache on subsequent loads
- This keeps Logo.dev API usage minimal (well under 500k free tier)
- Set a reasonable cache duration (e.g., 30 days via `CacheManager` config)

---

## Subscription Catalog (catalog.json)

Populate with 100+ popular services. Each entry:

```json
{
  "id": "netflix",
  "name": "Netflix",
  "domain": "netflix.com",
  "brandColor": "#E50914",
  "defaultPriceUsd": 15.49,
  "defaultPriceEur": 13.99,
  "category": "streaming",
  "defaultCycle": "monthly"
}
```

### Catalog Entries to Include

**Streaming (Video)**
Netflix, Disney+, Hulu, HBO Max (Max), Amazon Prime Video, Apple TV+, Paramount+, Peacock, Crunchyroll, MUBI, Curiosity Stream, Discovery+, BritBox, Shudder, AMC+, Tubi (premium), YouTube Premium, Viki

**Music & Audio**
Spotify, Apple Music, YouTube Music, Tidal, Deezer, Amazon Music Unlimited, SoundCloud Go, Audible, Pandora, iHeartRadio

**Gaming**
Xbox Game Pass Ultimate, PlayStation Plus, Nintendo Switch Online, EA Play, Ubisoft+, GeForce Now, Humble Bundle Monthly, Apple Arcade, Google Play Pass

**Software & Tools**
Adobe Creative Cloud, Microsoft 365, AutoCAD, Sketch, Figma (paid), Canva Pro, 1Password, LastPass, Bitwarden Premium, Grammarly Premium, Notion Plus, Slack Pro, Zoom Pro, GitHub Pro, JetBrains All Products, Setapp

**Cloud Storage**
iCloud+, Google One, Dropbox Plus, OneDrive (standalone), pCloud, Backblaze

**News & Media**
The New York Times, The Washington Post, The Wall Street Journal, The Economist, The Atlantic, Bloomberg, Financial Times, Medium, Substack (average), The Guardian (supporter)

**Fitness & Health**
Peloton, Strava Premium, MyFitnessPal Premium, Headspace, Calm, Noom, Fitbit Premium, Nike Training Club (premium)

**Food & Delivery**
DoorDash DashPass, Uber Eats Pass, Grubhub+, HelloFresh, Blue Apron, Instacart+

**Education**
Coursera Plus, Skillshare, MasterClass, Duolingo Super, LinkedIn Learning, Brilliant, Blinkist

**Productivity**
Todoist Pro, Evernote Personal, Bear Pro, Obsidian Sync, Fantastical, Things 3 (subscription if applicable), Pocket Premium, IFTTT Pro

**Finance**
YNAB (You Need A Budget), Mint Premium, Copilot, Personal Capital, Quicken

**Shopping & Memberships**
Amazon Prime, Costco, Walmart+, Target Circle 360, eBay Store

**VPN & Security**
NordVPN, ExpressVPN, Surfshark, ProtonVPN, Mullvad, CyberGhost

**Social & Dating**
LinkedIn Premium, Twitter/X Premium, Tinder Plus/Gold, Bumble Premium, Hinge Preferred

**Communication**
WhatsApp Business, Telegram Premium, Discord Nitro

**AI Tools**
ChatGPT Plus, Claude Pro, Midjourney, Perplexity Pro, Jasper, Copy.ai, GitHub Copilot

---

## Screen Flows & Navigation

### Navigation Structure

Bottom navigation bar with 4 tabs:
1. **Dashboard** — Overview with total spend, category breakdown, upcoming renewals, Subly insights
2. **Subscriptions** — List of all active (and toggle to see cancelled)
3. **Stats** — Detailed charts and statistics
4. **Settings** — Currency, theme, notifications, about

### Key User Flows

#### Adding a Subscription
1. User taps FAB (floating action button) on Subscriptions tab (or Dashboard)
2. Opens Catalog Search Screen — search bar at top, categories below, popular items
3. User either:
   - **Selects from catalog** → Pre-fills name, domain, brandColor, default price, category, cycle → Goes to Add/Edit screen with pre-filled fields for confirmation/adjustment
   - **Taps "Add Custom"** → Goes to Add/Edit screen with empty fields
4. User confirms/edits: name, price, currency, billing cycle, category, start date, next billing date
5. Save → Returns to Subscriptions list
6. Notification scheduled for next billing date (if notifications enabled)

#### Editing a Subscription
1. User taps a subscription in the list
2. Opens Subscription Detail screen (read view with all info, logo, spend stats for this sub)
3. User taps Edit button
4. Opens Add/Edit screen in edit mode with pre-filled data
5. Save → Returns to detail screen

#### Cancelling a Subscription
1. From detail screen, user taps "Cancel Subscription"
2. Confirmation dialog
3. Subscription marked as cancelled with date, moved to cancelled section
4. Subly celebrates the savings ("Nice! That saves you $X/month!")

#### Viewing Stats
1. Stats screen shows:
   - Monthly trend line chart (last 6-12 months)
   - Category donut chart
   - Cost per day breakdown
   - Most expensive subscription
   - Average cost per subscription
   - Total active count

### GoRouter Configuration

```
/                           → Dashboard (default tab)
/subscriptions              → Subscriptions list
/subscriptions/add          → Catalog search → Add flow
/subscriptions/add/custom   → Add custom subscription form
/subscriptions/:id          → Subscription detail
/subscriptions/:id/edit     → Edit subscription form
/stats                      → Stats screen
/settings                   → Settings screen
/onboarding                 → Onboarding flow (first launch only)
```

Use `StatefulShellRoute` for the bottom navigation to preserve tab state.

---

## Dashboard Design

The Dashboard screen is the home tab and should give a clear financial overview at a glance.

### Layout (scrollable column):

1. **Header** — "Good morning!" or time-appropriate greeting + Subly character (small, animated idle)
2. **Total Monthly Spend Card** — Large prominent number, with yearly estimate below. Color-coded (green if under some threshold, orange/red if high). Show selected currency.
3. **Upcoming Renewals Card** — Next 3 subscriptions to renew, with dates and amounts. Tappable to see full list.
4. **Category Breakdown** — Small donut chart with top 3-4 categories labeled. Tap to go to full Stats.
5. **Subly Insight Card** — One contextual tip or observation, e.g.:
   - "You have 3 streaming services totaling $35/mo. Need all of them?"
   - "Your spending went up 15% this month."
   - "You haven't used [X] — consider cancelling?"
   - (For v1, these can be rule-based, not AI-generated)

---

## Notification System

### Renewal Reminders

- When a subscription is added/edited, schedule a local notification for 1 day before `nextBillingDate`
- After notification fires, calculate and schedule the next one based on billing cycle
- User can toggle notifications on/off globally in Settings
- User can toggle notifications per subscription in detail screen

### Implementation

- Use `flutter_local_notifications` with `timezone` package
- Create a `NotificationService` singleton/provider that handles:
  - `scheduleRenewalReminder(Subscription sub)`
  - `cancelReminder(String subscriptionId)`
  - `rescheduleAllReminders()` — for app startup or bulk changes
- Notification payload includes subscription ID for deep-linking to detail screen

---

## Branding & Visual Identity

### Brand Name
**Subly** — a friendly assistant character (coin-shaped mascot) that helps you track and manage subscriptions.

### Brand Personality
- Helpful, approachable, financially savvy
- Clean & minimal aesthetic — not a cold finance tool, not overly playful
- Confident and trustworthy, with moments of warmth from the mascot

### Typography
**Plus Jakarta Sans** (via `google_fonts` package) everywhere:
- **Display/Headers:** 800 (ExtraBold), letter-spacing: -0.5px
- **Section titles:** 700 (Bold)
- **Body:** 500 (Medium)
- **Labels/captions:** 600 (SemiBold), uppercase with 0.5px letter-spacing where appropriate
- **Numbers/prices:** 700-800 (Bold-ExtraBold), letter-spacing: -0.5px for large numbers

### Color Palette — "Indigo Night"

#### Primary Colors
| Token              | Hex       | Usage                                         |
|--------------------|-----------|-----------------------------------------------|
| `primary`          | `#4F46E5` | Main brand color, buttons, active states, FAB  |
| `primaryLight`     | `#818CF8` | Hover states, secondary elements, dark mode accents |
| `primaryDark`      | `#3730A3` | Gradient endpoints, pressed states, emphasis   |
| `primaryBg`        | `#EEF2FF` | Light tinted backgrounds, selected states      |

#### Accent & Semantic Colors
| Token              | Hex       | Usage                                         |
|--------------------|-----------|-----------------------------------------------|
| `accent`           | `#F59E0B` | Highlights, badges, Subly character accents    |
| `success`          | `#10B981` | Savings, positive stats, cancellation savings  |
| `warning`          | `#F59E0B` | Upcoming renewals, spending increases          |
| `danger`           | `#EF4444` | Overspending alerts, delete actions            |

#### Light Mode Surfaces
| Token              | Hex       | Usage                                         |
|--------------------|-----------|-----------------------------------------------|
| `background`       | `#F8F9FF` | App background (slight indigo tint)            |
| `surface`          | `#FFFFFF` | Cards, sheets, dialogs                         |
| `border`           | `#E5E7EB` | Dividers, card borders                         |
| `textPrimary`      | `#1A1A2E` | Main text                                      |
| `textSecondary`    | `#6B7280` | Subtitles, labels, dates                       |

#### Dark Mode Surfaces
| Token              | Hex       | Usage                                         |
|--------------------|-----------|-----------------------------------------------|
| `backgroundDark`   | `#0F0F23` | App background                                 |
| `surfaceDark`      | `#1A1A36` | Cards, sheets, dialogs                         |
| `borderDark`       | `#2D2D44` | Dividers, card borders                         |
| `textPrimaryDark`  | `#F3F4F6` | Main text                                      |
| `textSecondaryDark`| `#9CA3AF` | Subtitles, labels, dates                       |

#### Category Colors (for charts & category icons)
| Category       | Color     |
|----------------|-----------|
| Streaming      | `#EF4444` |
| Music          | `#22C55E` |
| Gaming         | `#8B5CF6` |
| Software       | `#3B82F6` |
| Cloud          | `#06B6D4` |
| News           | `#64748B` |
| Fitness        | `#F97316` |
| Food           | `#EAB308` |
| Education      | `#14B8A6` |
| Finance        | `#10B981` |
| Shopping       | `#EC4899` |
| Productivity   | `#6366F1` |
| Social         | `#F43F5E` |
| VPN            | `#0EA5E9` |
| Other          | `#9CA3AF` |

### Gradients
- **Primary gradient** (spend cards, headers): `linear-gradient(135deg, #4F46E5, #3730A3)`
- **Accent gradient** (special highlights): `linear-gradient(135deg, #4F46E5, #818CF8)`
- Gradients should have a subtle decorative circle (rgba white 0.1) in the top-right for depth

### App Icon
- Rounded square (follows platform conventions — iOS superellipse, Android adaptive)
- Background: Primary gradient (#4F46E5 → #3730A3) at 135°
- Foreground: Subly coin character face in white/semi-transparent white
- The coin has a dashed inner border (rgba white 0.4) and simple dot eyes + small curved mouth

### Subly Character Design Specs
- **Shape:** Coin/circle — reinforces the money/finance theme
- **Body color:** Primary (#4F46E5) in light mode, primaryLight (#818CF8) in dark mode
- **Inner ring:** Dashed circle border at rgba(255,255,255,0.4) to suggest a coin edge
- **Eyes:** Two small white circles/dots, slightly above center
- **Mouth:** Small curved white line below eyes
- **Expressions via Rive (v2):**
  - `idle` — gentle bobbing, eyes blink occasionally
  - `happy` — eyes squint into arcs, slight bounce
  - `concerned` — eyes shift, slight wobble
  - `celebrating` — big bounce, sparkle effects
  - `thinking` — eyes look up, subtle tilt

### UI Design Tokens
```
Border radius (cards): 16px
Border radius (buttons): 12px
Border radius (inputs): 10px
Border radius (small chips/tags): 100px (pill)
Card shadow (light): 0 1px 3px rgba(0,0,0,0.04)
Card shadow (elevated): 0 12px 40px rgba(0,0,0,0.1)
Spacing unit: 4px (use multiples: 8, 12, 16, 20, 24, 32, 40, 48)
Bottom nav height: 64px
FAB position: bottom-right, 16px from edges
```

### Dark Mode
- Full dark mode support via ThemeData
- User toggles in Settings (system default, light, dark)
- Stored in SharedPreferences
- Primary color stays the same, use `primaryLight` (#818CF8) for text accents in dark mode
- Prices in subscription list use `primaryLight` in dark mode for readability

---

## Subly Character Integration (v1 — Placeholder Ready)

For v1, the Subly character is a **placeholder** — the architecture is in place but the actual Rive animation will be added later.

### SublyCharacter Widget

Create a `SublyCharacter` widget that:
- Accepts a `SublyMood` enum: `idle`, `happy`, `concerned`, `celebrating`, `thinking`
- Accepts a `size` parameter
- **v1 implementation:** Renders the coin character using `CustomPainter` — circle body in primary color (#4F46E5), dashed inner ring at rgba white 0.4, two white dot eyes, small curved white mouth. Expression changes are simple (e.g., eye shape changes for happy/concerned).
- **v2 implementation:** Swap in Rive asset with state machine, zero API changes needed. See character expressions in Branding section.

### Where Subly Appears
- Dashboard insight card (small, with speech bubble)
- Empty states ("No subscriptions yet! Let's add your first one")
- Onboarding screens
- Cancellation celebration
- Loading states (optional)

---

## Implementation Phases

Execute these phases sequentially. Each phase should result in a buildable, runnable app.

### Phase 1: Project Setup & Data Layer
1. Create Flutter project: `flutter create subly`
2. Set up the folder structure as defined above
3. Add all dependencies to `pubspec.yaml`
4. Set up the theme (light + dark) in `app/theme/` using the Indigo Night palette and design tokens from the Branding section. Use Plus Jakarta Sans via google_fonts package.
5. Define enums: `BillingCycle`, `SubscriptionCategory` (with icons, colors, display names)
6. Define Freezed models: `Subscription`, `CatalogItem`
7. Set up Drift database: `SubscriptionsTable`, `AppDatabase`, `SubscriptionsDao` with all queries
8. Create `SubscriptionRepository` abstracting the DAO
9. Set up Riverpod providers for database instance and repository
10. Run `build_runner` to generate all code
11. **Verify:** App builds and runs (blank screen is fine), database creates successfully

### Phase 2: Core UI & Navigation
1. Set up GoRouter with `StatefulShellRoute` for bottom navigation (4 tabs)
2. Create shell/scaffold with bottom nav bar
3. Create placeholder screens for all 4 tabs
4. Build Subscriptions List screen:
   - Stream-based list from `watchAllActive()` provider
   - `SubscriptionListTile` widget with logo, name, price, next billing date
   - FAB for adding
   - Toggle to show cancelled subscriptions
   - Empty state
5. Build Add/Edit Subscription screen:
   - Form with all fields (name, price, currency picker, billing cycle picker, category picker, start date, next billing date, description)
   - Save creates/updates via repository
   - Validation (required fields, price > 0, dates make sense)
6. Build Subscription Detail screen:
   - Full info display with large logo
   - Monthly/yearly cost display
   - Edit button, Cancel/Delete actions
7. Build `LogoImage` shared widget with Logo.dev + letter avatar fallback
8. **Verify:** Can add, view, edit, cancel, and delete subscriptions. List updates reactively.

### Phase 3: Subscription Catalog
1. Create and populate `catalog.json` with 100+ services (full list above)
2. Create `CatalogData` class to load and parse the JSON from assets
3. Create Riverpod providers for catalog access
4. Build Catalog Search screen:
   - Search bar with real-time filtering by name
   - Grouped by category with section headers
   - Each tile shows logo (via LogoImage), name, default price
   - "Add Custom" option at top or bottom
5. Integrate into the Add flow:
   - FAB → Catalog Search → Select item → Add/Edit screen pre-filled
   - FAB → Catalog Search → "Add Custom" → Add/Edit screen empty
6. **Verify:** Can browse catalog, search, select, and create subscription from catalog item with pre-filled data.

### Phase 4: Dashboard
1. Build Dashboard screen layout (scrollable column of cards)
2. Create dashboard providers that aggregate data:
   - Total monthly spend (all active subs normalized to monthly)
   - Total yearly spend
   - Upcoming renewals (next 7 days)
   - Spend by category
3. Build `TotalSpendCard` — prominent monthly number + yearly estimate
4. Build `UpcomingRenewalsCard` — next 3 renewals with countdown
5. Build `CategoryBreakdownChart` — small donut chart using fl_chart
6. Build `SublyInsightCard` — rule-based insights:
   - Multiple subs in same category → suggest review
   - Spending increased from last month → notify
   - Subscription not marked as cancelled but might be old
   - Total spend milestones
7. **Verify:** Dashboard shows accurate real-time data, charts render correctly, insights are contextual.

### Phase 5: Stats Screen
1. Build Stats screen layout
2. Create stats providers:
   - Monthly spend history (last 12 months)
   - Category breakdown with amounts and percentages
   - Cost per day (total monthly / 30)
   - Most expensive subscription
   - Average cost per subscription
   - Active subscription count
3. Build `MonthlyTrendChart` — line chart with fl_chart showing last 6-12 months
4. Build `CategoryPieChart` — full donut chart with legend
5. Build `CostPerDayCard`, `MostExpensiveCard`, `AverageCostCard`
6. Add period selector (monthly/yearly view toggle)
7. **Verify:** All stats compute correctly, charts are interactive (tap for details), edge cases handled (0 subscriptions, 1 subscription, all same category).

### Phase 6: Notifications & Settings
1. Set up `flutter_local_notifications` with platform-specific config (Android channel, iOS permissions)
2. Create `NotificationService`:
   - Schedule reminder 1 day before next billing date
   - Cancel/reschedule on edit
   - Recalculate next billing date after notification fires
3. Build Settings screen:
   - Default currency picker (EUR/USD)
   - Theme selector (System/Light/Dark)
   - Notifications toggle (global on/off)
   - About section (app version, credits)
4. Persist settings via SharedPreferences with Riverpod providers
5. **Verify:** Notifications fire at correct times, settings persist across app restarts.

### Phase 7: Onboarding & Polish
1. Build Onboarding screen (3-4 pages):
   - "Meet Subly" — character introduction
   - "Track Everything" — show subscription tracking concept
   - "Stay in Control" — insights and notifications
   - "Get Started" → navigate to Dashboard or Add first subscription
2. Show onboarding only on first launch (SharedPreferences flag)
3. Add `SublyCharacter` placeholder widget (static illustration or simple CustomPainter)
4. Place Subly in: dashboard insight card, empty states, onboarding
5. Add animations/transitions between screens (Hero animations for logos, page transitions)
6. Polish empty states, error states, loading states
7. Review and refine all UI spacing, typography, color consistency
8. **Verify:** Complete user flow from first launch through onboarding to active daily use works smoothly.

---

## Code Architecture Rules

### Clean Architecture Principles
- **Strict separation of concerns:** Data layer (repositories, DAOs, data sources) → Domain layer (models, enums) → Presentation layer (screens, widgets, providers)
- **Dependency inversion:** Screens depend on providers, providers depend on repositories, repositories depend on DAOs. Never skip layers.
- **Single responsibility:** Each class/file does one thing.

### Widget Rules — CRITICAL
- **NEVER use widget builder methods** like `Widget _buildHeader()`, `Widget _buildCard()`, or `Widget _buildListItem()` inside a screen or widget class. This is an anti-pattern.
- **ALWAYS extract widgets into separate files.** Every visual component gets its own file and class. No exceptions.
- Example — **WRONG:**
  ```dart
  class DashboardScreen extends ConsumerWidget {
    Widget _buildSpendCard() { ... }     // ❌ NEVER DO THIS
    Widget _buildRenewalsList() { ... }  // ❌ NEVER DO THIS
  }
  ```
- Example — **CORRECT:**
  ```dart
  // screens/dashboard_screen.dart
  class DashboardScreen extends ConsumerWidget {
    Widget build(context, ref) {
      return Column(children: [
        TotalSpendCard(),         // ✅ Separate widget file
        UpcomingRenewalsCard(),   // ✅ Separate widget file
      ]);
    }
  }

  // widgets/total_spend_card.dart
  class TotalSpendCard extends ConsumerWidget { ... }

  // widgets/upcoming_renewals_card.dart
  class UpcomingRenewalsCard extends ConsumerWidget { ... }
  ```
- **Screen files should be thin** — they compose widgets and handle navigation, nothing more. All visual building blocks live in the `widgets/` folder as individual files.
- **Reusable widgets go in `shared/widgets/`**, feature-specific widgets go in `features/{feature}/presentation/widgets/`.
- **Naming convention:** File name matches class name in snake_case. One public widget class per file.

### Provider Rules
- Use Riverpod code generation (`@riverpod` annotation) for all providers
- Keep providers focused — one provider per concern (e.g., `subscriptionsListProvider`, `totalMonthlySpendProvider`, `upcomingRenewalsProvider`)
- Business logic lives in providers and repositories, NEVER in widgets
- Widgets only read providers and call methods — no computation in build methods

### Repository Pattern
- Every data operation goes through a repository
- Repositories abstract the data source (Drift DAO now, could be API later)
- Repositories return domain models (Freezed classes), never raw database entities
- This is what makes adding cloud sync in v2 straightforward — swap the repository implementation, UI doesn't change

### File Organization
- One class per file (with the exception of small related enums/typedefs)
- No file should exceed ~200 lines — if it does, it needs to be split
- Barrel files (`index.dart`) per feature are optional but encouraged for cleaner imports



### Next Billing Date Calculation
When a notification fires or when viewing subscriptions, the app needs to compute the next billing date based on the cycle:
- **Weekly:** Add 7 days
- **Monthly:** Add 1 month (handle month-end edge cases: Jan 31 → Feb 28)
- **Yearly:** Add 1 year
- After each billing cycle passes, automatically advance `nextBillingDate` in the database

### Currency Handling
- Store prices in the currency selected at time of entry
- Display in the user's preferred display currency
- For v1, no real-time conversion — just display each sub in its stored currency
- The totals on Dashboard/Stats should group by currency or convert using a static approximate rate with a disclaimer
- Consider: let user enter a manual EUR/USD rate in settings for simple conversion

### Reactive Architecture
- All list/stat screens should use `StreamProvider` (Riverpod) watching Drift streams
- Changes to subscriptions automatically propagate to dashboard, stats, and lists
- No manual refresh needed

### Testing Considerations
- Unit test: BillingCycle calculations, currency formatting, next billing date logic
- Unit test: DAO queries return expected results with mock data
- Widget test: Key screens render correctly with test data
- Integration test: Full add → view → edit → cancel flow
