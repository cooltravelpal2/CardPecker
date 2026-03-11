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