# CardPecker — Credit Card Recommendation App

## Overview

CardPecker is an iOS app that helps users find the best credit card to use for any spending category. Users tap a category (e.g., "Dining"), and the app recommends the optimal card from their personal wallet based on effective rewards value. All data is stored locally on-device — no remote data storage or collection.

---

## Core Concepts

### Rewards Valuation Model

Each card earns points/cashback at a category-specific multiplier, and each rewards currency has a redemption value (cents per point). The **effective return** is:

```
effective_cents_per_dollar = multiplier × point_value_in_cents
```

**Example — Chase Sapphire Reserve (Dining):**

- Earns: 3× Ultimate Rewards points per $1
- Point value: 1.5¢ per point (via Pay Yourself Back / transfer partners)
- Effective return: 3 × 1.5¢ = **4.5¢ per dollar (4.5%)**

The app ranks all of the user's cards by effective return for the selected category and surfaces the best option.

---

## Information Architecture

```
┌─────────────────────────────────────┐
│          Category Screen            │  ← Main / Home
│  ┌───────┐  ┌───────┐  ┌───────┐   │
│  │Hotel  │  │Dining │  │Grocery│   │
│  └───────┘  └───────┘  └───────┘   │
│  ┌───────┐  ┌───────┐  ┌───────┐   │
│  │Shopng │  │Airline│  │Gas    │   │
│  └───────┘  └───────┘  └───────┘   │
│  ┌───────┐  ┌───────┐              │
│  │Rental │  │Foreign│  [⚙ Settings]│
│  └───────┘  └───────┘              │
└─────────────────────────────────────┘
          │ tap category
          ▼
┌─────────────────────────────────────┐
│  [← Back]  Recommendation Screen    │
│                                     │
│  ┌─────────────────────────────┐    │
│  │  🏆 Best Card               │    │
│  │  Chase Sapphire Reserve     │    │
│  │  3× pts · 1.5¢/pt · 4.5%   │    │
│  └─────────────────────────────┘    │
│                                     │
│  Other Cards (ranked)               │
│  ┌─────────────────────────────┐    │
│  │  Amex Gold — 4× · 1.0¢ · 4%│    │
│  │  Citi Double — 2× · 1.0¢·2%│    │
│  └─────────────────────────────┘    │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│  [← Back]  Settings                 │
│                                     │
│  ┌─────────────────────────────┐    │
│  │  My Cards →                 │    │
│  │  My Categories →            │    │
│  └─────────────────────────────┘    │
└─────────────────────────────────────┘
```

---

## Screens

### 1. Category Screen (Home)

The main screen users see on launch. Displays a grid of spending categories.

**Layout:**
- Navigation bar title: "CardPecker"
- Top-right: Settings gear icon (⚙) — navigates to Settings
- Body: Grid of category tiles (2–3 columns)
- Each tile shows an SF Symbol icon and label

**Categories (default set, user-editable):**

| Category | SF Symbol | Description |
|----------|-----------|-------------|
| Hotel | bed.double | Hotels, lodging |
| Dining | fork.knife | Restaurants, bars, cafes |
| Grocery | cart | Supermarkets |
| Shopping | bag | General retail, e-commerce |
| Airline | airplane | Flights |
| Gas | fuelpump | Gas stations |
| Rental | car | Car rental |
| Foreign Transactions | globe | Purchases in foreign currency |

Users can add, edit, and remove categories in Settings → My Categories.

**Behavior:**
- Tapping a category pushes the Recommendation Screen
- Tapping ⚙ pushes the Settings screen
- If user has zero cards saved, show an empty state prompting them to add cards in Settings

### 2. Recommendation Screen

Shows the best card to use for the selected category, plus a ranked list of alternatives.

**Layout:**
- Navigation: Back button (←) returns to Category Screen
- Header: Category name + icon
- Hero card: The top-ranked card, displayed prominently
- Ranked list: Remaining cards sorted by effective return (descending)

**Card Display (each entry shows):**
- Card name (e.g., "Chase Sapphire Reserve")
- Category multiplier (e.g., "3× points")
- Point valuation (e.g., "1.5¢ per point")
- Effective return (e.g., "4.5% back")
- Optional: Card color accent

**Ranking Logic:**
1. For the selected category, look up each card's multiplier
2. Multiply by the card's point value → effective return
3. Sort descending; top result is the hero card
4. Ties: sort alphabetically by card name

**Edge Cases:**
- Card has no specific multiplier for category → use base rate (1×)
- User has only one card → still show it as the best option
- User has no cards → prompt to add cards via Settings

### 3. Settings Screen

Hub for managing cards and categories. Reached via ⚙ button on the Category Screen.

**Layout:**
- Navigation: Back button (←) returns to Category Screen
- Title: "Settings"
- Two navigation links: "My Cards" and "My Categories"

### 4. My Cards Screen

Manages the user's card wallet.

**Layout:**
- Title: "My Cards"
- "+" button at top-right to add a card
- List of saved cards, each with swipe-to-delete

**Add / Edit Card Flow (modal or pushed screen):**

Fields:
- **Card Name** (text, required) — e.g., "Chase Sapphire Reserve"
- **Rewards Currency** (text) — e.g., "Ultimate Rewards"
- **Point Value** (decimal, required) — cents per point, e.g., 1.5
- **Category Multipliers** (table of category → multiplier):
  - Pre-populated with all current categories
  - Each row: Category label + multiplier input (default: 1)
  - User overrides only the categories where the card earns a bonus
- **Card Color** (optional) — accent color for display

**Delete Card:**
- Swipe-to-delete
- Confirmation alert before removal

### 5. My Categories Screen

