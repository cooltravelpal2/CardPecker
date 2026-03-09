import Foundation
import SwiftData

@Observable
final class RecommendationViewModel {
    let category: SpendingCategory
    private var modelContext: ModelContext

    var recommendations: [CardRecommendation] = []

    var bestCard: CardRecommendation? {
        recommendations.first
    }

    var otherCards: [CardRecommendation] {
        Array(recommendations.dropFirst())
    }

    var hasNoCards: Bool {
        recommendations.isEmpty
    }

    init(category: SpendingCategory, modelContext: ModelContext) {
        self.category = category
        self.modelContext = modelContext
        loadRecommendations()
    }

    func loadRecommendations() {
        let descriptor = FetchDescriptor<Card>()
        let cards = (try? modelContext.fetch(descriptor)) ?? []
        recommendations = RewardsCalculator.recommend(for: category.id, cards: cards)
    }
}
