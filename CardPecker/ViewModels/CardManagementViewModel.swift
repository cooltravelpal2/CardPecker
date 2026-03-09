import Foundation
import SwiftData

@Observable
final class CardManagementViewModel {
    private var modelContext: ModelContext

    var cards: [Card] = []
    var categories: [SpendingCategory] = []

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchCards()
        fetchCategories()
    }

    func fetchCards() {
        let descriptor = FetchDescriptor<Card>(
            sortBy: [SortDescriptor(\.name)]
        )
        cards = (try? modelContext.fetch(descriptor)) ?? []
    }

    func fetchCategories() {
        let descriptor = FetchDescriptor<SpendingCategory>(
            sortBy: [SortDescriptor(\.displayOrder)]
        )
        categories = (try? modelContext.fetch(descriptor)) ?? []
    }

    func addCard(name: String, rewardsCurrency: String, pointValueCents: Double, cardColorHex: String?, multipliers: [UUID: Double]) {
        let card = Card(
            name: name,
            rewardsCurrency: rewardsCurrency,
            pointValueCents: pointValueCents,
            cardColorHex: cardColorHex
        )
        modelContext.insert(card)

        for (categoryId, multiplier) in multipliers {
            let cm = CategoryMultiplier(categoryId: categoryId, multiplier: multiplier)
            cm.card = card
            modelContext.insert(cm)
        }

        try? modelContext.save()
        fetchCards()
    }

    func updateCard(_ card: Card, name: String, rewardsCurrency: String, pointValueCents: Double, cardColorHex: String?, multipliers: [UUID: Double]) {
        card.name = name
        card.rewardsCurrency = rewardsCurrency
        card.pointValueCents = pointValueCents
        card.cardColorHex = cardColorHex

        // Remove old multipliers
        for cm in card.categoryMultipliers {
            modelContext.delete(cm)
        }
        card.categoryMultipliers = []

        // Add new multipliers
        for (categoryId, multiplier) in multipliers {
            let cm = CategoryMultiplier(categoryId: categoryId, multiplier: multiplier)
            cm.card = card
            modelContext.insert(cm)
        }

        try? modelContext.save()
        fetchCards()
    }

    func deleteCard(_ card: Card) {
        modelContext.delete(card)
        try? modelContext.save()
        fetchCards()
    }
}