Manages spending categories. Users can add, edit, and remove categories.

**Layout:**
- Title: "My Categories"
- "+" button at top-right to add a category
- List of categories sorted by display order, each with swipe-to-delete

**Add / Edit Category Flow:**

Fields:
- **Category Name** (text, required) — e.g., "Dining"
- **Icon** (SF Symbol picker) — e.g., "fork.knife"

**Delete Category:**
- Swipe-to-delete with confirmation
- Warning if deleting a default category

---

## Data Model

All data persisted locally using SwiftData.

### Card Entity

```
Card
├── id: UUID
├── name: String                        // "Chase Sapphire Reserve"
├── rewardsCurrency: String             // "Ultimate Rewards"
├── pointValueCents: Double             // 1.5
├── cardColorHex: String?               // "#003087"
├── categoryMultipliers: [CategoryMultiplier]
└── createdAt: Date
```

### CategoryMultiplier Entity

```
CategoryMultiplier
├── id: UUID
├── categoryId: UUID                    // references SpendingCategory.id
├── multiplier: Double                  // 3.0
└── card: Card                          // relationship back to parent
```

### SpendingCategory Entity (SwiftData @Model, user-editable)

```
SpendingCategory
├── id: UUID
├── name: String                        // "Dining"
├── icon: String                        // SF Symbol name, e.g., "fork.knife"
├── displayOrder: Int                   // for grid ordering
├── isDefault: Bool                     // marks built-in categories
└── createdAt: Date
```

Default categories are seeded on first launch. Users can add, edit, and remove categories.

---

## Technical Architecture

### Platform & Requirements

- **Platform:** iOS 17+
- **Language:** Swift
- **UI Framework:** SwiftUI
- **Persistence:** SwiftData (local only)
- **Architecture:** MVVM
- **Dependencies:** None (zero third-party libraries)

### Project Structure

```
CardPecker/
├── App/
│   └── CardPeckerApp.swift              // @main entry point
├── Models/
│   ├── Card.swift                       // SwiftData @Model
│   ├── CategoryMultiplier.swift         // SwiftData @Model
│   └── SpendingCategory.swift           // SwiftData @Model (user-editable)
├── ViewModels/
│   ├── CategoryViewModel.swift          // Drives Category Screen
│   ├── RecommendationViewModel.swift    // Ranking logic
│   └── CardManagementViewModel.swift    // CRUD for cards
├── Views/
│   ├── CategoryGridView.swift           // Home screen
│   ├── RecommendationView.swift         // Best card + ranked list
│   ├── SettingsView.swift               // Settings hub
│   ├── MyCardsView.swift                // Card list
│   ├── CardFormView.swift               // Add / Edit card
│   ├── MyCategoriesView.swift           // Category list
│   ├── CategoryFormView.swift           // Add / Edit category
│   └── Components/
│       ├── CategoryTile.swift           // Single category button
│       ├── CardRecommendationRow.swift  // Card result row
│       └── HeroCardView.swift           // Top recommendation display
├── Utilities/
│   ├── RewardsCalculator.swift          // Pure function: ranking logic
│   └── DefaultCategories.swift          // Seeds default categories
└── Preview Content/
    └── SampleData.swift                 // Preview / test data
```

### Navigation

```swift
NavigationStack {
    CategoryGridView()
        .navigationDestination(for: SpendingCategory.self) { category in
            RecommendationView(category: category)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gearshape")
                }
            }
        }
}
```

### Core Algorithm — RewardsCalculator

```swift
struct CardRecommendation {
    let card: Card
    let multiplier: Double
    let pointValueCents: Double
    let effectiveReturnPercent: Double  // multiplier × pointValueCents
}

func recommend(for categoryId: UUID, cards: [Card]) -> [CardRecommendation] {
    cards.map { card in
        let multiplier = card.categoryMultipliers
            .first(where: { $0.categoryId == categoryId })?
            .multiplier ?? 1.0
        let effectiveReturn = multiplier * card.pointValueCents
        return CardRecommendation(
            card: card,
            multiplier: multiplier,
            pointValueCents: card.pointValueCents,
            effectiveReturnPercent: effectiveReturn
        )
    }
    .sorted {
        if $0.effectiveReturnPercent != $1.effectiveReturnPercent {
            return $0.effectiveReturnPercent > $1.effectiveReturnPercent
        }
        return $0.card.name < $1.card.name
    }
}
```

---

## Privacy & Data Policy

- **No network calls.** The app makes zero HTTP requests.
- **No analytics or tracking.** No telemetry of any kind.
- **No remote storage.** All data lives in the on-device SwiftData store.
- **No data collection.** Nothing leaves the device.
- **App Privacy Label:** "Data Not Collected"

---

## V1 Scope & Constraints

**In scope:**
- Category grid → card recommendation flow
- Add / edit / delete cards with per-category multipliers
- Add / edit / delete spending categories
- Default categories seeded on first launch
- Local-only persistence
- Clean, native iOS feel (SF Symbols, system colors)

**Out of scope for v1 (future ideas):**
- Card database / auto-fill card details from a known card list
- Annual fee amortization in the recommendation
- Spending amount input ("I'm spending $50 at…")
- Sign-up bonus tracking
- Widget / Siri Shortcut integration
- iCloud sync across devices
- Dark mode customization beyond system default

---

## Design Notes

- Use SF Symbols for category icons (e.g., `fork.knife` for Dining, `airplane` for Airline)
- Hero card should feel visually distinct — card-shaped container with rounded corners and color accent
- Keep the UI minimal — the core interaction is: tap category → see answer
- Support Dynamic Type for accessibility
- Support both light and dark mode via system adaptive colors
