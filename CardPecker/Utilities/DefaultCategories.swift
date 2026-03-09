import Foundation
import SwiftData

enum DefaultCategories {
    static let defaults: [(name: String, icon: String)] = [
        ("Hotel", "bed.double"),
        ("Dining", "fork.knife"),
        ("Grocery", "cart"),
        ("Shopping", "bag"),
        ("Airline", "airplane"),
        ("Gas", "fuelpump"),
        ("Rental", "car"),
        ("Foreign Transactions", "globe"),
    ]

    static func seedIfNeeded(context: ModelContext) {
        let descriptor = FetchDescriptor<SpendingCategory>()
        let existingCount = (try? context.fetchCount(descriptor)) ?? 0
        guard existingCount == 0 else { return }

        for (index, category) in defaults.enumerated() {
            let item = SpendingCategory(
                name: category.name,
                icon: category.icon,
                displayOrder: index,
                isDefault: true
            )
            context.insert(item)
        }
        try? context.save()
    }
}
