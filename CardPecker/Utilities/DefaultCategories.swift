import Foundation
import SwiftData

enum DefaultCategories {
    struct CategoryDef {
        let name: String
        let icon: String
        let color: String
        let subcategories: [(name: String, icon: String, color: String)]

        init(name: String, icon: String, color: String, subcategories: [(name: String, icon: String, color: String)] = []) {
            self.name = name
            self.icon = icon
            self.color = color
            self.subcategories = subcategories
        }
    }

    static let defaults: [CategoryDef] = [
        CategoryDef(name: "Hotel", icon: "bed.double.fill", color: "#8B5CF6", subcategories: [
            ("Hyatt", "building.2.fill", "#8B5CF6"),
            ("Marriott", "building.fill", "#DC2626"),
            ("IHG", "building.columns.fill", "#059669"),
            ("Hilton", "house.lodge.fill", "#2563EB"),
            ("Other Hotels", "bed.double", "#6B7280"),
        ]),
        CategoryDef(name: "Dining", icon: "fork.knife", color: "#EF4444"),
        CategoryDef(name: "Grocery", icon: "cart.fill", color: "#10B981"),
        CategoryDef(name: "Shopping", icon: "bag.fill", color: "#F59E0B"),
        CategoryDef(name: "Airline", icon: "airplane", color: "#3B82F6"),
        CategoryDef(name: "Gas", icon: "fuelpump.fill", color: "#6366F1"),
        CategoryDef(name: "Rental", icon: "car.fill", color: "#EC4899"),
        CategoryDef(name: "Foreign Transactions", icon: "globe.americas.fill", color: "#14B8A6"),
    ]

    static func seedIfNeeded(context: ModelContext) {
        let descriptor = FetchDescriptor<SpendingCategory>()
        let existingCount = (try? context.fetchCount(descriptor)) ?? 0
        guard existingCount == 0 else { return }

        for (index, def) in defaults.enumerated() {
            let category = SpendingCategory(
                name: def.name,
                icon: def.icon,
                iconColorHex: def.color,
                displayOrder: index,
                isDefault: true
            )
            context.insert(category)

            for (subIndex, sub) in def.subcategories.enumerated() {
                let subCategory = SpendingCategory(
                    name: sub.name,
                    icon: sub.icon,
                    iconColorHex: sub.color,
                    displayOrder: subIndex,
                    isDefault: true,
                    parentCategoryId: category.id
                )
                context.insert(subCategory)
            }
        }
        try? context.save()
    }
}

enum DefaultCards {
    struct CardDef {
        let name: String
        let currency: String
        let pointValue: Double
        let colorHex: String
        let multipliers: [String: Double] // category name -> multiplier
    }

    static let defaults: [CardDef] = [
        CardDef(
            name: "Chase Sapphire Reserve",
            currency: "Chase Ultimate Rewards",
            pointValue: 2.05,
            colorHex: "#003087",
            multipliers: ["Hotel": 4, "Dining": 3, "Airline": 4]
        ),
        CardDef(
            name: "AMEX Platinum",
            currency: "American Express Membership Rewards",
            pointValue: 2.0,
            colorHex: "#A5A7AA",
            multipliers: ["Airline": 5]
        ),
        CardDef(
            name: "Capital One Venture X",
            currency: "Capital One Miles",
            pointValue: 1.85,
            colorHex: "#004977",
            multipliers: [
                "Hotel": 2, "Dining": 2, "Grocery": 2, "Shopping": 2,
                "Airline": 2, "Gas": 2, "Rental": 2, "Foreign Transactions": 2,
            ]
        ),
        CardDef(
            name: "Citi Strata Premier",
            currency: "Citi ThankYou Points",
            pointValue: 1.9,
            colorHex: "#003DA5",
            multipliers: ["Hotel": 3, "Dining": 3, "Grocery": 3, "Airline": 3, "Gas": 3]
        ),
    ]

    static func seedIfNeeded(context: ModelContext) {
        let cardDescriptor = FetchDescriptor<Card>()
        let existingCount = (try? context.fetchCount(cardDescriptor)) ?? 0
        guard existingCount == 0 else { return }

        // Fetch all categories to map names to IDs
        let catDescriptor = FetchDescriptor<SpendingCategory>()
        let categories = (try? context.fetch(catDescriptor)) ?? []
        let categoryMap = Dictionary(uniqueKeysWithValues: categories.map { ($0.name, $0.id) })

        for def in defaults {
            let card = Card(
                name: def.name,
                rewardsCurrency: def.currency,
                pointValueCents: def.pointValue,
                cardColorHex: def.colorHex
            )
            context.insert(card)

            for (categoryName, multiplier) in def.multipliers {
                // Apply to parent category
                if let catId = categoryMap[categoryName] {
                    let cm = CategoryMultiplier(categoryId: catId, multiplier: multiplier)
                    cm.card = card
                    context.insert(cm)
                }
                // Also apply to subcategories of this parent
                let parent = categories.first(where: { $0.name == categoryName })
                if let parentId = parent?.id {
                    let subs = categories.filter { $0.parentCategoryId == parentId }
                    for sub in subs {
                        let cm = CategoryMultiplier(categoryId: sub.id, multiplier: multiplier)
                        cm.card = card
                        context.insert(cm)
                    }
                }
            }
        }
        try? context.save()
    }
}
